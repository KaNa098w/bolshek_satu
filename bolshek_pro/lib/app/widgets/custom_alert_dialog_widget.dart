import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title; // Заголовок диалога
  final Widget content; // Кастомное содержимое
  final VoidCallback? onConfirm; // Действие для кнопки "Подтвердить"
  final VoidCallback? onCancel; // Действие для кнопки "Отмена"
  final String? confirmText; // Текст для кнопки "Подтвердить" (опционально)
  final String? cancelText; // Текст для кнопки "Отмена" (опционально)

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    this.onConfirm,
    this.onCancel,
    this.confirmText,
    this.cancelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    // Если текст не передан, используем локализацию
    final String effectiveConfirmText = (confirmText?.isNotEmpty ?? false)
        ? confirmText!
        : localizations.confirm;
    final String effectiveCancelText =
        (cancelText?.isNotEmpty ?? false) ? cancelText! : localizations.cancel;

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
      content: content,
      actions: [
        if (onCancel != null)
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              foregroundColor: ThemeColors.grey5,
            ),
            child: Text(effectiveCancelText),
          ),
        if (onConfirm != null)
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              effectiveConfirmText,
              style: TextStyle(color: ThemeColors.white),
            ),
          ),
      ],
    );
  }
}

// Использование CustomAlertDialog
Future<void> showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required Widget content, // Передача кастомного содержимого
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  String? confirmText,
  String? cancelText,
}) async {
  return showDialog(
    context: context,
    builder: (context) => CustomAlertDialog(
      title: title,
      content: content,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmText: confirmText,
      cancelText: cancelText,
    ),
  );
}
