import 'package:bolshek_pro/ui/pages/settings/settings_widget/city_widgets/city_item.dart';
import 'package:flutter/material.dart';

class CityList extends StatelessWidget {
  final List<String> cities = [
    'Шымкент',
    'Алматы',
    'Астана',
    'Караганда',
    'Актау',
    'Актобе',
    'Кызылорда'
  ];

  final String? selectedCity;
  final Function(String) onCitySelected;

  CityList({
    Key? key,
    required this.selectedCity,
    required this.onCitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return CityItem(
          city: city,
          isSelected: city == selectedCity,
          onTap: () => onCitySelected(city),
        );
      },
    );
  }
}
