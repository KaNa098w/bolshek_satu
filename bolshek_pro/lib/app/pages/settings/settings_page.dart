import 'package:bolshek_pro/app/pages/auth/auth_page.dart';
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

  Future<void> _logout() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirm) {
      await context.read<GlobalProvider>().logout(); // Теперь метод асинхронный
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }
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
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      user?.lastName ?? '',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: ThemeColors.orange,
                    size: 25,
                  ),
                  onPressed: _logout,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_selectedCity ?? 'Город не выбран'),
                const SizedBox(height: 4),
                const Text(
                  'Активный',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_selectedCity ?? 'Город не выбран'),
                const SizedBox(height: 4),
                const Text(
                  'Активный',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_selectedCity ?? 'Город не выбран'),
                const SizedBox(height: 4),
                const Text(
                  'Не активный',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WarehousePage(selectedCity: _selectedCity ?? 'Не выбран'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
