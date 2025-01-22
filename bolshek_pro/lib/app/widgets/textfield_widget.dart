import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class CustomEditableField extends StatefulWidget {
  final String title;
  final String value;
  final ValueChanged<String> onChanged;

  const CustomEditableField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomEditableFieldState createState() => _CustomEditableFieldState();
}

class _CustomEditableFieldState extends State<CustomEditableField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant CustomEditableField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startEditing,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: false,
              textInputAction: TextInputAction.done,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                labelText: widget.title, // Заголовок
                hintText: widget.title, // Подсказка
                labelStyle: TextStyle(
                  fontSize: 16,
                  color: ThemeColors.grey5,
                ),
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startEditing() {
    _focusNode.requestFocus();
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length, // Устанавливаем курсор в конец текста
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
