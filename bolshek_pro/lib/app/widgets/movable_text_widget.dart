import 'package:flutter/material.dart';

class MovableTextWidget extends StatefulWidget {
  final String text;

  const MovableTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<MovableTextWidget> createState() => _MovableTextWidgetState();
}

class _MovableTextWidgetState extends State<MovableTextWidget> {
  bool _isInAppBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isInAppBar
            ? Text(widget.text)
            : const Text('Заголовок приложения'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isInAppBar = !_isInAppBar;
            });
          },
          child: !_isInAppBar
              ? Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
