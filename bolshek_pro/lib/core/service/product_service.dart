import 'dart:convert';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductService {
  final String _baseUrl = '${Constants.baseUrl}/products';

  /// Fetch products with pagination
  Future<ProductResponse> fetchProductsPaginated({
    required BuildContext context,
    required int take,
    required int skip,
    required String status,
  }) async {
    try {
      final token = _getToken(context);
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?take=$take&skip=$skip&status=$status&categoryWithChildren=true'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProductResponse.fromJson(json);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> createProduct(
      BuildContext context,
      String name,
      String slug,
      String brandId,
      String status,
      String deliveryType,
      String categoryId,
      String vendorCode) async {
    try {
      final token = _getToken(context);
      final body = {
        "name": name,
        "slug": slug,
        "brandId": brandId,
        "status": status,
        "deliveryType": deliveryType,
        "categoryId": categoryId,
        "compatibleVehicleIds": [],
        "vendorCode": vendorCode,
      };

      print(
          'Creating product with data: ${jsonEncode(body)}'); // Логируем тело запроса

      final response = await http.post(
        Uri.parse(_baseUrl),
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
        print('Product created successfully');
      } else {
        throw Exception(
            'Failed to create product: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error creating product: $e'); // Логируем ошибки
      throw Exception('Error creating product: $e');
    }
  }

  String _getToken(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.authResponse?.token;

    if (token == null || token.isEmpty) {
      throw Exception('No token found');
    }

    return token;
  }
}
