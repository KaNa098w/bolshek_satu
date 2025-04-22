import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  final String status;

  const OrderStatusWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  // Карта цветов статусов остается неизменной
  static const Map<String, Color> statusColors = {
    'new': Colors.blue,
    'awaiting_payment': Colors.orange,
    'paid': Colors.green,
    'awaiting_confirmation': Colors.blue,
    'processing': Colors.cyan,
    'partially_delivired':
        Colors.purple, // если API возвращает именно такое значение
    'delivered': Colors.teal,
    'completed': Colors.blueAccent,
    'partially_cancelled': Colors.redAccent,
    'partially_returned': Colors.deepOrange,
    'returned': Colors.red,
    'shipped': Colors.greenAccent,
    'cancelled': Colors.red,
    'created': Colors.green,
    'rejected': Colors.red,
    'awaiting_pick_up': Colors.brown,
    Constants.awaitingRefund: Colors.orange
  };

  // Статический метод для получения локализованных значений для элементов списка
  static Map<String, String> statusforItemsLocalized(BuildContext context) {
    final localizations = S.of(context);
    return {
      'processing': localizations.order_status_processing,
      'shipped': localizations.order_status_shipped,
      'delivered': localizations.order_status_delivered,
    };
  }

  // Функция для получения локализованной строки статуса
  String _localizedStatus(BuildContext context, String status) {
    final localizations = S.of(context);
    switch (status) {
      case 'new':
        return localizations.order_status_new;
      case 'awaiting_payment':
        return localizations.order_status_awaiting_payment;
      case 'paid':
        return localizations.order_status_paid;
      case 'awaiting_confirmation':
        return localizations.order_status_awaiting_confirmation;
      case 'processing':
        return localizations.order_status_processing;
      case 'created':
        return localizations.order_status_created;
      case 'partially_delivired': // Если API возвращает именно это значение
        return localizations.order_status_partially_delivered;
      case 'delivered':
        return localizations.order_status_delivered;
      case 'completed':
        return localizations.order_status_completed;
      case 'partially_cancelled':
        return localizations.order_status_partially_cancelled;
      case 'partially_returned':
        return localizations.order_status_partially_returned;
      case 'returned':
        return localizations.order_status_returned;
      case 'cancelled':
        return localizations.order_status_cancelled;
      case 'shipped':
        return localizations.order_status_shipped;
      case 'rejected':
        return localizations.order_status_rejected;
      case 'awaiting_pick_up':
        return localizations.order_status_awaiting_pick_up;
      case Constants.awaitingRefund:
        return localizations.order_status_awaiting_refund;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final translatedStatus = _localizedStatus(context, status);
    final statusColor = statusColors[status] ?? Colors.black;
    return Text(
      translatedStatus,
      style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
    );
  }
}
