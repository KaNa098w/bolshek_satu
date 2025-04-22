import 'dart:convert';
import 'package:bolshek_pro/core/models/tags_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagsService {
  final String _baseUrl = '${Constants.baseUrl}';
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );

  /// Fetch all brands using GET
  Future<TagsResponse> getTags(BuildContext context) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/tags'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return TagsResponse.fromJson(json);
      } else {
        throw Exception('Failed to load brands: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching brands: $e');
    }
  }

  Future<void> createTags(
      BuildContext context, String tagIds, String id) async {
    try {
      // Разбиваем строку идентификаторов по запятой и убираем лишние пробелы
      final List<String> tagIdsList =
          tagIds.split(',').map((e) => e.trim()).toList();
      final token = _getToken(context);

      final body = {
        "tagIds": tagIdsList,
      };

      final response = await httpClient.post(
        Uri.parse('$_baseUrl/products/$id/tags'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Brand created successfully');
      } else {
        throw Exception(
            'Failed to create brand: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating brand: $e');
    }
  }

  Future<void> deleteAndCreate(
      BuildContext context, String tagIds, String id) async {
    try {
      // Разбиваем строку идентификаторов по запятой и убираем лишние пробелы
      final List<String> tagIdsList =
          tagIds.split(',').map((e) => e.trim()).toList();
      final token = _getToken(context);

      final body = {"tagIds": tagIdsList, "deleteOld": true};

      final response = await httpClient.post(
        Uri.parse('$_baseUrl/products/$id/tags'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Brand created successfully');
      } else {
        throw Exception(
            'Failed to create brand: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating brand: $e');
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
