import 'package:flutter/material.dart';

class AddBrandDialog extends StatelessWidget {
  final Function(String) onBrandAdded;

  const AddBrandDialog({
    Key? key,
    required this.onBrandAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String newBrandName = '';
    return AlertDialog(
      title: const Text(
        'Добавить бренд',
        style: TextStyle(fontSize: 18),
      ),
      content: TextField(
        decoration: const InputDecoration(hintText: 'Введите название бренда'),
        onChanged: (value) {
          newBrandName = value;
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (newBrandName.isNotEmpty) {
              onBrandAdded(newBrandName);
              Navigator.pop(context);
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
