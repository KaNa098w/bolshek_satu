import 'package:bolshek_pro/app/widgets/phone_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class OTPInputField extends StatefulWidget {
  final String title;
  final ValueChanged<String> onChanged;

  const OTPInputField({
    Key? key,
    required this.title,
    required this.onChanged,
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
    _controller = TextEditingController();
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
        // maxLength: 16, // Ограничение на 16 символов (для формата телефона)
        textInputAction: TextInputAction.done,
        cursorColor: ThemeColors.orange,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          PhoneNumberFormatter(), // Форматирование номера телефона
        ],
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          counter: null, // Полностью убираем счётчик символов
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
          // prefixIcon: Icon(
          //   Icons.phone,
          //   color: ThemeColors.grey,
          // ),
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
