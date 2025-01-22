import 'package:bolshek_pro/app/pages/auth/auth_main_page.dart';
import 'package:bolshek_pro/app/pages/auth/auth_page.dart';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:bolshek_pro/app/widgets/yandex_map_show_widget.dart';
import 'package:bolshek_pro/app/widgets/yandex_map_widget.dart';
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
  String selectedAddress = 'Адрес не выбран';
  String selectedCountry = 'Страна неизвестна';
  String selectedCity = 'Город неизвестен';
  double? selectedLatitude;
  double? selectedLongitude;

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
        content: Text('Вы уверены, что хотите выйти?'),
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );

    if (confirm) {
      await context.read<GlobalProvider>().logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthMainScreen()),
        (route) => false,
      );
    }
  }

  void _showInMap(double latitude, double longitude) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            YandexMapViewPage(latitude: latitude, longitude: longitude),
      ),
    );
  }

  Future<void> _deleteAddress(String addressId, String organizationId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Удаление адреса',
        content: Text('Вы уверены, что хотите удалить этот адрес?'),
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );

    if (confirm) {
      try {
        await AddressService()
            .deleteAddress(context, organizationId, addressId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Адрес успешно удалён',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Обновляем список адресов
        setState(() {
          _addressFuture = _fetchAddress(organizationId);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при удалении адреса: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          final topic = data.user?.fcmTopic;

          print('ВАШ ТОПИК $topic');

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
                    value: data.user?.email ?? "Не указано",
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
                            1, // Количество заглушек
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
                          final addresId = item.id;
                          final cityId = item.cityId;

                          return Card(
                            color: Colors.grey.shade100,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 0, // Убираем тень
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => _showInMap(
                                            item.latitude!,
                                            item.longitude!), // Передаём координаты
                                        icon: Icon(
                                          Icons.map_outlined,
                                          color: Colors.green,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline_rounded,
                                            color: Colors.redAccent),
                                        onPressed: () => _deleteAddress(
                                            addresId ?? '',
                                            organization.id ?? ''),
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
                  Container(
                    width: double.infinity, // Кнопка занимает всю ширину

                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YandexMapPickerScreen(),
                          ),
                        );

                        if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            selectedAddress =
                                result['address'] ?? 'Адрес не выбран';
                            selectedCountry =
                                result['country'] ?? 'Страна неизвестна';
                            selectedCity = result['city'] ?? 'Город неизвестен';
                            selectedLatitude = result['latitude'];
                            selectedLongitude = result['longitude'];
                          });

                          final addressData = {
                            "cityId": "60f95c44-05e8-4031-9d9b-fad22fcd0d0c",
                            "address": selectedAddress,
                            "additionalInfo":
                                "$selectedCountry, $selectedCity, $selectedAddress",
                            "latitude": selectedLatitude,
                            "longitude": selectedLongitude,
                          };

                          try {
                            final organizationId =
                                organization.id ?? ''; // Укажите актуальный ID
                            await AddressService().addAddress(
                                context, organizationId, addressData);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Адрес успешно добавлен',
                                  style: TextStyle(
                                      color: Colors.white), // Белый цвет текста
                                ),
                                backgroundColor: Colors.green, // Зеленый фон
                                behavior: SnackBarBehavior
                                    .floating, // Опционально: чтобы SnackBar был "плавающим"
                                duration: const Duration(
                                    seconds: 3), // Длительность отображения
                              ),
                            );

                            // Обновляем список адресов
                            setState(() {
                              _addressFuture = _fetchAddress(organizationId);
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Ошибка при добавлении адреса: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue, // Цвет текста кнопки
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Овальные края
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12), // Высота кнопки
                        // elevation: 5, // Тень для объёмности
                      ),
                      child: const Text(
                        'Добавить адрес',
                        style: TextStyle(
                          fontSize: 15, // Размер текста
                          fontWeight: FontWeight.bold, // Жирный текст
                        ),
                      ),
                    ),
                  ),

// // Отображение выбранного адреса
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Выбранный адрес: $selectedAddress'),
//                       Text('Страна: $selectedCity'),
//                       Text('Город: 60f95c44-05e8-4031-9d9b-fad22fcd0d0c'),
//                       Text('Широта: ${selectedLatitude ?? 'Не определена'}'),
//                       Text('Долгота: ${selectedLongitude ?? 'Не определена'}'),
//                     ],
//                   ),
                  SizedBox(
                    height: 7,
                  ),

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
