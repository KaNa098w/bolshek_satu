import 'package:bolshek_pro/app/widgets/phone_number_formatter.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class OTPInputField extends StatefulWidget {
  final String title;
  final ValueChanged<String> onChanged;
  final String initialValue; // Добавляем начальное значение

  const OTPInputField({
    Key? key,
    required this.title,
    required this.onChanged,
    this.initialValue = "", // Устанавливаем значение по умолчанию
  }) : super(key: key);

  @override
  _OTPInputFieldState createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Если initialValue пустое, задаем начальное значение как "+7 "
    final initialText =
        widget.initialValue.isEmpty ? "+7 " : widget.initialValue;
    _controller = TextEditingController(text: initialText);
    // Устанавливаем курсор в конец текста, чтобы он стоял после "+7 "
    _controller.selection =
        TextSelection.collapsed(offset: _controller.text.length);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.phone,
        cursorColor: ThemeColors.orange,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[+\d]')),
          PhoneNumberFormatter(), // Форматирование номера телефона
        ],
        onChanged: (value) {
          widget.onChanged(value);
        },
        decoration: InputDecoration(
          labelText: widget.title,
          contentPadding: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
          hintText: "+7 ",
          labelStyle: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).enterPhone;
          }
          if (value.length != 16) {
            return S.of(context).enterValidPhone;
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
