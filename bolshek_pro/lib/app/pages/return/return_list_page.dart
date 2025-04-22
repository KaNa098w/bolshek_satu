import 'dart:convert';
import 'package:bolshek_pro/app/pages/return/return_detail_page.dart';
import 'package:bolshek_pro/app/widgets/%20order_status_widget.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bolshek_pro/core/models/return_response.dart';
import 'package:bolshek_pro/core/service/returnings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class ReturnsListPage extends StatefulWidget {
  final String statusFilter;

  const ReturnsListPage({Key? key, required this.statusFilter})
      : super(key: key);

  @override
  State<ReturnsListPage> createState() => _ReturnsListPageState();
}

class _ReturnsListPageState extends State<ReturnsListPage> {
  final ReturningsService _returningsService = ReturningsService();
  final List<OrderItem> _orders = [];
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

  Future<void> _loadCachedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_orders_${widget.statusFilter}');
    if (cachedData != null) {
      final List<dynamic> cachedList = jsonDecode(cachedData);
      setState(() {
        _orders.addAll(cachedList.map((e) => OrderItem.fromJson(e)).toList());
        _skip = _orders.length;
      });
    }
  }

  String _formatDate(String isoDate) {
    try {
      final parsedDate = DateTime.parse(isoDate);
      final formatter = DateFormat('dd.MM.yyyy  HH:mm');
      return formatter.format(parsedDate);
    } catch (e) {
      return S.of(context).error;
    }
  }

  Future<void> _fetchOrders() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _returningsService.fetchReturns(
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).error}: $e')),
      );
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
    final s = S.of(context);

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
                              s.empty,
                              style: const TextStyle(
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
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final order = _orders[index];
                              return _buildOrderItem(
                                address: order.comment ?? s.comment,
                                name: order.orderItem.product?.name ?? '',
                                total:
                                    '${_formatPrice((order.orderItem.totalPrice?.amount ?? 0) / 100)} ₸',
                                orderId: order.id ?? '—',
                                data: order.createdAt.timeZoneName,
                                orderNumber: 999,
                                status: order.status ?? '',
                                imageUrl: order.orderItem.product?.images?.first
                                        .sizes?.first.url ??
                                    '',
                              );
                            },
                          ),
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
    required String status,
    required String imageUrl,
  }) {
    final s = S.of(context);

    return GestureDetector(
      onTap: () {},
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
                    '${s.order_prefix} $orderNumber',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                  Text(
                    total,
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
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${s.comment}: $address',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              '${s.status_label}',
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
                          '${s.date}: ${_orders.isNotEmpty && _orders.first.createdAt != null ? _formatDate(_orders.first.createdAt!.toIso8601String()) : s.date_not_specified}',
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
                      builder: (context) => ReturnDetailPage(orderId: orderId),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.return_details,
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
