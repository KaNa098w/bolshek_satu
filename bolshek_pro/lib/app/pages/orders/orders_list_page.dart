import 'dart:convert';
import 'package:bolshek_pro/app/pages/orders/order_detail_page.dart';
import 'package:bolshek_pro/app/widgets/%20order_status_widget.dart';
import 'package:bolshek_pro/core/models/order_detail_response.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bolshek_pro/core/service/orders_service.dart';
import 'package:bolshek_pro/core/models/orders_response.dart';
import 'package:bolshek_pro/app/pages/product/product_detail_screen.dart';
import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class OrderListPage extends StatefulWidget {
  final String statusFilter; // Добавлено для фильтрации

  const OrderListPage({Key? key, required this.statusFilter}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final OrdersService _ordersService = OrdersService();
  final List<Order> _orders = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;
  final int _take = 5;

  @override
  void initState() {
    super.initState();
    _loadCachedOrders();
    _fetchOrders();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchOrders();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Загрузка данных из кэша
  Future<void> _loadCachedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(
        'cached_orders_${widget.statusFilter}'); // Используем уникальный ключ для каждого статуса
    if (cachedData != null) {
      final List<dynamic> cachedList = jsonDecode(cachedData);
      setState(() {
        _orders.addAll(
          cachedList.map((e) => Order.fromJson(e)).toList(),
        );
        _skip = _orders.length;
      });
    }
  }

  /// Сохранение данных в кэш с учётом статуса
  /// Сохранение данных в кэш с учётом статуса и проверкой актуальности
  Future<void> _cacheOrders() async {
    final prefs = await SharedPreferences.getInstance();

    // Загрузить текущие заказы из кэша
    final cachedData = prefs.getString('cached_orders_${widget.statusFilter}');
    final List<dynamic> cachedList =
        cachedData != null ? jsonDecode(cachedData) : [];
    final cachedOrders = cachedList.map((e) => Order.fromJson(e)).toList();

    // Сравнить загруженные заказы с кешированными и удалить отсутствующие
    final updatedOrders = cachedOrders.where((cachedOrder) {
      return _orders.any((order) => order.id == cachedOrder.id);
    }).toList();

    // Добавить новые заказы в кэш
    for (var order in _orders) {
      if (!updatedOrders.any((cachedOrder) => cachedOrder.id == order.id)) {
        updatedOrders.add(order);
      }
    }

    // Сохранить обновлённый список в кэш
    final data = updatedOrders.map((e) => e.toJson()).toList();
    await prefs.setString(
        'cached_orders_${widget.statusFilter}', jsonEncode(data));
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

  /// Загрузка заказов с пагинацией

  Future<void> _fetchOrders() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _ordersService.fetchOrders(
        context: context,
        take: _take,
        skip: _skip,
        status: widget.statusFilter,
      );

      setState(() {
        final newOrders = response.items ?? [];
        for (var order in newOrders) {
          if (!_orders.any((o) => o.id == order.id)) {
            _orders.add(order);
          }
        }
        _skip += _take;
        _hasMore = newOrders.length == _take;
      });

      // Проверить и обновить кэш
      await _cacheOrders();
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Ошибка загрузки: $e')),
      // );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _orders.clear();
      _skip = 0;
      _hasMore = true;
    });
    await _fetchOrders();
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###.##", "ru_RU");
    return formatter.format(price).replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: ThemeColors.greyF,
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    color: ThemeColors.orange,
                    onRefresh: _refreshOrders,
                    child: _orders.isEmpty && !_isLoading
                        ? Center(
                            child: Text(
                              localizations.no_orders_message,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _orders.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _orders.length) {
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                      children: List.generate(
                                    1,
                                    (index) => const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          LoadingWidget(
                                            width: 365,
                                            height: 120,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                ));
                              }
                              final order = _orders[index];
                              return _buildOrderItem(
                                address: order.address?.address ??
                                    localizations.address_not_specified,
                                name: order.items!.first.warehouseProduct.product?.name ?? '',
                                total:
                                    '${_formatPrice((order.totalPrice?.amount ?? 0) / 100)} ₸',
                                orderId:
                                    order.id ?? localizations.unknown_order,
                     data: order.updatedAt != null
    ? _formatDate(order.updatedAt!.toIso8601String())
    : localizations.date_not_specified,

                                orderNumber: order.number ?? 0,
                                count: order.items?.length ?? 0,
                                status: order.status ?? '',
imageUrl: order.items!.first.warehouseProduct.product.images?.isNotEmpty == true &&
           order.items!.first.warehouseProduct.product.images!.first.sizes?.isNotEmpty == true
    ? order.items!.first.warehouseProduct.product.images!.first.sizes!.first.url ?? ''
    : '',

                              );
                            }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem({
    required String address,
    required String name,
    required String total,
    required String data,
    required String orderId,
    required int orderNumber,
    required int count,
    required String status,
    required String imageUrl,
  }) {
    final localizations = S.of(context);
    return GestureDetector(
      onTap: () {
        // Можно добавить логику при нажатии
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${localizations.order_number_prefix} $orderNumber',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                  Text(
                    '$total',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
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
                          child: imageUrl.isEmpty
                              ? Image.asset('assets/icons/error_image.png',
                                  fit: BoxFit.cover)
                              : Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                        'assets/icons/error_image.png',
                                        fit: BoxFit.cover);
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        count == 1
                            ? ''
                            : '+${count - 1} ${localizations.additional_items}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${localizations.address_prefix} $address',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              '${localizations.status_prefix} ',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            OrderStatusWidget(status: status),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${localizations.date_prefix} ${_orders.first.createdAt != null ? _formatDate(_orders.first.createdAt!.toString()) : localizations.date_not_specified}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsPage(
                        orderId: orderId,
                        orderNumber: orderNumber,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.order_details,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.blue.shade700,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
