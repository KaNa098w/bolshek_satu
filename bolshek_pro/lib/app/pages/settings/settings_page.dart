import 'package:bolshek_pro/app/pages/auth/auth_main_page.dart';
import 'package:bolshek_pro/app/pages/auth/auth_page.dart';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:bolshek_pro/app/widgets/phoneNumber_widget.dart';
import 'package:bolshek_pro/app/widgets/textfield_widget.dart';
import 'package:bolshek_pro/app/widgets/yandex_map_show_widget.dart';
import 'package:bolshek_pro/app/widgets/yandex_map_widget.dart';
import 'package:bolshek_pro/core/models/organization_members_response.dart';
import 'package:bolshek_pro/core/service/address_service.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/core/service/manager_service.dart';
import 'package:bolshek_pro/core/service/my_organization_service.dart';
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
  late Future<OrganizationMembersResponse> _membersFuture;
  String selectedAddress = 'Адрес не выбран';
  String selectedCountry = 'Страна неизвестна';
  String selectedCity = 'Город неизвестен';
  double? selectedLatitude;
  double? selectedLongitude;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final managerService = ManagerService();

  @override
  void initState() {
    super.initState();
    _authSessionFuture = AuthService().fetchAuthSession(context);

    _authSessionFuture.then((data) {
      if (data.user?.organization?.id != null) {
        String organizationId = data.user!.organization!.id!;
        _loadOrganizationData(organizationId);
      }
    });
  }

  void _loadOrganizationData(String organizationId) {
    setState(() {
      _addressFuture = _fetchAddress(organizationId);
      _membersFuture = _fetchMembers(organizationId);
    });
  }

  Future<AddressResponse> _fetchAddress(String organizationId) {
    return AddressService().getAddressOrganization(context, organizationId);
  }

  Future<OrganizationMembersResponse> _fetchMembers(String organizationId) {
    return MyOrganizationService()
        .getOrganizationMembers(context, organizationId);
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

  void _addManager(String organizationId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Заполните данные\nдля добавления менеджера",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                CustomEditableField(
                  title: "Имя",
                  value: "",
                  onChanged: (value) {
                    firstNameController.text = value;
                  },
                ),
                const SizedBox(height: 16),
                CustomEditableField(
                  title: 'Фамилия',
                  value: '',
                  onChanged: (value) {
                    lastNameController.text = value;
                  },
                ),
                const SizedBox(height: 16),
                OTPInputField(
                  title: 'Введите номер',
                  onChanged: (value) {
                    phoneNumberController.text = value;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final firstName = firstNameController.text.trim();
                      final lastName = lastNameController.text.trim();
                      String phoneNumber = phoneNumberController.text
                          .replaceAll(RegExp(r'[^\d+]'), '');
                      if (firstName.isEmpty ||
                          lastName.isEmpty ||
                          phoneNumber.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Пожалуйста, заполните все поля')),
                        );
                        return;
                      }

                      try {
                        await managerService.createManager(
                          context,
                          firstName,
                          lastName,
                          phoneNumber,
                          organizationId, // замените на реальный organizationId
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Менеджер успешно добавлен',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);

                        setState(() {
                          _membersFuture = _fetchMembers(organizationId);
                        });
                      } catch (e) {
                        print('Менеджер: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      "Добавить",
                      style: TextStyle(
                        fontFamily: 'InterRegular',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editManager(String userId, String phoneNumber, String organizationId,
      String fisrtName, String lastName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Данные менеджера",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                CustomEditableField(
                  title: "Имя",
                  value: fisrtName,
                  onChanged: (value) {
                    firstNameController.text = value;
                  },
                ),
                const SizedBox(height: 16),
                CustomEditableField(
                  title: 'Фамилия',
                  value: lastName,
                  onChanged: (value) {
                    lastNameController.text = value;
                  },
                ),
                const SizedBox(height: 16),
                OTPInputField(
                  title: 'Номер',
                  initialValue: phoneNumber, // Устанавливаем переданный номер
                  onChanged: (value) {
                    phoneNumberController.text = value;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final firstName = firstNameController.text.trim();
                      final lastName = lastNameController.text.trim();
                      String phoneNumber = phoneNumberController.text
                          .replaceAll(RegExp(r'[^\d+]'), '');
                      if (firstName.isEmpty ||
                          lastName.isEmpty ||
                          phoneNumber.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Пожалуйста, заполните все поля')),
                        );
                        return;
                      }

                      try {
                        await managerService.updateManager(
                          context,
                          userId,
                          firstName,
                          lastName,
                          phoneNumber,
                          organizationId,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Менеджер успешно изменен',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);

                        setState(() {
                          _membersFuture = _fetchMembers(organizationId);
                        });
                      } catch (e) {
                        print('Менеджер: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      "Изменить",
                      style: TextStyle(
                        fontFamily: 'InterRegular',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteManager(String itemId, String organizationId) async {
    await showCustomAlertDialog(
      context: context,
      title: 'Подтверждение удаления',
      content: const Text('Вы уверены, что хотите удалить этого менеджера?'),
      onConfirm: () async {
        Navigator.of(context)
            .pop(); // Закрыть диалог перед выполнением действия
        try {
          await managerService.deleteManager(context, itemId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Менеджер успешно удален',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );

          setState(() {
            _membersFuture = _fetchMembers(organizationId);
          });
        } catch (e) {
          print('Ошибка при удалении менеджера: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Не удалось удалить менеджера',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      onCancel: () {
        Navigator.of(context).pop(); // Закрыть диалог при отмене
      },
      confirmText: 'Удалить',
      cancelText: 'Отмена',
    );
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

                  _buildInfoRow(
                    title: "Номер телефона:",
                    value: data.user?.phoneNumber ?? "Неизвестно",
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Адрес организации:",
                    style: TextStyle(
                      fontSize: 16,
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
                                                  fontSize: 15,
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
                                                color: Colors.blueAccent),
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
                            vertical: 8), // Высота кнопки
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
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Менеджер организации:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.blackWithPath,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<OrganizationMembersResponse>(
                    future: _membersFuture,
                    builder: (context, members) {
                      if (members.connectionState == ConnectionState.waiting) {
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
                      } else if (members.hasError) {
                        return Center(
                          child: Text(
                              "Ошибка загрузки менеджера: ${members.error}"),
                        );
                      } else if (!members.hasData ||
                          members.data!.items == null ||
                          members.data!.items.isEmpty) {
                        return Center(child: Text("Менеджеры не найдены"));
                      }

                      final items = members.data!.items!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...items
                              .where((item) =>
                                  data.user?.phoneNumber != item.phoneNumber)
                              .map((item) {
                            final name = item.firstName ?? "неизвестен";
                            final lastname = item.lastName ?? "неизвестен";
                            final phoneNumber = item.phoneNumber;
                            final status = item.isActive;

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
                                              Icon(Icons.person_2_outlined,
                                                  color: ThemeColors.orange),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      name,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      lastname,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.phone,
                                                  color: Colors.orangeAccent),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  "Номер: $phoneNumber",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.sensors_sharp,
                                                  color: Colors.orangeAccent),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: 'Статус: '),
                                                      TextSpan(
                                                        text: status
                                                            ? 'Активный'
                                                            : 'Не активный',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: status
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                    ],
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
                                          onPressed: () {
                                            _editManager(
                                                item.id,
                                                item.phoneNumber,
                                                organization.id ?? '',
                                                item.firstName,
                                                item.lastName);
                                          }, // Передаём координаты
                                          icon: Icon(
                                            Icons.edit_rounded,
                                            color: Colors.green,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              Icons.delete_outline_rounded,
                                              color: Colors.redAccent),
                                          onPressed: () {
                                            _deleteManager(
                                                item.id, organization.id ?? '');
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          if (items
                              .where((item) =>
                                  data.user?.phoneNumber != item.phoneNumber)
                              .isEmpty)
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  "У вас нет менеджеров",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _addManager(organization.id ?? '');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            ThemeColors.orange, // Цвет текста кнопки
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Овальные края
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8), // Высота кнопки
                        // elevation: 5, // Тень для объёмности
                      ),
                      child: const Text(
                        'Добавить менеджер',
                        style: TextStyle(
                          fontSize: 15, // Размер текста
                          fontWeight: FontWeight.bold, // Жирный текст
                        ),
                      ),
                    ),
                  ),

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
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
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
}
