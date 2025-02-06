import 'dart:convert';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:bolshek_pro/core/models/auth_response.dart';
import 'package:bolshek_pro/core/models/auth_session_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String baseUrl = Constants.baseUrl;

  Future<AuthResponse> registerUser(String email, String password) async {
    try {
      final Map<String, String> requestBody = {
        "email": email,
        "password": password,
      };

      print('POST $baseUrl/auth/user');
      print('Request body: ${jsonEncode(requestBody)}');

      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/user'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Decoded response: $responseData');
        return AuthResponse.fromJson(responseData);
      } else {
        final errorData = json.decode(response.body);
        print('Error data: $errorData');
        throw Exception(
            "Ошибка: ${errorData['message'] ?? 'Неизвестная ошибка'}");
      }
    } catch (e) {
      print('Exception in registerUser: $e');
      throw Exception(
          "Не удалось авторизоваться. Пожалуйста, проверьте подключение.");
    }
  }

  Future<AuthSessionResponse> fetchAuthSession(BuildContext context) async {
    try {
      final token = _getToken(context);

      print('GET $baseUrl/auth/session');
      print('Authorization token: Bearer $token');

      final response = await httpClient.get(
        Uri.parse('$baseUrl/auth/session'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return AuthSessionResponse.fromJson(json);
      } else {
        print('Error in fetchAuthSession: ${response.body}');
        throw Exception('Failed to load session: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in fetchAuthSession: $e');
      rethrow;
    }
  }

  Future<AuthSessionResponse> checkAuthToken(
      BuildContext context, String token) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/auth/session'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return AuthSessionResponse.fromJson(json);
      } else {
        throw Exception('Failed to load session: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchOtpId(
      BuildContext context, String phoneNumber) async {
    try {
      final body = {
        "phoneNumber": phoneNumber,
      };

      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/user/request-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Номер успешно отправлен');
        // Возвращаем распакованный JSON
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData['code'] == 10002) {
          // Сообщение для неактивного аккаунта
          throw Exception(
              'Ваш аккаунт еще не активен. Пожалуйста, ждите ответа менеджера.');
        } else {
          // Обработка других ошибок с кодом 400
          throw Exception(
              'Ошибка при отправке номера: ${response.statusCode}, ${response.body}');
        }
      } else {
        throw Exception(
            'Ошибка при отправке номера: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> signWitpPhone(
      BuildContext context, String otpId, String otpCode) async {
    try {
      final body = {
        "otpId": otpId,
        "otpCode": otpCode,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/auth/user/phone'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Номер успешно отправлен');
        // Возвращаем распакованный JSON
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Ошибка: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  Future<Map<String, dynamic>> sendRegister(
    BuildContext context,
    String otpId,
    String otpCode,
    String firstName,
    String lastName,
    double longitude,
    double latitude,
    String address,
    String organizationName,
    List<String> organizationAllowedCategoryIds,
    List<String> organizationAllowedBrandIds,
  ) async {
    try {
      final body = {
        "otpId": otpId,
        "otpCode": otpCode,
        "firstName": firstName,
        "lastName": lastName,
        "organizationName": organizationName,
        "organizationAllowedCategoryIds": organizationAllowedCategoryIds,
        "organizationAllowedBrandIds": organizationAllowedBrandIds,
        "organizationAddress": address,
        "organizationAddressLatitude": latitude,
        "organizationAddressLongitude": longitude,
        "organizationAddressCityId": '1d7eb308-dbd8-496e-8875-3dd6e917c7f6',
      };

      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/user/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Регистрация прошла успешно');
        // Возвращаем распакованный JSON
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Ошибка при регистрации: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  String _getToken(BuildContext context) {
    try {
      final authProvider = Provider.of<GlobalProvider>(context, listen: false);
      final token = authProvider.authResponse?.token;

      if (token == null || token.isEmpty) {
        print('No token found in _getToken');
        throw Exception('No token found');
      }

      print('Token being sent: $token');
      return token;
    } catch (e) {
      print('Exception in _getToken: $e');
      rethrow;
    }
  }
}
