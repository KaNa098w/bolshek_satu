import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityInputField extends StatefulWidget {
  final int initialValue;
  final void Function(int)? onChanged;

  const QuantityInputField({
    Key? key,
    this.initialValue = 1,
    this.onChanged,
  }) : super(key: key);

  @override
  State<QuantityInputField> createState() => _QuantityInputFieldState();
}

class _QuantityInputFieldState extends State<QuantityInputField> {
  late int _count;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
    _controller = TextEditingController(text: _count.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _count++;
      _controller.text = _count.toString();
    });
    widget.onChanged?.call(_count);
  }

  void _decrement() {
    if (_count > 1) {
      setState(() {
        _count--;
        _controller.text = _count.toString();
      });
      widget.onChanged?.call(_count);
    }
  }

  void _onTextChanged(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed > 0) {
      setState(() {
        _count = parsed;
      });
      widget.onChanged?.call(_count);
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _decrement,
            icon:  Icon(Icons.remove, size: iconSize,),
            splashRadius: 20,
          ),
          SizedBox(
            width: 41,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: _onTextChanged,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: _increment,
            icon:  Icon(Icons.add, size: iconSize,),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
