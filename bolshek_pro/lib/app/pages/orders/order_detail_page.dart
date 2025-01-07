import 'package:bolshek_pro/app/widgets/%20order_status_widget.dart';
import 'package:bolshek_pro/core/models/order_detail_response.dart';
import 'package:bolshek_pro/core/service/orders_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  final int orderNumber;

  const OrderDetailsPage(
      {Key? key, required this.orderId, required this.orderNumber})
      : super(key: key);

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
    // Заменяем запятые на пробел, если это нужно (например, "1,234.56" -> "1 234.56")
    return formatter.format(price).replaceAll(',', ' ');
  }

  String _formatDate(String isoDate) {
    try {
      final parsedDate = DateTime.parse(isoDate);
      final formatter =
          DateFormat('dd.MM.yyyy HH:mm'); // Например, "27.09.2024 11:02"
      return formatter.format(parsedDate);
    } catch (e) {
      return 'Некорректная дата'; // На случай, если формат даты неправильный
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
    // Пока идёт загрузка
    if (isLoading) {
      return Scaffold(
        backgroundColor: ThemeColors.white,
        appBar: AppBar(title: Text('Заказ № ${widget.orderNumber}')),
        body: const Center(
            child: CircularProgressIndicator(
          color: ThemeColors.grey4,
        )),
      );
    }

    // Если произошла ошибка
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Заказ № ${widget.orderId}')),
        body: Center(child: Text('Ошибка: $errorMessage')),
      );
    }

    // Если данных нет вовсе
    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Заказ № ${widget.orderId}')),
        body: const Center(child: Text('Данные о заказе отсутствуют')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Заказ № ${_order!.number}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Для удобства используем ListView, чтобы отобразить и общую информацию, и список товаров
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Статус или другая информация о заказе
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Chip(
          //     label: Text(_order!.status ?? 'Нет статуса'),
          //   ),
          // ),
          // const SizedBox(height: 16),

          // Заголовок "Состав заказа"
          const Text(
            'Состав заказа',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Выводим все items через ListView.builder внутри столбца (через shrinkWrap)
          // Но так как мы уже *в* ListView, можем просто сгенерировать виджеты через .map
          if (_order!.items != null && _order!.items!.isNotEmpty)
            ..._order!.items!.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildOrderLineItem(item),
                ))
          else
            const Text('В заказе нет товаров'),

          const Divider(height: 32),

          // Заголовок "Детали заказа"
          const Text(
            'Детали заказа',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            'Общая сумма',
            '${_formatPrice((_order!.price?.amount ?? 0) / 100)} ₸',
          ),

          _buildDetailRow(
            'Сумма доставки',
            '${_formatPrice((_order!.deliveryFee?.amount ?? 0) / 100)} ₸',
          ),
          _buildDetailRow(
            'Итоговая сумма',
            '${_formatPrice((_order!.totalPrice?.amount ?? 0) / 100)} ₸',
          ),
          _buildDetailRow(
            'Дата оформления',
            _order!.createdAt != null
                ? _formatDate(_order!.createdAt!.toIso8601String())
                : '—',
          ),

          _buildDetailRow(
            'Покупатель',
            _order!.recipientName ?? '—',
            // trailing: const Icon(Icons.phone, color: Colors.red),
          ),
          _buildDetailRow(
            'Телефон',
            _order!.recipientNumber ?? '—',
            trailing: const Icon(Icons.phone, color: Colors.green),
          ),
          _buildDetailRow(
            'Транзакции',
            (_order?.payments?.isEmpty ?? true)
                ? 'Безналичная оплата'
                : {
                      'cash': 'Наличка',
                      'freedom_pay': 'Freedom Bank',
                    }[_order?.payments?.first.system] ??
                    'Не указано',
          ),
          const SizedBox(height: 30),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Логика отслеживания доставки
          //     },
          //     child: const Text('Отследить доставку'),
          //   ),
          // ),
        ],
      ),
    );
  }

  /// Виджет для строки с деталью заказа: ключ + значение + опциональная иконка
  Widget _buildDetailRow(String title, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Название поля
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          // Значение и (опционально) иконка
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
                trailing,
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
          _order!.items![index] =
              updatedItem; // Обновляем список с новым объектом
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка обновления статуса: $e')),
      );
    }
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Диалог нельзя закрыть нажатием вне
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Подтвердите действие'),
          content: Text(
            'Вы уверены, что хотите отменить товар? Это действие необратимо.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Возвращаем "Отмена"
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Возвращаем "Подтвердить"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Цвет кнопки подтверждения
              ),
              child: Text('Отменить'),
            ),
          ],
        );
      },
    );

    // Обработка результата диалога
    if (result == true) {
      showSuccessDialog(context);
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
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
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'Товар успешно отменён',
                  style: TextStyle(
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

    // Автоматическое закрытие через 2 секунды
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  Future<void> _cancelItem(Item item) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Проверяем, что item.id не равен null
      if (item.id == null) {
        throw Exception('ID товара не может быть null');
      }

      final response = await _ordersService.cancelGoodOrders(
        context: context,
        id: _order?.id ?? '',
        ids: [item.id!], // Используем оператор "!" для безопасного извлечения
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          // Удаляем товар из списка
          _order!.items!.remove(item);
          isLoading = false;
        });

        showSuccessDialog(context);
      } else {
        throw Exception('Ошибка отмены товара: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отмены товара: $e')),
      );
    }
  }

  void _showStatusSelectionDialog(BuildContext context, Item item) async {
    final newStatus = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Выберите новый статус',
            style: TextStyle(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: OrderStatusWidget.statusforItems.entries
                .where((entry) =>
                    entry.key != item.status) // Фильтруем текущий статус
                .map((entry) {
              return ListTile(
                dense: true, // Уменьшает внутренние отступы
                title: Text(
                  entry.value,
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () => Navigator.pop(context, entry.key),
              );
            }).toList(),
          ),
        );
      },
    );

    if (newStatus != null) {
      await _updateOrderStatus(item, newStatus);
    }
  }

  /// Пример карточки одного товара из заказа
  Widget _buildOrderLineItem(Item item) {
    final imageUrl = item.product?.images?.isNotEmpty == true
        ? (item.product?.images?.first.sizes?.isNotEmpty == true
            ? item.product?.images?.first.sizes?.first.url
            : item.product?.images?.first.url)
        : null;

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center, // Центрирование по вертикали
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
            child: imageUrl!.isEmpty
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
        // Описание товара
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product?.name ?? 'Без названия',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('Статус: '),
                  OrderStatusWidget(status: item.status ?? ''),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Цена: ${_formatPrice(((item.price?.amount ?? 0).toDouble() / 100))} ₸',
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
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Закругление углов
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                  ),
                  child: Text(
                    'Изменить статус товара',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              if (item.status == 'awaiting_confirmation' ||
                  item.status == 'processing')
                OutlinedButton(
                  onPressed: () => _cancelItem(item),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Закругление углов
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                  ),
                  child: Text(
                    'Отменить товар',
                    style: TextStyle(
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
