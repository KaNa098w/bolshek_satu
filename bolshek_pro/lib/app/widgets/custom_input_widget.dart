import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String title;
  final String value;
  final ValueChanged<String> onChanged;
  final String hint;

  const CustomInputField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.hint = 'Введите значение',
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late String initialText;

  @override
  void initState() {
    super.initState();
    initialText = widget.value;
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();

    // Обработка событий фокуса
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Очищаем текст при фокусе
        if (_controller.text == initialText) {
          _controller.clear();
        }
      } else {
        // Если ничего не введено, восстанавливаем текст
        if (_controller.text.isEmpty) {
          _controller.text = initialText;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
