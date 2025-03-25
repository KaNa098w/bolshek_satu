import 'dart:convert';
import 'package:bolshek_pro/core/models/model_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ModelService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}';

  /// Fetch all brands using GET
  Future<ModelResponse> fetchModelWithBrand({
    required BuildContext context,
    required String brandId,
    required int take,
    required int skip,
  }) async {
    try {
      // Формируем URL с query-параметрами
      final Uri url = Uri.parse('$_baseUrl/models').replace(queryParameters: {
        'brandId': brandId,
        'take': take.toString(),
        'skip': skip.toString(),
      });
      print("Запрос отправляется на URL: $url");

      final response = await httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print("Получен ответ: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ModelResponse.fromJson(json);
      } else {
        print("Ошибка загрузки моделей: ${response.statusCode}");
        throw Exception('Failed to load models: ${response.statusCode}');
      }
    } catch (e) {
      print("Ошибка при выполнении запроса: $e");
      throw Exception('Error fetching models: $e');
    }
  }

  /// Fetch a specific brand by ID using GET

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
