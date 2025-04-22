import 'dart:convert';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class PropertiesService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}';

  /// Fetch all categories using GET
  Future<PropertiesResponse> fetchProperties(
      BuildContext context, String categoryId) async {
    try {
      final token = _getToken(context);
      final url = '$_baseUrl/categories/$categoryId/properties';
      print('Request URL: $url');
      print(
          'Request Headers: {Authorization: Bearer $token, Content-Type: application/json}');

      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PropertiesResponse.fromJson(json);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<void> createProductProperties(
    BuildContext context, {
    required String productId,
    required dynamic value, // Меняем String на dynamic
    required String propertyId,
  }) async {
    try {
      final token = _getToken(context);
      final body = {"value": jsonEncode(value), "propertyId": propertyId};

      print('Creating product properties with data: ${jsonEncode(body)}');

      final response = await httpClient.post(
        Uri.parse('$_baseUrl/products/$productId/properties'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            body), // jsonEncode только для всего объекта, а не для value
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Product properties created successfully');
      } else {
        throw Exception(
            'Failed to create product properties: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error creating product properties: $e');
      throw Exception('Error creating product properties: $e');
    }
  }

  Future<void> updateProductProperty(
    BuildContext context, {
    required String productId,
    required String propertiesId,
    required dynamic value,
  }) async {
    try {
      final token = _getToken(context);

      // Приводим значение к строке (без дополнительного JSON-кодирования)
      final formattedValue = value.toString();

      final body = {"value": formattedValue, "propertyId": propertiesId};

      print('Отправляем запрос на обновление: ${jsonEncode(body)}');

      final response = await httpClient.put(
        Uri.parse('$_baseUrl/products/$productId/properties/$propertiesId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(body),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Product property updated successfully');
      } else {
        throw Exception(
            'Failed to update product property: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error updating product property: $e');
      throw Exception('Error updating product property: $e');
    }
  }

  /// Retrieve the token from AuthProvider
  String _getToken(BuildContext context) {
    final authProvider = Provider.of<GlobalProvider>(context, listen: false);
    final token = authProvider.authResponse?.token;

    if (token == null || token.isEmpty) {
      print('No token found in AuthProvider');
      throw Exception('No token found');
    }

    print('Retrieved Token: $token');
    return token;
  }
}
