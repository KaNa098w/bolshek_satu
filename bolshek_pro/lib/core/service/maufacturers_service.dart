import 'dart:convert';
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/manufacturers_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ManufacturersService {
  final String _baseUrl = '${Constants.baseUrl}/manufacturers?take=999';

  /// Fetch all brands using GET
  Future<ManufacturersResponse> fetchManufacturers(BuildContext context) async {
    try {
      final token = _getToken(context);
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ManufacturersResponse.fromJson(json);
      } else {
        throw Exception('Failed to load brands: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching brands: $e');
    }
  }

  /// Create a new brand using POST
  Future<void> createManufacturers(BuildContext context, String name) async {
    try {
      final token = _getToken(context);
      final body = {
        "name": name,
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
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
