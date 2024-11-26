import 'dart:convert';
import 'package:bolshek_pro/core/models/images_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ImagesService {
  final String _baseUrl = '${Constants.baseUrl}/products';

  // /// Fetch products with pagination
  // Future<ImagesResponse> fetchProductImage({
  //   required BuildContext context,
  //   required String productId,
  // }) async {
  //   try {
  //     final token = _getToken(context);
  //     final response = await http.get(
  //       Uri.parse('$_baseUrl/$productId/images'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final json = jsonDecode(response.body);
  //       return ImagesResponse.fromJson(json);
  //     } else {
  //       throw Exception('Failed to load products: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching products: $e');
  //   }
  // }

  Future<void> createProductImage(
    BuildContext context, {
    required String productId,
    required double imageSize,
    // required String kind,
    required String imageData,
    required String imageName,
  }) async {
    try {
      final token = _getToken(context);
      final body = {
        "name": imageName,
        "size": imageSize,
        "type": "image/png",
        "data": imageData,
      };

      print(
          'Creating product variant with data: ${jsonEncode(body)}'); // Логируем тело запроса

      final response = await http.post(
        Uri.parse('$_baseUrl/$productId/images'),
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
        print('Product image created successfully');
      } else {
        throw Exception(
            'Failed to create product image: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error creating product image: $e'); // Логируем ошибки
      throw Exception('Error creating product image: $e');
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
