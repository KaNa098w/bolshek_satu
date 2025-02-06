import 'dart:convert';
import 'dart:math';
import 'package:bolshek_pro/core/models/fetch_product_response.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  final httpClient = HttpWithMiddleware.build(
    middlewares: [HttpLogger(logLevel: LogLevel.BODY)],
  );
  final String _baseUrl = '${Constants.baseUrl}/products';

  final Uuid _uuid = Uuid();

  /// Метод для генерации уникального ID блока
  String _generateBlockId() {
    return _uuid.v4(); // Генерация уникального идентификатора
  }

  Future<Map<String, int>> fetchProductTotals(
      {required BuildContext context}) async {
    try {
      final statuses = [
        Constants.activeStatus,
        Constants.inactiveStatus,
        Constants.awaitingStatus
      ];

      final results = await Future.wait(
        statuses.map(
            (status) => _fetchProductCount(context: context, status: status)),
      );

      return {
        'active': results[0],
        'inactive': results[1],
        'awaiting': results[2],
      };
    } catch (e) {
      debugPrint('Ошибка загрузки товаров: $e');
      return {'active': 0, 'inactive': 0, 'awaiting': 0};
    }
  }

  Future<int> _fetchProductCount(
      {required BuildContext context, required String status}) async {
    try {
      final response = await fetchProductsForMain(
        context: context,
        take: 1,
        status: status,
      );
      return response.total ?? 0;
    } catch (e) {
      debugPrint('Ошибка при загрузке $status: $e');
      return 0;
    }
  }

  /// Fetch products with pagination
  Future<ProductResponse> fetchProductsPaginated({
    required BuildContext context,
    required int take,
    required int skip,
    required String status,
  }) async {
    try {
      final token = _getToken(context);
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?take=$take&skip=$skip&$status&categoryWithChildren=true'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProductResponse.fromJson(json);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<ProductResponse> fetchProductsForMain({
    required BuildContext context,
    required String status,
    required int take,
  }) async {
    try {
      final token = _getToken(context);
      final response = await http.get(
        Uri.parse('$_baseUrl?$status&take=$take'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProductResponse.fromJson(json);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<ProductResponse> fetchProductsStatuses({
    required BuildContext context,
  }) async {
    try {
      final token = _getToken(context);
      final response = await http.get(
        Uri.parse('$_baseUrl?statuses=created&statuses=updated'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProductResponse.fromJson(json);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<FetchProductResponse> fetchProduct({
    required BuildContext context,
    required String id,
  }) async {
    final String token = _getToken(context);

    try {
      print('Запрос к сервису: $_baseUrl/$id'); // Лог URL
      print('Токен: $token'); // Лог токена

      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Статус ответа: ${response.statusCode}'); // Лог статуса
      print('Тело ответа: ${response.body}'); // Лог тела ответа

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('Декодированный JSON: $json'); // Лог декодированного JSON

        // Прямо создаём объект ProductItems из JSON
        final product = FetchProductResponse.fromJson(json);
        print('Сформированный FetchProductResponse: $product');
        return product;
      } else {
        print('Ошибка: ${response.statusCode}, Тело ответа: ${response.body}');
        throw Exception('Не удалось загрузить данные о продукте');
      }
    } catch (e) {
      print('Исключение: $e');
      throw Exception('Ошибка при выполнении запроса: $e');
    }
  }

  Future<http.Response> createProduct(
    BuildContext context,
    String name,
    String slug,
    String brandId,
    String deliveryType,
    String categoryId,
    String vendorCode,
    String descriptionText, // Передаём ваш текст для описания
  ) async {
    try {
      final token = _getToken(context);
      final body = {
        "name": name,
        "slug": slug,
        "brandId": brandId,
        "deliveryType": deliveryType,
        "categoryId": categoryId,
        "compatibleVehicleIds": [],
        "vendorCode": vendorCode,
        "description": {
          "time": DateTime.now().millisecondsSinceEpoch,
          "blocks": [
            {
              "id": _generateBlockId(), // Генерация уникального ID для блока
              "type": "paragraph",
              "data": {"text": descriptionText},
            }
          ],
        },
      };

      print('Creating product with data: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception(
            'Failed to create product: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error creating product: $e');
      throw Exception('Error creating product: $e');
    }
  }

  Future<http.Response> updateProduct({
    required BuildContext context,
    required String id,
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      final token = _getToken(context);

      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedFields),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response;
      } else {
        throw Exception(
            'Failed to update product: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
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
