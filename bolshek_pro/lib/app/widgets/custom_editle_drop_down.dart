import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomEditableDropdownField extends StatefulWidget {
  final String title;
  final String value;
  final ValueChanged<String> onChanged;

  const CustomEditableDropdownField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomEditableDropdownFieldState createState() =>
      _CustomEditableDropdownFieldState();
}

class _CustomEditableDropdownFieldState
    extends State<CustomEditableDropdownField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();

    // Отслеживаем изменение фокуса
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(covariant CustomEditableDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Если поле активно, отображаем заголовок сверху
          if (_isFocused)
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          TextField(
            focusNode: _focusNode, // Привязываем FocusNode к полю ввода
            controller: _controller,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: widget.title, // Подсказка остаётся внутри поля
              hintStyle: TextStyle(
                  color: ThemeColors.grey5, fontWeight: FontWeight.w500),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
            ),
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
