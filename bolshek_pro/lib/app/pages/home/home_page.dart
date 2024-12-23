import 'package:bolshek_pro/core/service/city_service.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/add_name_product_page.dart';
import 'package:bolshek_pro/app/pages/settings/settings_widget/city_widgets/city_selection.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/home_widgets/empty_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CityService _cityService = CityService();
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadSelectedCity();
  }

  Future<void> _loadSelectedCity() async {
    final city = await _cityService.getSavedCity();
    setState(() {
      _selectedCity = city;
    });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyState(),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Добавить первый товар',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductNameInputPage()),
                );
              },
            ),
            const SizedBox(height: 13),
            CustomButton(
              text: 'Открыть чат с Bolshek',
              onPressed: () {
                // Логика открытия чата
              },
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final CityService _cityService = CityService();
//   final ProductService _productService = ProductService();

//   String? _selectedCity;

//   int _activeTotal = 0;
//   int _inactiveTotal = 0;
//   int _statusesTotal = 0;

//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedCity();
//     _loadTotals();
//   }

//   Future<void> _loadSelectedCity() async {
//     final city = await _cityService.getSavedCity();
//     setState(() {
//       _selectedCity = city;
//     });
//   }

//   Future<void> _loadTotals() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       // Загружаем активные товары
//       final activeResponse = await _productService.fetchProductsPaginated(
//         context: context,
//         take: 1,
//         skip: 0,
//         status: 'active',
//       );
//       final activeTotal = activeResponse.total ?? 0;

//       // Загружаем неактивные товары
//       final inactiveResponse = await _productService.fetchProductsPaginated(
//         context: context,
//         take: 1,
//         skip: 0,
//         status: 'inactive',
//       );
//       final inactiveTotal = inactiveResponse.total ?? 0;

//       // Загружаем товары из fetchProductsStatuses
//       final statusesResponse = await _productService.fetchProductsStatuses(
//         context: context,
//       );
//       final statusesTotal = statusesResponse.total ?? 0;

//       setState(() {
//         _activeTotal = activeTotal;
//         _inactiveTotal = inactiveTotal;
//         _statusesTotal = statusesTotal;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Ошибка при загрузке данных: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Временно убрать вывод количества товаров
//                   const Text(
//                     'Добавьте первый товар!',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 20),
//                   // Показать кнопку добавления товара
//                   CustomButton(
//                     text: 'Добавить товар',
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ProductNameInputPage()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

