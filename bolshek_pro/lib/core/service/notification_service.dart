import 'dart:convert';
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/notifications_response.dart';
import 'package:bolshek_pro/core/models/vehicle_brands_response.dart';
import 'package:bolshek_pro/core/models/vehicle_generation_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}';

  /// Fetch all brands using GET
  Future<NotificationsResponse> getNotifications({
    required BuildContext context,
    required String modelId,
  }) async {
    try {
      final token = _getToken(context);
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return NotificationsResponse.fromJson(json);
      } else {
        throw Exception('Failed to load brands: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching brands: $e');
    }
  }

  Future<void> sendDeviceToken(BuildContext context, String fcmToken) async {
    try {
      // Получаем токен авторизации из провайдера
      final authToken = _getToken(context);
      final body = {
        "token": fcmToken, // Используем переданный FCM token
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/register'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('FCM token отправлен успешно');
      } else {
        throw Exception(
            'Failed to create brand: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error send token: $e');
    }
  }

  Future<void> markNotificationAsRead({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final token = _getToken(context);
      final response = await httpClient.patch(
        Uri.parse('$_baseUrl/notifications/$id/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) { 
        print('Уведомление успешно отмечено как прочитанное');
      } else {
        throw Exception(
            'Не удалось отметить уведомление как прочитанное: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception(
          'Ошибка при попытке отметить уведомление как прочитанное: $e');
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
