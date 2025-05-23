import 'dart:convert';
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/vehicle_brands_response.dart';
import 'package:bolshek_pro/core/models/vehicle_generation_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class VehicleGenerationService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}';

  /// Fetch all brands using GET
  Future<VehicleGenerationResponse> fetchVehicleGenerations({
    required BuildContext context,
    required String modelId,
  }) async {
    try {
      // final token = _getToken(context);
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/vehicle-generations?modelId=$modelId&take=999'),
        headers: {
          // 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return VehicleGenerationResponse.fromJson(json);
      } else {
        throw Exception('Failed to load brands: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching brands: $e');
    }
  }

  /// Fetch a specific brand by ID using GET
  Future<BrandItems> fetchBrandById(BuildContext context, String id) async {
    try {
      // final token = _getToken(context);
      final url = '${Constants.baseUrl}/brands/$id';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          // 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return BrandItems.fromJson(json);
      } else {
        throw Exception('Failed to load brand: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching brand by ID: $e');
    }
  }

  /// Create a new brand using POST
  Future<void> createBrand(
      BuildContext context, String type, String name, String slug) async {
    try {
      final token = _getToken(context);
      final body = {
        "type": type,
        "name": name,
        "slug": slug,
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
