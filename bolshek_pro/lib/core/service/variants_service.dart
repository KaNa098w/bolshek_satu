import 'dart:convert';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/models/variants_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class VariantsService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)], // Добавление логгера
  );
  final String _baseUrl = '${Constants.baseUrl}/products';

  /// Fetch products with pagination
  Future<VariantsResponse> fetchProductVariants({
    required BuildContext context,
    required String productId,
  }) async {
    try {
      final token = _getToken(context);
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/$productId/variants'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return VariantsResponse.fromJson(json);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> createProductVariant(
    BuildContext context, {
    required String productId,
    required double priceAmount,
    // required String kind,
    required String sku,
    required String manufacturerId,
    required String kind,
    required int discountedPersent,
    required int discountedAmount,
  }) async {
    try {
      final token = _getToken(context);
      final body = {
        "basePrice": {
          "amount": priceAmount,
          "precision": '2',
          "currency": 'KZT',
        },
        "price": {
          "amount": priceAmount,
          "precision": '2',
          "currency": 'KZT',
        },
        "kind": kind,
        "quantity": '1000',
        "sku": sku,
        "manufacturerId": manufacturerId,
        "discountPercent": discountedPersent,
        "discountedPrice": {
          "amount": discountedAmount,
          "precision": '2',
          "currency": "KZT"
        }
      };

      print(
          'Creating product variant with data: ${jsonEncode(body)}'); // Логируем тело запроса

      final response = await httpClient.post(
        Uri.parse('$_baseUrl/$productId/variants'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print(
          'Response status: ${response.statusCode}'); // Логируем статус ответа
      print('Response body: ${response.body}'); // Логируем тело ответа

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Product variant created successfully');
      } else {
        throw Exception(
            'Failed to create product variant: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error creating product variant: $e'); // Логируем ошибки
      throw Exception('Error creating product variant: $e');
    }
  }

  Future<void> updateProductVariant(
    BuildContext context, {
    required String productId,
    required String variantId,
    required double newAmount,
    required String? manufacturerId,
    required String? sku,
    required String? kind,
    required int discountedPersent,
    required double discountedAmount,
  }) async {
    try {
      final token = _getToken(context);

      final body = {
        "basePrice": {
          "amount": newAmount,
          "precision": 2,
          "currency": "KZT",
        },
        "price": {
          "amount": newAmount, // Используем тот же amount
          "precision": 2,
          "currency": "KZT",
        },
        "sku": sku,
        "manufacturerId": manufacturerId,
        "kind": kind,
        "discountPercent": discountedPersent,
        "discountedPrice": {
          "amount": discountedAmount,
          "precision": 2,
          "currency": "KZT"
        }
      };

      print(
          'Updating product variant with data: ${jsonEncode(body)}'); // Логируем тело запроса

      final response = await httpClient.put(
        Uri.parse('$_baseUrl/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print(
          'Response status: ${response.statusCode}'); // Логируем статус ответа
      print('Response body: ${response.body}'); // Логируем тело ответа

      if (response.statusCode == 200) {
        print('Product variant updated successfully');
      } else {
        throw Exception(
            'Failed to update product variant: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error updating product variant: $e'); // Логируем ошибки
      throw Exception('Error updating product variant: $e');
    }
  }

  String _getToken(BuildContext context) {
    final authProvider = Provider.of<GlobalProvider>(context, listen: false);
    final token = authProvider.authResponse?.token;

    if (token == null || token.isEmpty) {
      throw Exception('No token found');
    }

    return token;
  }
}
