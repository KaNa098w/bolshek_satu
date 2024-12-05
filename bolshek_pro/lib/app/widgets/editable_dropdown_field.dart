import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class EditableDropdownField extends StatefulWidget {
  final String title;
  final String value;
  final ValueChanged<String> onChanged;
  final String hint;
  final int maxLines;

  const EditableDropdownField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.hint = 'Введите значение',
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _EditableDropdownFieldState createState() => _EditableDropdownFieldState();
}

class _EditableDropdownFieldState extends State<EditableDropdownField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant EditableDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fieldHeight =
        widget.maxLines * 24.0 + 8.0; // Высота для maxLines
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 12,
              color: ThemeColors.grey5,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: fieldHeight,
            child: _isEditing
                ? TextField(
                    controller: _controller,
                    autofocus: true,
                    maxLines: widget.maxLines,
                    textInputAction:
                        TextInputAction.done, // "Готово" на клавиатуре
                    onSubmitted: (value) =>
                        _confirmEdit(), // Завершаем редактирование
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = true; // Переходим в режим редактирования
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: fieldHeight,
                      child: Text(
                        widget.value.isEmpty ? widget.hint : widget.value,
                        maxLines: widget.maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              widget.value.isEmpty ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmEdit() {
    setState(() {
      _isEditing = false; // Выходим из режима редактирования
    });
    widget.onChanged(_controller.text); // Передаём значение
    FocusScope.of(context).unfocus(); // Закрываем клавиатуру
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
