import 'package:flutter/material.dart';
import 'package:bolshek_pro/ui/widgets/custom_button.dart';
import 'package:bolshek_pro/ui/widgets/custom_dropdown_field.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Загрузите от 1 до 15 фото',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // Логика загрузки фото
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.camera_alt_outlined,
                  size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),

          // Поле категории
          CustomDropdownField(
            title: 'Категория',
            value: 'Выберите категорию',
            onTap: () {
              // Логика выбора категории
            },
          ),

          const SizedBox(height: 20),

          // Поле цены
          CustomDropdownField(
            title: 'Цена, ₸',
            value: 'Укажите цену',
            onTap: () {
              // Логика выбора цены
            },
          ),

          const Spacer(),
          Center(
            child: CustomButton(
              text: 'Продолжить',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
