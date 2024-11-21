import 'package:bolshek_pro/core/service/city_service.dart';
import 'package:flutter/material.dart';
import 'city_list.dart';

class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({Key? key}) : super(key: key);

  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
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

  // Обработка выбора города
  void _onCitySelected(String city) async {
    await _cityService.saveCity(city);
    setState(() {
      _selectedCity = city;
    });
    // Возвращаем выбранный город и закрываем страницу выбора
    Navigator.pop(context, city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Закрытие без выбора города
          },
          child: const Text(
            'Отмена',
            style: TextStyle(color: Colors.red),
          ),
        ),
        title: const Text('Выберите город'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Город',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: CityList(
              selectedCity: _selectedCity,
              onCitySelected: _onCitySelected,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedCity == null
              ? null
              : () {
                  Navigator.of(context)
                      .pop(_selectedCity); // Закрытие с выбором города
                },
          child: const Text('Выбрать город'),
        ),
      ),
    );
  }
}
