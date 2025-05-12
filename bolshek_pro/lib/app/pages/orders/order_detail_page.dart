import 'package:bolshek_pro/app/widgets/%20order_status_widget.dart';
import 'package:bolshek_pro/core/models/order_detail_response.dart';
import 'package:bolshek_pro/core/service/orders_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  final int orderNumber;

  const OrderDetailsPage({
    Key? key,
    required this.orderId,
    required this.orderNumber,
  }) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final OrdersService _ordersService = OrdersService();

  Order? _order;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###.##", "ru_RU");
    return formatter.format(price).replaceAll(',', ' ');
  }

  String _formatDate(String isoDate) {
    try {
      final parsedDate = DateTime.parse(isoDate);
      final formatter = DateFormat('dd.MM.yyyy HH:mm');
      return formatter.format(parsedDate);
    } catch (e) {
      final localizations = S.of(context);
      return localizations.invalid_date;
    }
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final fetchedOrder = await _ordersService.fetchSelectOrder(
        context: context,
        id: widget.orderId,
      );

      setState(() {
        _order = fetchedOrder;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    // Пока идёт загрузка
    if (isLoading) {
      return Scaffold(
        backgroundColor: ThemeColors.white,
        appBar: AppBar(
          title: Text('${localizations.order_prefix} ${widget.orderNumber}'),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: ThemeColors.grey4),
        ),
      );
    }

    // Если произошла ошибка
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${localizations.order_prefix} ${widget.orderId}'),
        ),
        body: Center(
          child: Text('${localizations.error_prefix} $errorMessage'),
        ),
      );
    }

    // Если данных нет вовсе
    if (_order == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${localizations.order_prefix} ${widget.orderId}'),
        ),
        body: Center(
          child: Text(localizations.order_data_not_found),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${localizations.order_prefix} ${_order!.number}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Заголовок "Состав заказа"
          Text(
            localizations.order_composition,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_order!.items != null && _order!.items!.isNotEmpty)
            ..._order!.items!.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildOrderLineItem(item),
              ),
            )
          else
            Text(localizations.order_empty),
          const Divider(height: 32),
          // Заголовок "Детали заказа"
          Text(
            localizations.order_details,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            localizations.total_amount,
            '${_formatPrice((_order!.price?.amount ?? 0) / 100)} ₸',
          ),
          _buildDetailRow(
            localizations.delivery_amount,
            '${_formatPrice((_order!.deliveryFee?.amount ?? 0) / 100)} ₸',
          ),
          _buildDetailRow(
            localizations.final_amount,
            '${_formatPrice((_order!.totalPrice?.amount ?? 0) / 100)} ₸',
          ),
          _buildDetailRow(
            localizations.order_date,
            _order!.createdAt != null
                ? _formatDate(_order!.createdAt!.toIso8601String())
                : '—',
          ),
          _buildDetailRow(
            localizations.buyer,
            _order!.recipientName ?? '—',
          ),
          _buildDetailRow(
            localizations.phone,
            _order!.recipientNumber ?? '—',
            trailing: const Icon(Icons.phone, color: Colors.green),
          ),
          _buildDetailRow(
            localizations.transactions,
            (_order?.payments?.isEmpty ?? true)
                ? localizations.cashless_payment
                : {
                      'cash': localizations.cash_payment,
                      'freedom_pay': localizations.freedom_pay,
                    }[_order?.payments?.first.system] ??
                    localizations.not_specified,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    final Uri phoneUri = Uri(scheme: 'tel', path: value);
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      debugPrint('${S.of(context).cannot_launch} $phoneUri');
                    }
                  },
                  child: trailing,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateOrderStatus(Item item, String selectedStatus) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _ordersService.updateOrderStatus(
        context: context,
        id: widget.orderId,
        updatedFields: {
          'ids': [item.id],
          'status': selectedStatus,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          final updatedItem = item.copyWith(status: selectedStatus);
          final index = _order!.items!.indexOf(item);
          _order!.items![index] = updatedItem;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).status_update_error} $e')),
      );
    }
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
    final localizations = S.of(context);
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.confirm_action),
          content: Text(localizations.cancel_item_confirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(localizations.cancel_action),
            ),
          ],
        );
      },
    );

    if (result == true) {
      showSuccessDialog(context);
    }
  }

  void showSuccessDialog(BuildContext context) {
    final localizations = S.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.item_cancel_success,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  Future<void> _cancelItem(Item item) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (item.id == null) {
        throw Exception(S.of(context).item_id_null_error);
      }

      final response = await _ordersService.cancelGoodOrders(
        context: context,
        id: _order?.id ?? '',
        ids: [item.id!],
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _order!.items!.remove(item);
          isLoading = false;
        });

        showSuccessDialog(context);
      } else {
        throw Exception('${S.of(context).cancel_item_error} ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).cancel_item_error} $e')),
      );
    }
  }

  void _showStatusSelectionDialog(BuildContext context, Item item) async {
    final newStatus = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final localizations = S.of(context);
        return AlertDialog(
            title: Text(
              localizations.select_new_status,
              style: const TextStyle(fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: OrderStatusWidget.statusforItemsLocalized(context)
                  .entries
                  .where((entry) => entry.key != item.status)
                  .map((entry) {
                return ListTile(
                  dense: true,
                  title: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () => Navigator.pop(context, entry.key),
                );
              }).toList(),
            ));
      },
    );

    if (newStatus != null) {
      await _updateOrderStatus(item, newStatus);
    }
  }

  Widget _buildOrderLineItem(Item item) {
    final imageUrl = item.warehouseProduct.product?.images?.isNotEmpty == true
        ? (item.warehouseProduct.product?.images?.first.sizes?.isNotEmpty == true
            ? item.warehouseProduct.product?.images?.first.sizes?.first.url
            : item.warehouseProduct.product?.images?.first.url)
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 80,
            minHeight: 80,
            maxWidth: 80,
            maxHeight: 80,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl == null || imageUrl.isEmpty
                ? Image.asset('assets/icons/error_image.png', fit: BoxFit.cover)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/icons/error_image.png',
                          fit: BoxFit.cover);
                    },
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.warehouseProduct.product.name
                 ?? S.of(context).no_name,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('${S.of(context).status_prefix} '),
                  OrderStatusWidget(status: item.status ?? ''),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${S.of(context).price_prefix} ${_formatPrice(((item.price?.amount ?? 0).toDouble() / 100))} ₸',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (item.status == 'awaiting_confirmation' ||
                  item.status == 'processing' ||
                  item.status == 'shipped')
                OutlinedButton(
                  onPressed: () => _showStatusSelectionDialog(context, item),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -2),
                  ),
                  child: Text(
                    S.of(context).change_item_status,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (item.status == 'awaiting_confirmation' ||
                  item.status == 'processing')
                OutlinedButton(
                  onPressed: () => _cancelItem(item),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -2),
                  ),
                  child: Text(
                    S.of(context).cancel_item,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
