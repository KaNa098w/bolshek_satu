import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  final String status;

  const OrderStatusWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  static const Map<String, String> statusTranslations = {
    'new': 'Новый',
    'awaiting_payment': 'Ожидание оплаты',
    'paid': 'Оплаченный',
    'awaiting_confirmation': 'Ожидание подтверждения',
    'processing': 'В обработке',
    'partially_delivired': 'Частично доставлен',
    'delivered': 'Доставлен',
    'completed': 'Завершен',
    'partially_cancelled': 'Частично отменен',
    'partially_returned': 'Частично возвращен',
    'returned': 'Возвращен',
    'cancelled': 'Отменен',
    'shipped': 'Отправлен'
  };

  static const Map<String, String> statusforItems = {
    // 'awaiting_confirmation': 'Ожидание подтверждения',
    'processing': 'В обработке',
    'shipped': 'Отправлен',
    'delivered': 'Доставлен',
    // 'returned': 'Возвращен',
    // 'cancelled': 'Отменен',
  };

  static const Map<String, Color> statusColors = {
    'new': Colors.blue,
    'awaiting_payment': Colors.orange,
    'paid': Colors.green,
    'awaiting_confirmation': Colors.blue,
    'processing': Colors.cyan,
    'partially_delivired': Colors.purple,
    'delivered': Colors.teal,
    'completed': Colors.greenAccent,
    'partially_cancelled': Colors.redAccent,
    'partially_returned': Colors.deepOrange,
    'returned': Colors.red,
    'shipped': Colors.greenAccent,
    'cancelled': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    final translatedStatus = statusTranslations[status] ?? status;
    final statusColor = statusColors[status] ?? Colors.black;

    return Text(
      translatedStatus,
      style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
    );
  }
}
