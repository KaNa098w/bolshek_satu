// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class CategoryService {
//   final String baseUrl = "https://api-stage.bolshek.com/categories";

//   // Получение списка категорий с возможностью использования параметров фильтрации
//   Future<Map<String, dynamic>> getCategories({
//     int? skip,
//     int? take,
//     List<String>? ids,
//     String? name,
//     String? slug,
//     String? parentId,
//     bool? onlyParent,
//   }) async {
//     final uri = Uri.parse(baseUrl).replace(queryParameters: {
//       if (skip != null) 'skip': skip.toString(),
//       if (take != null) 'take': take.toString(),
//       if (ids != null) 'ids': ids.join(','),
//       if (name != null) 'name': name,
//       if (slug != null) 'slug': slug,
//       if (parentId != null) 'parentId': parentId,
//       if (onlyParent != null) 'onlyParent': onlyParent.toString(),
//     });

//     final response = await http.get(uri, headers: {
//       "Content-Type": "application/json",
//     });

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to fetch categories: ${response.statusCode}");
//     }
//   }

//   // Получение категории по ID
//   Future<Map<String, dynamic>> getCategoryById(String id) async {
//     final response = await http.get(Uri.parse('$baseUrl/$id'), headers: {
//       "Content-Type": "application/json",
//     });

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to fetch category by ID: ${response.statusCode}");
//     }
//   }

//   // Создание новой категории
//   Future<Map<String, dynamic>> createCategory(
//       Map<String, dynamic> categoryData) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(categoryData),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to create category: ${response.statusCode}");
//     }
//   }

//   // Обновление категории по ID
//   Future<Map<String, dynamic>> updateCategory(
//       String id, Map<String, dynamic> updatedData) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/$id'),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(updatedData),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to update category: ${response.statusCode}");
//     }
//   }

//   // Удаление категории по ID
//   Future<bool> deleteCategory(String id) async {
//     final response = await http.delete(Uri.parse('$baseUrl/$id'), headers: {
//       "Content-Type": "application/json",
//     });

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to delete category: ${response.statusCode}");
//     }
//   }

//   // Получение фильтров категории по ID
//   Future<Map<String, dynamic>> getCategoryFilters(String id) async {
//     final response =
//         await http.get(Uri.parse('$baseUrl/$id/filters'), headers: {
//       "Content-Type": "application/json",
//     });

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception(
//           "Failed to fetch category filters: ${response.statusCode}");
//     }
//   }

//   // Получение списка свойств категории по ID
//   Future<Map<String, dynamic>> getCategoryProperties({
//     required String id,
//     int? skip,
//     int? take,
//     List<String>? ids,
//     String? name,
//     String? type,
//     String? unit,
//   }) async {
//     final uri = Uri.parse('$baseUrl/$id/properties').replace(queryParameters: {
//       if (skip != null) 'skip': skip.toString(),
//       if (take != null) 'take': take.toString(),
//       if (ids != null) 'ids': ids.join(','),
//       if (name != null) 'name': name,
//       if (type != null) 'type': type,
//       if (unit != null) 'unit': unit,
//     });

//     final response = await http.get(uri, headers: {
//       "Content-Type": "application/json",
//     });

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception(
//           "Failed to fetch category properties: ${response.statusCode}");
//     }
//   }

//   // Создание свойства категории
//   Future<Map<String, dynamic>> createCategoryProperty(
//       String id, Map<String, dynamic> propertyData) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/$id/properties'),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(propertyData),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception(
//           "Failed to create category property: ${response.statusCode}");
//     }
//   }

//   // Получение свойства категории по ID
//   Future<Map<String, dynamic>> getCategoryPropertyById(
//       String id, String propertyId) async {
//     final response = await http
//         .get(Uri.parse('$baseUrl/$id/properties/$propertyId'), headers: {
//       "Content-Type": "application/json",
//     });

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception(
//           "Failed to fetch category property by ID: ${response.statusCode}");
//     }
//   }

//   // Обновление свойства категории по ID
//   Future<Map<String, dynamic>> updateCategoryProperty(
//       String id, String propertyId, Map<String, dynamic> updatedData) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/$id/properties/$propertyId'),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(updatedData),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception(
//           "Failed to update category property: ${response.statusCode}");
//     }
//   }

//   // Удаление свойства категории по ID
//   Future<bool> deleteCategoryProperty(String id, String propertyId) async {
//     final response = await http
//         .delete(Uri.parse('$baseUrl/$id/properties/$propertyId'), headers: {
//       "Content-Type": "application/json",
//     });

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception(
//           "Failed to delete category property: ${response.statusCode}");
//     }
//   }
// }
