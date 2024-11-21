import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class CitySelectionBottomSheet extends StatelessWidget {
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

  CitySelectionBottomSheet({
    Key? key,
    required this.selectedCity,
    required this.onCitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена',
                        style: TextStyle(color: Colors.red)),
                  ),
                  const Text('Выберите город',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return ListTile(
                      title: Text(city),
                      trailing: selectedCity == city
                          ? const Icon(Icons.radio_button_checked,
                              color: ThemeColors.orange)
                          : const Icon(Icons.radio_button_unchecked),
                      onTap: () {
                        onCitySelected(city);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Выбрать город'),
              ),
            ],
          ),
        );
      },
    );
  }
}
