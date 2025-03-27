import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class CustomButtonForName extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool enableTextInput; // Новый параметр для включения ввода текста
  final List<String>? predefinedTexts; // Опциональный список готовых текстов

  const CustomButtonForName({
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
              padding: const EdgeInsets.all(8.0),
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
        elevation: 0, // Убираем тень
        shadowColor:
            Colors.transparent, // Дополнительно делаем цвет тени прозрачным
        foregroundColor: isPrimary ? Colors.white : Colors.black54,
        backgroundColor: ThemeColors.orange,
        minimumSize: const Size(100, 40), // Фиксированный размер кнопок
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Немного квадратные углы
        ),
      ),
      child: isPrimary
          ? Text(
              text,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            )
          : Text(
              text,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
    );
  }
}
