import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            foregroundColor: ThemeColors.grey5,
          ),
          child: const Text("Отмена"),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.orange,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12), // Радиус скругления углов
            ),
          ),
          child: Text(
            "Подтвердить",
            style: TextStyle(color: ThemeColors.white),
          ),
        ),
      ],
    );
  }
}

// Использование диалога
Future<void> showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) async {
  return showDialog(
    context: context,
    builder: (context) => CustomAlertDialog(
      title: title,
      content: content,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );
}
