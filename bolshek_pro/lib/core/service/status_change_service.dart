import 'dart:convert';
import 'dart:math';
import 'package:bolshek_pro/core/models/product_responses.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StatusChangeService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}/products';

  final Uuid _uuid = Uuid();

  /// Метод для генерации уникального ID блока
  String _generateBlockId() {
    return _uuid.v4();
  }

  Future<void> updateProductStatus({
    required BuildContext context,
    required String id,
    required String status,
  }) async {
    final String token = _getToken(context);

    try {
      print('Запрос к сервису (PUT): $_baseUrl/$id'); // Лог URL
      print('Токен: $token'); // Лог токена

      final response = await httpClient.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}), // Тело запроса
      );

      print('Статус ответа: ${response.statusCode}'); // Лог статуса
      print('Тело ответа: ${response.body}'); // Лог тела ответа

      if (response.statusCode == 200) {
        print('Статус продукта успешно обновлён');
      } else {
        print('Ошибка: ${response.statusCode}, Тело ответа: ${response.body}');
        throw Exception('Не удалось обновить статус продукта');
      }
    } catch (e) {
      print('Исключение: $e');
      throw Exception('Ошибка при выполнении запроса: $e');
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
