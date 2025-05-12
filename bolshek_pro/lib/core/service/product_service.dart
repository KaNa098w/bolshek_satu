import 'dart:convert';
import 'dart:math';
import 'package:bolshek_pro/core/models/product_responses.dart';
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

Future<Map<String, int>> fetchProductTotals({
  required BuildContext context,
}) async {
  try {
    final token = _getToken(context);

    final statuses = [
      Constants.activeStatus,
      Constants.inactiveStatus,
      Constants.awaitingStatus
    ];

    final results = await Future.wait(
      statuses.map(
        (status) => _fetchProductCount(
          context: context,
          status: status,
          token: token,
        ),
      ),
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


Future<int> _fetchProductCount({
  required BuildContext context,
  required String status,
  required String token,
}) async {
  try {
    final response = await httpClient.get(
      Uri.parse('$_baseUrl?$status&take=1'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProductResponse.fromJson(json).total ?? 0;
    } else {
      throw Exception('Failed to fetch product count: ${response.statusCode}');
    }
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
      final response = await httpClient.get(
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

  Future<ProductResponse> fetchProductsName({
    required BuildContext context,
    required String name,
  }) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_baseUrl?name=$name&take=25&categoryWithChildren=true'),
        headers: {
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

  Future<ProductItems> fetchProduct({
    required BuildContext context,
    required String id,
  }) async {
    // final String token = _getToken(context);

    try {
      print('Запрос к сервису: $_baseUrl/$id'); // Лог URL
      // print('Токен: $token'); // Лог токена

      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          // 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Статус ответа: ${response.statusCode}'); // Лог статуса
      print('Тело ответа: ${response.body}'); // Лог тела ответа

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('Декодированный JSON: $json'); // Лог декодированного JSON

        // Прямо создаём объект ProductItems из JSON
        final product = ProductItems.fromJson(json);
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
    String descriptionText,
    String crossNumber,
    String vehicleGenerationId,
    double price,
    String kind,
    String sku,
    String manufacturerId,
  ) async {
    try {
      final token = _getToken(context);

      // Тело запроса с вложенными ценами – flat-поля удалены!
      final body = <String, dynamic>{
        "name": name,
        "slug": slug,
        "brandId": brandId,
        "deliveryType": deliveryType,
        "categoryId": categoryId,
        "vendorCode": vendorCode,
        "description": {
          "time": DateTime.now().millisecondsSinceEpoch,
          "blocks": [
            {
              "id": _generateBlockId(),
              "type": "paragraph",
              "data": {"text": descriptionText},
            }
          ],
        },
        "crossNumber": crossNumber,
        // Обязательно: вложенный объект basePrice
        "basePrice": {
          "amount": price,
          "precision": 2, // число, не строка
          "currency": "KZT",
        },
        // Обязательно: вложенный объект price
        "price": {
          "amount": price,
          "precision": 2,
          "currency": "KZT",
        },
        "kind": kind,
        "sku": sku,
        "manufacturerId": manufacturerId,
        "discountPercent": 0,
        // Если API поддерживает скидку – вложенный объект discountedPrice
        "discountedPrice": {
          "amount": 0,
          "precision": 2,
          "currency": "KZT",
        },
      };

      // Добавляем vehicleGenerationId, если нужно
      if (vehicleGenerationId.isNotEmpty) {
        body["vehicleGenerationId"] = vehicleGenerationId;
      }

      print('Request body: ${jsonEncode(body)}');

      final response = await httpClient.post(
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
          'Failed to create product: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      print('Error creating product: $e');
      throw Exception('Error creating product: $e');
    }
  }

  Future<http.Response> productDuplicate(
      BuildContext context, String productId) async {
    try {
      final token = _getToken(context);

      final response = await httpClient.post(
        Uri.parse('$_baseUrl/$productId/duplicate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

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
