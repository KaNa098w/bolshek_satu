import 'dart:convert';
import 'dart:math';
import 'package:bolshek_pro/core/models/product_responses.dart';
import 'package:bolshek_pro/core/models/order_detail_response.dart';
import 'package:bolshek_pro/core/models/orders_response.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OrdersService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}/orders';

  final Uuid _uuid = Uuid();

  String _generateBlockId() {
    return _uuid.v4();
  }

  Future<Map<String, int>> fetchOrdersTotals(
      {required BuildContext context}) async {
    try {
      final statuses = [
        Constants.newOrders,
        Constants.processingOrders,
        Constants.deliveredOrders,
        Constants.cancelledOrders
      ];

      final results = await Future.wait(
        statuses.map(
            (status) => _fetchOrderCount(context: context, status: status)),
      );

      return {
        'newOrders': results[0],
        'processingOrders': results[1],
        'deliveredOrders': results[2],
        'cancelledOrders': results[3],
      };
    } catch (e) {
      debugPrint('Ошибка загрузки заказов: $e');
      return {
        'newOrders': 0,
        'processingOrders': 0,
        'deliveredOrders': 0,
        'cancelledOrders': 0
      };
    }
  }

  Future<int> _fetchOrderCount(
      {required BuildContext context, required String status}) async {
    try {
      final response = await fetchOrders(
        context: context,
        take: 1,
        skip: 0,
        status: status,
      );
      return response.total ?? 0;
    } catch (e) {
      debugPrint('Ошибка при загрузке $status: $e');
      return 0;
    }
  }

  Future<OrdersResponse> fetchOrders({
    required BuildContext context,
    required int take,
    required int skip,
    required String status,
  }) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.get(
        Uri.parse('$_baseUrl?take=$take&skip=$skip&status=$status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return OrdersResponse.fromJson(json);
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      throw Exception('Error fetching orders: $e');
    }
  }

  Future<Order> fetchSelectOrder({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final token = _getToken(context); // Предположим, вы получаете токен здесь

      final response = await httpClient.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Order.fromJson(jsonData);
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      // Можете залогировать stackTrace, если нужно
      throw Exception('Error fetching order: $e');
    }
  }

  Future<http.Response> updateOrderStatus({
    required BuildContext context,
    required String id,
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.put(
        Uri.parse('$_baseUrl/$id/items/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedFields),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response;
      } else {
        throw Exception(
            'Failed to update product: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<http.Response> cancelGoodOrders({
    required BuildContext context,
    required List<String> ids,
    required String id,
  }) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.post(
        Uri.parse('$_baseUrl/$id/items/cancel'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "ids": ids,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response;
      } else {
        throw Exception(
            'Failed to cancel orders: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error cancelling orders: $e');
    }
  }

  String _getToken(BuildContext context) {
    try {
      final authProvider = Provider.of<GlobalProvider>(context, listen: false);
      final token = authProvider.authResponse?.token;

      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      return token;
    } catch (e, stackTrace) {
      throw Exception('Error retrieving token: $e');
    }
  }
}
