import 'dart:convert';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class PropertiesService {
  final String _baseUrl = '${Constants.baseUrl}/categories';

  /// Fetch all categories using GET
  Future<PropertiesResponse> fetchProperties(
      BuildContext context, String categoryId) async {
    try {
      final token = _getToken(context);
      final url = '$_baseUrl/$categoryId/properties';
      print('Request URL: $url');
      print(
          'Request Headers: {Authorization: Bearer $token, Content-Type: application/json}');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PropertiesResponse.fromJson(json);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Retrieve the token from AuthProvider
  String _getToken(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.authResponse?.token;

    if (token == null || token.isEmpty) {
      print('No token found in AuthProvider');
      throw Exception('No token found');
    }

    print('Retrieved Token: $token');
    return token;
  }
}
