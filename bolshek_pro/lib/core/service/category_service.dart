import 'dart:convert';
import 'package:bolshek_pro/core/models/category_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CategoriesService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}/categories';

  /// Fetch all categories using GET
  Future<CategoryResponse> fetchCategoriesParent(BuildContext context) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_baseUrl?take=999&onlyParent=true'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CategoryResponse.fromJson(json);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<CategoryResponse> fetchCategoriesById(
      BuildContext context, String id) async {
    try {
      // final token = _getToken(context);
      final url = '$_baseUrl/$id';

      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          // 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CategoryResponse.fromJson(json);
      } else {
        throw Exception('Failed to load brand: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching brand by ID: $e');
    }
  }

  Future<CategoryResponse> fetchCategories(BuildContext context) async {
    try {
      // final token = _getToken(context);
      final response = await httpClient.get(
        Uri.parse('$_baseUrl?take=999'),
        headers: {
          // 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CategoryResponse.fromJson(json);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Retrieve the token from AuthProvider
  String _getToken(BuildContext context) {
    final authProvider = Provider.of<GlobalProvider>(context, listen: false);
    final token = authProvider.authResponse?.token;

    if (token == null || token.isEmpty) {
      throw Exception('No token found');
    }

    return token;
  }
}
