import 'dart:convert';
import 'package:bolshek_pro/core/models/return_deital_response.dart';
import 'package:bolshek_pro/core/models/return_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ReturningsService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}/returnings';

  Future<Map<String, int>> fetchReturnTotals(
      {required BuildContext context}) async {
    try {
      final statuses = [
        Constants.newReturnTotalStatus,
        Constants.completedReturnTotal
      ];

      final results = await Future.wait(
        statuses.map(
            (status) => _fetchReturnCount(context: context, status: status)),
      );

      return {
        'newReturnsTotal': results[0],
        'completedReturnsTotal': results[1],
      };
    } catch (e) {
      debugPrint('Ошибка загрузки заказов: $e');
      return {
        'newReturnsTotal': 0,
        'completedReturnsTotal': 0,
      };
    }
  }

  Future<int> _fetchReturnCount(
      {required BuildContext context, required String status}) async {
    try {
      final response = await fetchReturns(
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

  Future<OrderItemsResponse> fetchReturns({
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
        return OrderItemsResponse.fromJson(json);
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      throw Exception('Error fetching orders: $e');
    }
  }

  Future<ReturnDetailRespnse> fetchSelectReturn({
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
        return ReturnDetailRespnse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      // Можете залогировать stackTrace, если нужно
      throw Exception('Error fetching order: $e');
    }
  }

  Future<http.Response> changeStatusReturn({
    required BuildContext context,
    required String id,
    required String status,
  }) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "type": 'order-item',
          "status": status,
        }),
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

  Future<http.Response> cancelGoodReturns(
      {required BuildContext context,
      // required List<String> ids,
      required String id,
      required String comment}) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.post(
        Uri.parse('$_baseUrl/$id/cancel'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "type": 'order-item',
          "sellerRejectComment": comment,
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
