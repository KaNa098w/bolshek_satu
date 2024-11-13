import 'package:bolshek_pro/ui/pages/settings/settings_widget/city_widgets/city_selection_bottom_sheet.dart';
import 'package:bolshek_pro/utils/theme.dart';
import 'package:flutter/material.dart';

class WarehousePage extends StatefulWidget {
  final String selectedCity;
  const WarehousePage({Key? key, required this.selectedCity}) : super(key: key);

  @override
  _WarehousePageState createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  String? _selectedCity;
  bool _isPickupEnabled = false; // Переключатель самовывоза
  bool _isKaspiDeliveryEnabled = true; // Переключатель Kaspi доставки

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedCity;
  }

  // Открытие BottomSheet с выбором города
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Склад PP1'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Адрес',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              title: 'Город',
              value: _selectedCity ?? 'Шымкент',
              onTap: _showCitySelection, // Открытие выбора города
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              title: 'Улица и номер здания',
              value: 'Укажите улицу и номер здания',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              title: 'Офис/ бутик',
              value: 'Укажите тип здания',
              onTap: () {},
            ),
            const SizedBox(height: 32),
            const Text(
              'График работы',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              title: 'График работы',
              value: 'Пн-Вс, 09:00–21:00',
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Добавляем секцию "Стоимость доставки"
            const Text(
              'Стоимость доставки',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Заказ от 5 000 ₸ всегда доставляется бесплатно.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Подробнее',
              style: TextStyle(color: Colors.orange),
            ),
            const SizedBox(height: 16),
            _buildDeliveryCostField('Заказ до 5000 ₸*', '995 ₸',
                'Максимальная стоимость доставки — 995 ₸'),
            const SizedBox(height: 32),

            // Добавляем секцию "Самовывоз"
            const Text(
              'Самовывоз',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              activeColor: ThemeColors.orange,
              title: const Text(
                'Клиенты смогут самостоятельно забрать заказ с этого склада',
                style: TextStyle(fontSize: 14),
              ),
              value: _isPickupEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isPickupEnabled = value;
                });
              },
            ),
            const SizedBox(height: 32),

            // Добавляем секцию "Kaspi Доставка по Казахстану"
            const Text(
              'Доставка по Казахстану',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              activeColor: ThemeColors.orange,
              title: const Text(
                'Доставка товаров по всему Казахстану',
                style: TextStyle(fontSize: 14),
              ),
              value: _isKaspiDeliveryEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isKaspiDeliveryEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              title: 'Дни передачи заказов в пункт приема',
              value: 'Пн-Вс',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Адреса пунктов приема',
              style: TextStyle(color: Colors.orange),
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              title: 'При получении заказа до',
              value: '15:00',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Заказы после 15:00 нужно передать в пункт приема на следующий день',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Кнопка "Выключить склад"
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.grey2,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Выключить склад',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Поле для отображения стоимости доставки
  Widget _buildDeliveryCostField(String title, String value, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text(subTitle),
          trailing: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  // Поле для выпадающего выбора (аналог dropdown)
  Widget _buildDropdownField({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
