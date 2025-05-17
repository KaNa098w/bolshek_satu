import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class EditableDropdownField extends StatefulWidget {
  final String title;
  final String value;
  final ValueChanged<String> onChanged;
  final String hint;
  final int maxLines;
  final bool change; // Если false, редактирование невозможно
  final TextInputType? keyboardType; // в EditableDropdownField

  const EditableDropdownField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.hint = 'Введите значение',
    this.maxLines = 1,
    this.change = true, this.keyboardType, // по умолчанию редактирование разрешено
  }) : super(key: key);

  @override
  _EditableDropdownFieldState createState() => _EditableDropdownFieldState();
}

class _EditableDropdownFieldState extends State<EditableDropdownField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isEditing = false;
  

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isEditing) {
        _confirmEdit(); // Завершение редактирования при потере фокуса
      }
    });
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
    final double fieldHeight = widget.maxLines * 24.0 + 8.0;
    return GestureDetector(
      onTap: () {
        if (widget.change) {
          _startEditing();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                color: ThemeColors.grey,
              ),
            ),
            SizedBox(
              height: fieldHeight,
              child: _isEditing && widget.change
                  ? TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      maxLines: widget.maxLines,
                      keyboardType: widget.keyboardType,
                      textInputAction: TextInputAction.done,
                      
                      onSubmitted: (_) => _confirmEdit(),
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
                  : Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _controller.text.isEmpty
                            ? widget.hint
                            : _controller.text,
                        maxLines: widget.maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          // Если change == false, всегда серый, иначе стандартная логика
                          color: widget.change
                              ? (_controller.text.isEmpty
                                  ? Colors.grey
                                  : Colors.black)
                              : Colors.grey,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    _focusNode.requestFocus();
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  void _confirmEdit() {
    setState(() {
      _isEditing = false;
    });
    final trimmedValue = _controller.text.trim();
    widget.onChanged(trimmedValue);
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
