import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool enableTextInput; // Новый параметр для включения ввода текста
  final List<String>? predefinedTexts; // Опциональный список готовых текстов

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.enableTextInput = false, // По умолчанию текстовый ввод выключен
    this.predefinedTexts, // Можно передавать список готовых текстов
  }) : super(key: key);

  void _showInputDialog(BuildContext context) {
    if (enableTextInput) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Введите текст',
                    ),
                    onSubmitted: (value) {
                      Navigator.pop(context); // Закрываем модальное окно
                    },
                  ),
                  if (predefinedTexts != null) ...[
                    const SizedBox(height: 16),
                    const Text('Или выберите текст:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: predefinedTexts!
                          .map((text) => ChoiceChip(
                                label: Text(text),
                                selected: false,
                                onSelected: (selected) {
                                  Navigator.pop(context);
                                  onPressed(); // Выполняем действие при выборе текста
                                },
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    } else {
      onPressed(); // Выполняем обычное действие, если ввод текста выключен
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showInputDialog(context),
      style: ElevatedButton.styleFrom(
        foregroundColor: isPrimary ? Colors.white : Colors.black54,
        backgroundColor: isPrimary ? ThemeColors.orange : Colors.grey[300],
        minimumSize: const Size(372, 45), // Фиксированный размер кнопок
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Немного квадратные углы
        ),
      ),
      child: Text(text),
    );
  }
}
