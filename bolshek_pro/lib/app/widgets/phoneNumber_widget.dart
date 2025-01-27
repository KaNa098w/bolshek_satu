import 'package:bolshek_pro/app/widgets/phone_number_formatter.dart';
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
    _controller = TextEditingController(
        text: widget.initialValue); // Устанавливаем начальное значение
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
          FilteringTextInputFormatter.digitsOnly,
          PhoneNumberFormatter(), // Форматирование номера телефона
        ],
        onChanged: (value) {
          widget.onChanged(value);
        },
        decoration: InputDecoration(
          labelText: widget.title,
          contentPadding: EdgeInsets.only(left: 12, top: 10, bottom: 10),
          hintText: "+7 ",
          labelStyle: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
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
            return "Введите номер телефона";
          }
          if (value.length != 16) {
            return "Введите корректный номер телефона";
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
