import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing; // Заменяем иконку универсальным виджетом
  final bool showIcon; // Сохраняем поддержку showIcon для удобства

  const CustomDropdownField({
    Key? key,
    required this.title,
    required this.value,
    required this.onTap,
    this.trailing,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            trailing ??
                (showIcon
                    ? const Icon(
                        Icons.arrow_drop_down) // Показываем стандартную иконку
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
