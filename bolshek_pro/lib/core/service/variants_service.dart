import 'dart:convert';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/models/variants_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class VariantsService {
  final String _baseUrl = '${Constants.baseUrl}/products';

  /// Fetch products with pagination
  Future<VariantsResponse> fetchProductVariants({
    required BuildContext context,
    required String productId,
  }) async {
    try {
      final token = _getToken(context);
      final response = await http.get(
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
        "kind": 'original',
        "quantity": '1000',
        "sku": sku,
        "manufacturerId": manufacturerId,
      };

      print(
          'Creating product variant with data: ${jsonEncode(body)}'); // Логируем тело запроса

      final response = await http.post(
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

  String _getToken(BuildContext context) {
    final authProvider = Provider.of<GlobalProvider>(context, listen: false);
    final token = authProvider.authResponse?.token;

    if (token == null || token.isEmpty) {
      throw Exception('No token found');
    }

    return token;
  }
}
