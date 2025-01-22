// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AuthService {
//   final String baseUrl;

//   AuthService(this.baseUrl);

//   Future<Map<String, dynamic>> requestOtp(String phoneNumber) async {
//     final url = Uri.parse('$baseUrl/auth/user/request-otp');
//     final headers = {
//       'Content-Type': 'application/json',
//     };
//     final body = jsonEncode({
//       "phoneNumber": phoneNumber,
//     });

//     try {
//       final response = await http.post(url, headers: headers, body: body);

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception(
//             'Ошибка: ${response.statusCode} ${response.reasonPhrase}');
//       }
//     } catch (error) {
//       throw Exception('Не удалось выполнить запрос: $error');
//     }
//   }
// }
