import 'dart:convert';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ManagerService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}/users';

  Future<({String id})> createManager(
    BuildContext context,
    String firstName,
    String lastName,
    String phoneNumber,
    String organizationId,
  ) async {
    try {
      final token = _getToken(context);
      final body = {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "organizationId": organizationId,
      };

      final response = await httpClient.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final dynamic rawId = json['id'] ?? json['data']?['id'];
        if (rawId != null) {
          return (id: rawId.toString()); // 👈 тоже String
        } else {
          throw Exception('Manager created, but no ID returned');
        }
      } else {
        throw Exception(
          'Failed to create manager: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error creating manager: $e');
    }
  }

  Future<void> updateManager(
    BuildContext context,
    String userId, // id пользователя, которого обновляем
    String firstName,
    String lastName,
    String phoneNumber,
    String organizationId,
  ) async {
    try {
      final token = _getToken(context);

      final body = {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "organizationId": organizationId,
      };

      final response = await httpClient.put(
        Uri.parse('$_baseUrl/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Manager updated successfully');
      } else {
        throw Exception(
          'Failed to update manager: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error updating manager: $e');
    }
  }

  Future<void> deleteManager(BuildContext context, String userId) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.delete(
        Uri.parse('$_baseUrl/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Manager deleted successfully');
      } else {
        throw Exception(
          'Failed to delete manager: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting manager: $e');
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
