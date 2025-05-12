import 'dart:convert';
import 'package:bolshek_pro/core/models/warehouse_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class WarehouseService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}/warehouses';

  Future<WarehouseResponse> getWarehouses(
      BuildContext context, String organizationId) async {
    try {
      final token = _getToken(context);
      final url = '$_baseUrl?relatedOrganizationId=$organizationId';
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
        return WarehouseResponse.fromJson(json);
      } else {
        throw Exception('Failed to load warehouse: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching warehouse: $e');
    }
  }

   

  Future<WarehouseItem> getWarehousesById(
      BuildContext context, String warehouseId) async {
    try {
      final token = _getToken(context);
      final url = '$_baseUrl/$warehouseId';

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
        return WarehouseItem.fromJson(json);
      } else {
        throw Exception('Failed to load warehouse: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching warehouse: $e');
    }
  }

   Future<void> createWarehouseProduct(
      BuildContext context, String quantity, String productId, String id) async {
    try {
      final token = _getToken(context);
      final body = {
        "quantity": quantity,
        "productId": productId
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/$id/products'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Warehouse created successfully');
      } else {
        throw Exception(
            'Failed to create warehouse: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating warehouse: $e');
    }
  }

  Future<void> createWarehouse(
  BuildContext context,
  double longitude,
  double latitude,
  String address,
  String cityId,
  String firstName,
  String name,
  String lastName,
  String phoneNumber,
  String organizationId,
  bool main,
) async {
  try {
    final token = _getToken(context);

    final body = {
      "name": name, // имя склада
      "address": address,
      "cityId": cityId,
      "latitude": latitude,
      "longitude": longitude,
      "isMain": main,
      "relatedOrganizationId": organizationId, // это UUID
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
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
      print('Warehouse created successfully');
    } else {
      throw Exception(
        'Failed to create warehouse: ${response.statusCode}, ${response.body}',
      );
    }
  } catch (e) {
    throw Exception('Error creating warehouse: $e');
  }
}

  

  Future<void> updateWarehouse(
    BuildContext context,
    String warehouseId,
    WarehouseItem warehouse,
  ) async {
    try {
      final token = _getToken(context);

      final body = {
        "name": warehouse.name,
        "latitude": warehouse.address.latitude,
        "longitude": warehouse.address.longitude,
        "address": warehouse.address.address,
        "zipCode": warehouse.address.zipCode ?? "",
        "entrance": warehouse.address.entrance ?? "",
        "apartment": warehouse.address.apartment ?? 0,
        "floor": warehouse.address.floor ?? 0,
        "intercom": warehouse.address.intercom ?? "",
        "additionalInfo": warehouse.address.additionalInfo ?? "",
        // "cityId": warehouse.address.city.id,
        "relatedOrganizationId": warehouse.organizationId,
        "isMain": warehouse.isMain,
        "firstName": warehouse.manager.firstName,
        "lastName": warehouse.manager.lastName,
        "phoneNumber": warehouse.manager.phoneNumber,
      };

      final response = await httpClient.put(
        Uri.parse('$_baseUrl/$warehouseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Warehouse updated successfully');
      } else {
        throw Exception(
          'Failed to update warehouse: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error updating warehouse: $e');
    }
  }

  Future<void> deleteWarehouse(
  BuildContext context,
  String warehouseId,
) async {
  try {
    final token = _getToken(context);

    final response = await httpClient.delete(
      Uri.parse('$_baseUrl/$warehouseId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Warehouse deleted successfully');
    } else {
      throw Exception(
        'Failed to delete warehouse: ${response.statusCode}, ${response.body}',
      );
    }
  } catch (e) {
    throw Exception('Error deleting warehouse: $e');
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
