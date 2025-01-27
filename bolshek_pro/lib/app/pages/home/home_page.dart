import 'package:bolshek_pro/core/models/order_detail_response.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/service/city_service.dart';
import 'package:bolshek_pro/app/pages/home/add_name_product_page.dart';
import 'package:bolshek_pro/app/pages/settings/settings_widget/city_widgets/city_selection.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/home_widgets/empty_state.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final CityService _cityService = CityService();
//   String? _selectedCity;

//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedCity();
//   }

//   Future<void> _loadSelectedCity() async {
//     final city = await _cityService.getSavedCity();
//     setState(() {
//       _selectedCity = city;
//     });
//   }

//   void _changeCity() async {
//     final selectedCity = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const CitySelectionPage()),
//     );
//     if (selectedCity != null) {
//       setState(() {
//         _selectedCity = selectedCity;
//       });
//     }
//   }

//   Future<void> _openWhatsAppChat() async {
//     const phoneNumber = '77001012200'; // Пример для Казахстана
//     final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');

//     // Проверяем, можно ли запустить ссылку
//     if (await canLaunchUrl(whatsappUri)) {
//       // Используем launchUrl с LaunchMode.externalApplication
//       await launchUrl(
//         whatsappUri,
//         mode: LaunchMode.externalApplication,
//       );
//     } else {
//       // Показываем сообщение об ошибке
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Не удалось открыть WhatsApp'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const EmptyState(),
//             const SizedBox(height: 20),
//             CustomButton(
//               text: 'Добавить первый товар',
//               onPressed: () {
//                 final globalProvider =
//                     Provider.of<GlobalProvider>(context, listen: false);
//                 globalProvider
//                     .clearProductData(); // Очистка данных в провайдере

//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductNameInputPage(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 13),
//             CustomButton(
//               text: 'Открыть чат с Bolshek',
//               onPressed: _openWhatsAppChat,
//               isPrimary: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CityService _cityService = CityService();
  final ProductService _productService = ProductService();

  String? _selectedCity;

  int _activeTotal = 0;
  int _inactiveTotal = 0;
  int _statusesTotal = 0;

  /// Список товаров со статусами (результат fetchProductsStatuses)
  List<ProductResponse> _productStatuses = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedCity();
    _loadTotals();
  }

  Future<void> _openWhatsAppChat() async {
    const phoneNumber = '77001012200'; // Пример для Казахстана
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось открыть WhatsApp'),
        ),
      );
    }
  }

  Future<void> _loadSelectedCity() async {
    final city = await _cityService.getSavedCity();
    setState(() {
      _selectedCity = city;
    });
  }

  Future<void> _loadTotals() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Загружаем активные товары
      final activeResponse = await _productService.fetchProductsForMain(
        context: context,
        status: Constants.activeStatus,
      );
      final activeTotal = activeResponse.total ?? 0;

      // Загружаем неактивные товары
      final inactiveResponse = await _productService.fetchProductsForMain(
        context: context,
        status: Constants.awaitingStatus,
      );
      final inactiveTotal = inactiveResponse.total ?? 0;

      // Загружаем товары из fetchProductsStatuses
      final statusesResponse = await _productService.fetchProductsStatuses(
        context: context,
      );

      final statusesTotal = statusesResponse.total ?? 0;

      // Сохраняем полученные значения в стейт
      setState(() {
        _activeTotal = activeTotal;
        _inactiveTotal = inactiveTotal;
        _statusesTotal = statusesTotal;
        // Сохраняем список товаров, чтобы показать их в таблице

        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка при загрузке данных: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeCity() async {
    final selectedCity = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CitySelectionPage()),
    );
    if (selectedCity != null) {
      setState(() {
        _selectedCity = selectedCity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            // Если идёт загрузка — показываем прелоадер
            // child: _isLoading
            //     ? const CircularProgressIndicator()
            //     // Если товары (statusesTotal) есть, показываем таблицу
            //     : _activeTotal > 0
            //         ? _buildStatusesTable()
            // Если товаров нет — ваш текущий EmptyState и кнопки
            // :
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyState(),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Добавить первый товар',
              onPressed: () {
                final globalProvider =
                    Provider.of<GlobalProvider>(context, listen: false);
                globalProvider
                    .clearProductData(); // Очистка данных в провайдере

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductNameInputPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 13),
            CustomButton(
              text: 'Открыть чат с Bolshek',
              onPressed: _openWhatsAppChat,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  /// Метод, создающий таблицу со списком товаров/статусов
  Widget _buildStatusesTable() {
    return Column(children: [
      Row(
        children: [
          Text('Активные товары: '),
          Text(_activeTotal.toString()),
        ],
      ),
      Row(
        children: [
          Text('Неактивные товары: '),
          Text(_inactiveTotal.toString()),
        ],
      )
    ]);
  }
}
