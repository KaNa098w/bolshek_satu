import 'dart:convert';
import 'dart:math';
import 'package:bolshek_pro/core/models/fetch_product_response.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MyOrganizationService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}';

  final Uuid _uuid = Uuid();

  /// Метод для генерации уникального ID блока
  String _generateBlockId() {
    return _uuid.v4(); // Генерация уникального идентификатора
  }

  /// Fetch products with pagination
  Future<ProductResponse> fetchOrganization({
    required BuildContext context,
  }) async {
    try {
      final token = _getToken(context);
      final userId = _getUserId(context);
      final response = await http.get(
        Uri.parse('$_baseUrl/$userId'),
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

  String _getToken(BuildContext context) {
    final authProvider = Provider.of<GlobalProvider>(context, listen: false);
    final token = authProvider.authResponse?.token;

    if (token == null || token.isEmpty) {
      throw Exception('No token found');
    }

    return token;
  }

  String _getUserId(BuildContext context) {
    final authProvider = Provider.of<GlobalProvider>(context, listen: false);
    final userId = authProvider.authResponse?.user?.id;

    if (userId == null || userId.isEmpty) {
      throw Exception('No token found');
    }

    return userId;
  }
}
