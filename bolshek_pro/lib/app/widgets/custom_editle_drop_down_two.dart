import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomEditableDropdownFieldTwo extends StatefulWidget {
  final String title;
  final String value;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode; // новый параметр
  final bool autofocus; // новый параметр

  const CustomEditableDropdownFieldTwo({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  @override
  _CustomEditableDropdownFieldTwoState createState() =>
      _CustomEditableDropdownFieldTwoState();
}

class _CustomEditableDropdownFieldTwoState
    extends State<CustomEditableDropdownFieldTwo> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isExternalFocusNode = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    // Если focusNode передан извне, используем его, иначе создаём новый
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _isExternalFocusNode = true;
    } else {
      _focusNode = FocusNode();
    }

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(covariant CustomEditableDropdownFieldTwo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (!_isExternalFocusNode) {
      _focusNode.dispose();
    }
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
          if (_isFocused)
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          TextField(
            focusNode: _focusNode,
            controller: _controller,
            autofocus: widget.autofocus, // Используем autofocus из параметров
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: widget.title,
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
