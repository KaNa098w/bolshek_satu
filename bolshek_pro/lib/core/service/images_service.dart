import 'dart:convert';
import 'package:bolshek_pro/core/models/fetch_images_response.dart';
import 'package:bolshek_pro/core/models/images_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ImagesService {
  final String _baseUrl = '${Constants.baseUrl}/products';

  /// Создание нового изображения для продукта
  Future<void> createProductImage(
    BuildContext context, {
    required String productId,
    required double imageSize,
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

      print('Creating product image with data: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('$_baseUrl/$productId/images'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Product image created successfully');
      } else {
        throw Exception(
            'Failed to create product image: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error creating product image: $e');
      throw Exception('Error creating product image: $e');
    }
  }

  /// Получение списка изображений для продукта
  Future<List<FetchImagesResponse>> fetchProductImages(
    BuildContext context, {
    required String productId,
  }) async {
    try {
      final token = _getToken(context);
      final url = '$_baseUrl/$productId/images';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse
            .map((data) => FetchImagesResponse.fromJson(data))
            .toList();
      } else {
        throw Exception(
            'Failed to fetch product images: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error fetching product images: $e');
      throw Exception('Error fetching product images: $e');
    }
  }

  /// Удаление изображения товара
  Future<void> deleteProductImage(
    BuildContext context, {
    required String productId,
    required String imageHash,
  }) async {
    try {
      final token = _getToken(context);
      final url = '$_baseUrl/$productId/images/$imageHash';

      print('Request URL: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete product image: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error deleting product image: $e');
      throw Exception('Error deleting product image: $e');
    }
  }

  /// Получение токена из контекста
  String _getToken(BuildContext context) {
    final authProvider = Provider.of<GlobalProvider>(context, listen: false);
    final token = authProvider.authResponse?.token;

    if (token == null || token.isEmpty) {
      throw Exception('No token found');
    }

    return token;
  }
}
