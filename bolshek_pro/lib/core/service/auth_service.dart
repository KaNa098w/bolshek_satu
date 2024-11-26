import 'dart:convert';
import 'package:bolshek_pro/core/models/auth_response.dart';
import 'package:bolshek_pro/core/models/auth_session_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthService {
  final String baseUrl = Constants.baseUrl;

  Future<AuthResponse> registerUser(String email, String password) async {
    try {
      final Map<String, String> requestBody = {
        "email": email,
        "password": password,
      };

      print('POST $baseUrl/auth/user');
      print('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
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
          "Не удалось зарегистрироваться. Пожалуйста, проверьте подключение.");
    }
  }

  Future<AuthSessionResponse> fetchAuthSession(BuildContext context) async {
    try {
      final token = _getToken(context);

      print('GET $baseUrl/auth/session');
      print('Authorization token: Bearer $token');

      final response = await http.get(
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
