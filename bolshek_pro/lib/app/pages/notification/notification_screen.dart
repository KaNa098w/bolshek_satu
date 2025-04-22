import 'package:bolshek_pro/app/pages/orders/order_detail_page.dart';
import 'package:bolshek_pro/app/widgets/custom_silver_appbar.dart';
import 'package:bolshek_pro/core/models/notifications_response.dart';
import 'package:bolshek_pro/core/models/order_detail_response.dart';
import 'package:bolshek_pro/core/service/notification_service.dart';
import 'package:bolshek_pro/core/service/orders_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

/// Функция преобразования типа уведомления в читаемый локализованный формат.
String transformNotificationType(BuildContext context, String type) {
  switch (type) {
    case 'product_out_of_stock':
      return S.of(context).productOutOfStock;
    case 'order_created':
      return S.of(context).orderCreated;
    case 'order_delivered':
      return S.of(context).orderDelivered;
    case 'order_canceled':
      return S.of(context).orderCanceled;
    case 'order_refunded':
      return S.of(context).orderRefunded;
    default:
      return type;
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<NotificationsResponse> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _notificationsFuture = NotificationService()
          .getNotifications(context: context, modelId: '1');
    });
  }

  Widget _buildNotificationItem(NotificationsItem item) {
    return Card(
      color: Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        // Ограничиваем размер leading виджета через SizedBox с фиксированной шириной
        leading: SizedBox(
          width: 35,
          child: Center(
            child: item.readedAt == null
                ? Icon(Icons.notifications, color: ThemeColors.orange)
                : const Icon(Icons.notifications_outlined),
          ),
        ),
        title: Text(
          transformNotificationType(context, item.data.type),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).orderReceivedDate,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd.MM.yyyy    HH:mm')
                  .format(DateTime.parse(item.createdAt)),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 4),
            if (item.readedAt == null)
              Text(
                S.of(context).notificationNotOpened,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
          ],
        ),
        isThreeLine: true,
        // Ограничиваем размер trailing виджета аналогичным способом
        trailing: const SizedBox(
          width: 35,
          child: Center(
            child: Icon(
              Icons.chevron_right,
              size: 30,
            ),
          ),
        ),
        onTap: () async {
          // Если уведомление не было открыто, сначала отмечаем его как прочитанное
          if (item.readedAt == null) {
            try {
              await NotificationService().markNotificationAsRead(
                context: context,
                id: item.id,
              );
            } catch (e) {
              print('Ошибка при отметке уведомления как прочитанного: $e');
            }
          }
          // Переход на страницу деталей заказа
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                orderId: item.data.orderId,
                orderNumber: 0,
              ),
            ),
          );
          // После возврата обновляем список уведомлений
          _fetchNotifications();
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await _fetchNotifications();
    await _notificationsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.white,
      body: RefreshIndicator(
        displacement: 60.0, // Иконка обновления появляется ниже заголовка
        onRefresh: _handleRefresh,
        child: FutureBuilder<NotificationsResponse>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Убираем const, т.к. здесь используется локализация через S.of(context)
                CustomStyledSliverAppBar(
                  title: S.of(context).notifications,
                  automaticallyImplyLeading: true,
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    ),
                  )
                else if (snapshot.hasError)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        '${S.of(context).error} ${snapshot.error}',
                      ),
                    ),
                  )
                else if (!snapshot.hasData || snapshot.data!.items.isEmpty)
                  SliverFillRemaining(
                    child: Center(child: Text(S.of(context).noNotifications)),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = snapshot.data!.items[index];
                        return _buildNotificationItem(item);
                      },
                      childCount: snapshot.data!.items.length,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
