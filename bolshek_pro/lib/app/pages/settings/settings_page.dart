import 'package:bolshek_pro/app/pages/auth/auth_page.dart';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:bolshek_pro/core/service/address_service.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/models/auth_session_response.dart';
import 'package:bolshek_pro/core/models/address_response.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:provider/provider.dart';

class MyOrganizationPage extends StatefulWidget {
  @override
  _MyOrganizationPageState createState() => _MyOrganizationPageState();
}

class _MyOrganizationPageState extends State<MyOrganizationPage> {
  late Future<AuthSessionResponse> _authSessionFuture;
  late Future<AddressResponse> _addressFuture;

  @override
  void initState() {
    super.initState();
    _authSessionFuture = AuthService().fetchAuthSession(context);
  }

  Future<AddressResponse> _fetchAddress(String organizationId) {
    return AddressService().getAddressOrganization(context, organizationId);
  }

  Future<void> _logout() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Выход из аккаунта',
        content: 'Вы уверены, что хотите выйти?',
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );

    if (confirm) {
      await context.read<GlobalProvider>().logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.white,
      // appBar: AppBar(
      //   title: Text(
      //     "Моя организация",
      //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: FutureBuilder<AuthSessionResponse>(
        future: _authSessionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: ThemeColors.orange,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Нет данных об организации"));
          }

          final data = snapshot.data!;
          final organization = data.user?.organization;

          if (organization == null) {
            return Center(child: Text("Информация об организации отсутствует"));
          }

          _addressFuture = _fetchAddress(organization.id!);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Информация об организации
                  _buildInfoRow(
                    title: "Имя организации:",
                    value: organization.name ?? "Неизвестно",
                  ),
                  _buildInfoRow(
                    title: "Владелец:",
                    value: '${data.user?.firstName} ${data.user?.lastName}',
                  ),
                  // _buildInfoRow(
                  //   title: "Тип:",
                  //   value:
                  //       organization.isMaster == true ? "Головная" : "Дочерняя",
                  // ),
                  // _buildInfoRow(
                  //   title: "Активность:",
                  //   value:
                  //       organization.isActive == true ? "Активна" : "Неактивна",
                  //   valueColor:
                  //       organization.isActive == true ? Colors.green : Colors.red,
                  // ),
                  _buildInfoRow(
                    title: "Логин:",
                    value: data.user?.email ?? "Неизвестно",
                  ),
                  _buildInfoRow(
                    title: "Номер телефона:",
                    value: data.user?.phoneNumber ?? "Неизвестно",
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Адрес организации:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.blackWithPath,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<AddressResponse>(
                    future: _addressFuture,
                    builder: (context, addressSnapshot) {
                      if (addressSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            3, // Количество заглушек
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: LoadingWidget(
                                width: MediaQuery.of(context).size.width *
                                    0.9, // Ширина карточки
                                height: 80.0, // Высота карточки
                                borderRadius: 12.0, // Скруглённые углы
                              ),
                            ),
                          ),
                        );
                      } else if (addressSnapshot.hasError) {
                        return Center(
                          child: Text(
                              "Ошибка загрузки адреса: ${addressSnapshot.error}"),
                        );
                      } else if (!addressSnapshot.hasData ||
                          addressSnapshot.data!.items == null ||
                          addressSnapshot.data!.items!.isEmpty) {
                        return Center(child: Text("Адреса не найдены"));
                      }

                      final items = addressSnapshot.data!.items!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: items.map((item) {
                          final cityName =
                              item.city?.name ?? "Город неизвестен";
                          final address = item.address ?? "Адрес неизвестен";

                          return Card(
                            color: Colors.grey.shade100,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 0, // Убираем тень
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_city,
                                          color: Colors.blueAccent),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Город: $cityName",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.place,
                                          color: Colors.orangeAccent),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Адрес: $address",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0.1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Радиус скругления углов
                        ),
                      ),
                      child: Text(
                        'Выйти из аккаунта',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String value,
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildAddressRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}




// import 'package:bolshek_pro/app/pages/auth/auth_page.dart';
// import 'package:bolshek_pro/core/service/city_service.dart';
// import 'package:bolshek_pro/app/pages/settings/settings_widget/city_widgets/city_selection_bottom_sheet.dart';
// import 'package:bolshek_pro/core/utils/provider.dart';
// import 'package:bolshek_pro/core/utils/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'settings_widget/warehouse_page.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({Key? key}) : super(key: key);

//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   final CityService _cityService = CityService();
//   String? _selectedCity;

//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedCity();
//   }

//   // Загрузка сохраненного города
//   Future<void> _loadSelectedCity() async {
//     final city = await _cityService.getSavedCity();
//     setState(() {
//       _selectedCity = city;
//     });
//   }

//   void _showCitySelection() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return CitySelectionBottomSheet(
//           selectedCity: _selectedCity,
//           onCitySelected: (city) {
//             setState(() {
//               _selectedCity = city;
//             });
//           },
//         );
//       },
//     );
//   }

//   Future<void> _logout() async {
//     bool confirm = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Выход из аккаунта'),
//         content: const Text('Вы уверены, что хотите выйти?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text('Выйти'),
//           ),
//         ],
//       ),
//     );

//     if (confirm) {
//       await context.read<GlobalProvider>().logout(); // Теперь метод асинхронный
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//         (route) => false,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<GlobalProvider>(context);
//     final user = authProvider.authResponse?.user;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Divider(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       user?.firstName ?? '',
//                       style: const TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       user?.lastName ?? '',
//                       style: const TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.logout,
//                     color: ThemeColors.orange,
//                     size: 25,
//                   ),
//                   onPressed: _logout,
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             title: const Text(
//               'PP1',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(_selectedCity ?? 'Город не выбран'),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'Активный',
//                   style: TextStyle(fontSize: 12, color: Colors.green),
//                 ),
//               ],
//             ),
//             trailing: const Icon(Icons.arrow_forward_ios),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       WarehousePage(selectedCity: _selectedCity ?? 'Не выбран'),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text(
//               'PP2',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(_selectedCity ?? 'Город не выбран'),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'Активный',
//                   style: TextStyle(fontSize: 12, color: Colors.green),
//                 ),
//               ],
//             ),
//             trailing: const Icon(Icons.arrow_forward_ios),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       WarehousePage(selectedCity: _selectedCity ?? 'Не выбран'),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text(
//               'PP3',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(_selectedCity ?? 'Город не выбран'),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'Не активный',
//                   style: TextStyle(fontSize: 12, color: Colors.red),
//                 ),
//               ],
//             ),
//             trailing: const Icon(Icons.arrow_forward_ios),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       WarehousePage(selectedCity: _selectedCity ?? 'Не выбран'),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
