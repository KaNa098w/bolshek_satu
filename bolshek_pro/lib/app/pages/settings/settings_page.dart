import 'package:bolshek_pro/core/service/city_service.dart';
import 'package:bolshek_pro/app/pages/settings/settings_widget/city_widgets/city_selection_bottom_sheet.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_widget/warehouse_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final CityService _cityService = CityService();
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadSelectedCity();
  }

  // Загрузка сохраненного города
  Future<void> _loadSelectedCity() async {
    final city = await _cityService.getSavedCity();
    setState(() {
      _selectedCity = city;
    });
  }

  void _showCitySelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CitySelectionBottomSheet(
          selectedCity: _selectedCity,
          onCitySelected: (city) {
            setState(() {
              _selectedCity = city;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<GlobalProvider>(context);
    final user = authProvider.authResponse?.user;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      user?.firstName ?? '',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      user?.lastName ?? '',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.location_on,
                    color: ThemeColors.orange,
                    size: 32,
                  ),
                  onPressed: () {
                    _showCitySelection;
                  }, // Здесь может быть логика для изменения города
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text(
              'PP1',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Тексты будут выровнены по левому краю
              children: [
                Text(_selectedCity ?? 'Город не выбран'),
                const SizedBox(height: 4), // Отступ между текстами
                const Text(
                  'Активный', // Добавляем второй текст
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.green), // Стиль для второго текста
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Переход на страницу "Склад"
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WarehousePage(selectedCity: _selectedCity ?? 'Не выбран'),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              'PP2',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Тексты будут выровнены по левому краю
              children: [
                Text(_selectedCity ?? 'Город не выбран'),
                const SizedBox(height: 4), // Отступ между текстами
                const Text(
                  'Активный', // Добавляем второй текст
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.green), // Стиль для второго текста
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Переход на страницу "Склад"
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WarehousePage(selectedCity: _selectedCity ?? 'Не выбран'),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              'PP3',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Тексты будут выровнены по левому краю
              children: [
                Text(_selectedCity ?? 'Город не выбран'),
                const SizedBox(height: 4), // Отступ между текстами
                const Text(
                  'Не активный', // Добавляем второй текст
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.red), // Стиль для второго текста
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Переход на страницу "Склад"
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WarehousePage(selectedCity: _selectedCity ?? 'Не выбран'),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
