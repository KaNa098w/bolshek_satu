import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/core/models/address_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';

class AddressService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}';

  /// Fetch all categories using GET
  Future<AddressResponse> getAddressOrganization(
      BuildContext context, String organizationId) async {
    try {
      final token = _getToken(context);
      final url = '$_baseUrl/organizations/$organizationId/addresses';
      print('Request URL: $url');
      print(
          'Request Headers: {Authorization: Bearer $token, Content-Type: application/json}');

      final response = await httpClient.get(
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
        return AddressResponse.fromJson(json);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<({String id})> addAddress(
    BuildContext context,
    String organizationId,
    Map<String, dynamic> addressData,
  ) async {
    try {
      final token = _getToken(context);
      final url = '$_baseUrl/organizations/$organizationId/addresses';

      final response = await httpClient.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(addressData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final dynamic rawId = json['id'] ?? json['data']?['id'];
        if (rawId != null) {
          return (id: rawId.toString()); // 👈 явное приведение к String
        } else {
          throw Exception('Address added, but no ID returned');
        }
      } else {
        throw Exception(
          'Failed to add address: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  Future<void> deleteAddress(
      BuildContext context, String organizationId, String addressId) async {
    try {
      final token = _getToken(context); // Получение токена
      final url =
          '$_baseUrl/organizations/$organizationId/addresses/$addressId'; // URL для DELETE-запроса

      print('DELETE URL: $url');
      print(
          'DELETE Headers: {Authorization: Bearer $token, Content-Type: application/json}');

      final response = await httpClient.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Address successfully deleted.');
      } else {
        throw Exception(
            'Failed to delete address: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error deleting address: $e');
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
