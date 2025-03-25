import 'dart:convert';
import 'package:bolshek_pro/core/models/alternative_cross_response.dart';
import 'package:bolshek_pro/core/models/cross_number_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CrossNumberGenerateService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}';

  Future<http.Response> generateCrossNumber({
    required BuildContext context,
    required String productId,
    required List<Map<String, dynamic>> crossNumberGenerations,
  }) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.post(
        Uri.parse('$_baseUrl/products/$productId/cross-number-generations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "crossNumberGenerations": crossNumberGenerations,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response;
      } else {
        throw Exception(
            'Failed to send cross numbers: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending cross numbers: $e');
    }
  }

  Future<CrossNumberResponse> getCrossNumber({
    required BuildContext context,
    required String crossNumber,
  }) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.get(
        Uri.parse(
            '$_baseUrl/cross-number-generations?crossNumber=$crossNumber'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CrossNumberResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to get cross numbers: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting cross numbers: $e');
    }
  }

  Future<AlternativeCrossResponse> getAlternativesCrossNumber({
    required BuildContext context,
    required String crossNumberId,
  }) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.get(
        Uri.parse(
            '$_baseUrl/cross-number-generations/$crossNumberId/alternatives'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AlternativeCrossResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to get alternatives cross numbers: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting alternatives cross numbers: $e');
    }
  }

  String _getToken(BuildContext context) {
    try {
      final authProvider = Provider.of<GlobalProvider>(context, listen: false);
      final token = authProvider.authResponse?.token;

      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      return token;
    } catch (e, stackTrace) {
      throw Exception('Error retrieving token: $e');
    }
  }
}
