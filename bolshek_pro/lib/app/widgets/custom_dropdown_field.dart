import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showIcon;
  final Function(String)?
      onValueChanged; // Новый параметр для изменения значения
  final int maxLines; // Параметр для ограничения строк

  const CustomDropdownField({
    Key? key,
    required this.title,
    required this.value,
    required this.onTap,
    this.trailing,
    this.showIcon = true,
    this.onValueChanged,
    this.maxLines = 1, // Значение по умолчанию — одна строка
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (onValueChanged != null) {
          final newValue = await _showEditDialog(context, title, value);
          if (newValue != null) {
            onValueChanged!(newValue);
          }
        } else {
          onTap();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeColors.grey1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: maxLines, // Применение ограничения строк
                    overflow: TextOverflow
                        .ellipsis, // Добавляем троеточие при переполнении
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                (showIcon
                    ? const Icon(Icons.keyboard_arrow_down)
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }

  /// Показывает диалог для редактирования значения
  Future<String?> _showEditDialog(
      BuildContext context, String title, String initialValue) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Изменить $title',
            style: const TextStyle(fontSize: 14),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Введите новое значение',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text(
                'Сохранить',
                style: TextStyle(color: ThemeColors.orange),
              ),
            ),
          ],
        );
      },
    );
  }
}
