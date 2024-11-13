import 'package:bolshek_pro/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/ui/widgets/custom_button.dart';
import 'package:bolshek_pro/ui/widgets/custom_dropdown_field.dart';

class CharacteristicsTab extends StatelessWidget {
  const CharacteristicsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Основные характеристики',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Обязательные поля для заполнения',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Поле "Тип"
            CustomDropdownField(
              title: 'Тип',
              value: 'Выберите тип',
              onTap: () {
                // Логика выбора типа
              },
            ),
            const SizedBox(height: 20),

            // Поле "Температура замерзания"
            CustomDropdownField(
              title: 'Температура замерзания, °C',
              value: 'Введите температуру замерзания',
              onTap: () {
                // Логика ввода температуры
              },
            ),
            const SizedBox(height: 20),

            // Поле "Температура кипения"
            CustomDropdownField(
              title: 'Температура кипения, °C',
              value: 'Введите температуру кипения',
              onTap: () {
                // Логика ввода температуры
              },
            ),
            const SizedBox(height: 20),

            // Поле "Индекс допуска VAG"
            CustomDropdownField(
              title: 'Индекс допуска VAG',
              value: 'Введите индекс',
              onTap: () {
                // Логика ввода индекса
              },
            ),
            const SizedBox(height: 20),

            // Поле "Цвет"
            CustomDropdownField(
              title: 'Цвет',
              value: 'Выберите цвет',
              onTap: () {
                // Логика выбора цвета
              },
            ),
            const SizedBox(height: 20),

            // Поле для веса
            CustomDropdownField(
              title: 'Вес для расчета логистики, кг',
              value: 'Введите вес',
              onTap: () {
                // Логика ввода веса
              },
            ),

            const SizedBox(height: 20),

            // Описание товара
            const Text(
              'Описание товара',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Описание (опционально)',
                hintStyle: TextStyle(color: ThemeColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Что писать в описании?',
              style: TextStyle(color: ThemeColors.orange),
            ),
            const SizedBox(height: 20),

            // Добавить ссылку на YouTube
            const Text(
              'Добавьте ссылку на YouTube',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ссылка (опционально)',
                hintStyle: TextStyle(color: ThemeColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Закрепленные кнопки
            CustomButton(
              text: 'Предпросмотр товар',
              onPressed: () {
                // Логика предпросмотра
              },
              isPrimary: false,
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Добавить товар',
              onPressed: () {
                // Логика добавления товара
              },
            ),
          ],
        ),
      ),
    );
  }
}
