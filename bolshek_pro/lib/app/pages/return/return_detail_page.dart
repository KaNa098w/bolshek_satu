import 'package:bolshek_pro/app/widgets/%20order_status_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/core/models/return_deital_response.dart';
import 'package:bolshek_pro/core/service/returnings_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReturnDetailPage extends StatefulWidget {
  final String orderId;
  // final int orderNumber;

  const ReturnDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<ReturnDetailPage> createState() => _ReturnDetailPageState();
}

class _ReturnDetailPageState extends State<ReturnDetailPage> {
  final ReturningsService _returningsService = ReturningsService();

  ReturnDetailRespnse? _order;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchReturnDetails();
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

  Future<void> _fetchReturnDetails() async {
    try {
      final fetchReturns = await _returningsService.fetchSelectReturn(
        context: context,
        id: widget.orderId,
      );

      setState(() {
        _order = fetchReturns;
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
        appBar: AppBar(title: Text('Заказ № ')),
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
        title: Text('Заказ № ${_order!.reason}'),
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
            'Состав возврата',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildOrderLineItem(_order!), // Передаём один элемент
          ),

          const Divider(height: 32),

          const Text(
            'Детали возврата',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            'Общая сумма',
            '${_formatPrice((_order!.orderItem.price?.amount ?? 0) / 100)} ₸',
          ),

          _buildDetailRow(
            'Дата ',
            _order!.createdAt != null
                ? _formatDate(_order!.createdAt!.toIso8601String())
                : '—',
          ),

          _buildDetailRow(
            'Комментарий',
            _order!.comment ?? '—',
            // trailing: const Icon(Icons.phone, color: Colors.red),
          ),
          _buildDetailRow(
            'Причина',
            _mapReason(_order!.reason) ?? '—',
          ),

          // _buildDetailRow(
          //   'Телефон',
          //   _order!.recipientNumber ?? '—',
          //   trailing: const Icon(Icons.phone, color: Colors.green),
          // ),
          // _buildDetailRow(
          //   'Транзакции',
          //   (_order?.payments?.isEmpty ?? true)
          //       ? 'Безналичная оплата'
          //       : {
          //             'cash': 'Наличка',
          //             'freedom_pay': 'Freedom Bank',
          //           }[_order?.payments?.first.system] ??
          //           'Не указано',
          // ),
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
        crossAxisAlignment: CrossAxisAlignment.start, // Выравниваем сверху
        children: [
          // Название поля
          Expanded(
            flex: 3, // Можно регулировать ширину заголовка
            child: Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
          // Значение и (опционально) иконка
          Expanded(
            flex: 5, // Можно регулировать ширину значения
            child: Wrap(
              // Позволяет переносить текст
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true, // Разрешает перенос строк
                  overflow:
                      TextOverflow.visible, // Дает тексту возможность расти
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _updateReturnStatus(
  //     OrderItem item, String selectedStatus) async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     final response = await _returningsService.updateReturnStatus(
  //       context: context,
  //       id: widget.orderId,
  //       updatedFields: {
  //         'ids': [item.id],
  //         'status': selectedStatus,
  //       },
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 204) {
  //       setState(() {
  //         final updatedItem = item.copyWith(status: selectedStatus);
  //         final index = _order!.items!.indexOf(item);
  //         _order!.items![index] =
  //             updatedItem; // Обновляем список с новым объектом
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Ошибка обновления статуса: $e')),
  //     );
  //   }
  // }

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
                  'Возврат успешно отменён',
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

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  String _mapReason(String? reason) {
    switch (reason) {
      case 'bad_quality':
        return 'Товар плохого качества';
      case 'damaged':
        return 'Товар или упаковка повреждена';
      case 'incomplete_set':
        return 'Неполная комплектация';
      default:
        return reason ?? 'Неизвестная причина';
    }
  }

  Future<void> _cancelItem(ReturnDetailRespnse item) async {
    TextEditingController commentController = TextEditingController();

    if (!mounted) return;

    bool? confirmCancel = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Подтверждение отмены",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Вы уверены, что хотите отменить возврат?'),
              const SizedBox(height: 15),
              TextField(
                cursorColor: Colors.black,
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Причина отмены',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:
                  Text('Отмена', style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onPressed: () {
                if (commentController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Введите причину отмены')),
                  );
                } else {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Подтвердить', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );

    if (confirmCancel != true) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (item.id == null) {
        throw Exception('ID товара не может быть null');
      }

      final response = await _returningsService.cancelGoodReturns(
        context: context,
        id: _order?.id ?? '',
        comment: commentController.text.trim(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await _fetchReturnDetails(); // Перезапрашиваем данные
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

  Future<void> _acceptReturn() async {
    if (!mounted) return;

    // Показываем диалог подтверждения
    await showCustomAlertDialog(
      context: context,
      title: "Подтвердить возврат",
      content: const Text("Вы уверены, что хотите принять возврат?"),
      confirmText: "Принять",
      cancelText: "Отмена",
      onConfirm: () async {
        Navigator.pop(context); // Закрываем диалог

        setState(() {
          isLoading = true;
        });

        try {
          await _returningsService.changeStatusReturn(
            context: context,
            id: widget.orderId,
            status: Constants.awaitingPickReturn,
          );

          // Перезапрашиваем данные о возврате
          await _fetchReturnDetails();
        } catch (e) {
          setState(() {
            errorMessage = e.toString();
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Ошибка при принятии возврата: $errorMessage')),
          );
        }
      },
      onCancel: () {
        Navigator.pop(context);
      },
    );
  }

  Future<void> _acceptGood() async {
    if (!mounted) return;

    // Показываем диалог подтверждения
    await showCustomAlertDialog(
      context: context,
      title: "Подтвердить",
      content: const Text("Подтвердите получение товара"),
      confirmText: "Принять",
      cancelText: "Отмена",
      onConfirm: () async {
        Navigator.pop(context); // Закрываем диалог

        setState(() {
          isLoading = true;
        });

        try {
          await _returningsService.changeStatusReturn(
            context: context,
            id: widget.orderId,
            status: Constants.awaitingRefund,
          );

          // Перезапрашиваем данные о возврате
          await _fetchReturnDetails();
        } catch (e) {
          setState(() {
            errorMessage = e.toString();
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Ошибка при принятии возврата: $errorMessage')),
          );
        }
      },
      onCancel: () {
        Navigator.pop(context);
      },
    );
  }

  /// Пример карточки одного товара из заказа
  Widget _buildOrderLineItem(ReturnDetailRespnse item) {
    final imageUrl = item.orderItem.product?.images?.isNotEmpty == true
        ? (item.orderItem.product?.images?.first.url == true
            ? item.orderItem.product?.images?.first.url
            : item.orderItem.product?.images?.first.url)
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
                item.orderItem.product?.name ?? 'Без названия',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    'Статус: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  OrderStatusWidget(status: item.status ?? ''),
                ],
              ),
              const SizedBox(height: 4),
              if (item.status == 'rejected')
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Выравнивание по верху
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black), // Общий стиль
                          children: [
                            const TextSpan(
                              text: 'Комментарий: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold), // Жирный текст
                            ),
                            TextSpan(
                              text: item.sellerRejectComment ??
                                  '', // Обычный текст
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 4),
              Text(
                'Цена: ${_formatPrice(((item.orderItem.price?.amount ?? 0).toDouble() / 100))} ₸',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (item.status == Constants.awaitingConfirmation ||
                  item.status == Constants.createdReturn)
                OutlinedButton(
                  onPressed: () => _acceptReturn(),
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
                    'Принять возврат',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              if (item.status == Constants.awaitingPickReturn)
                OutlinedButton(
                  onPressed: () => _acceptGood(),
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
                    'Получил товар',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              if (item.status == Constants.createdReturn ||
                  item.status == Constants.awaitingConfirmation)
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
                    'Отменить возврат',
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
