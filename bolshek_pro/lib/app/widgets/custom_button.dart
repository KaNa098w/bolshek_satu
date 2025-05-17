import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool enableTextInput; // Новый параметр для включения ввода текста
  final List<String>? predefinedTexts; // Опциональный список готовых текстов
  final bool isLoading; // Новый параметр для состояния загрузки

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.enableTextInput = false, // По умолчанию текстовый ввод выключен
    this.predefinedTexts, // Можно передавать список готовых текстов
    this.isLoading = false, // По умолчанию загрузка выключена
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
      onPressed: isLoading ? null : () => _showInputDialog(context),
      style: ElevatedButton.styleFrom(
        elevation: 0, // Убираем тень
        shadowColor: Colors.transparent, // Цвет тени делаем прозрачным
        foregroundColor: isPrimary ? Colors.white : Colors.black54,
        backgroundColor: isLoading
            ? Colors.grey
            : (isPrimary ? ThemeColors.orange : Colors.grey[200]),
        minimumSize: const Size(355, 53), // Фиксированный размер кнопок
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Немного квадратные углы
        ),
      ),
      child: isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.orange),
              strokeWidth: 3.0,
            )
          : (isPrimary
              ? Text(
                  text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                )
              : Text(
                  text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                )),
    );
  }
}
