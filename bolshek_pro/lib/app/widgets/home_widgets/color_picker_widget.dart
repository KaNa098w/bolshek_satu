import 'package:bolshek_pro/app/widgets/home_widgets/category_colors_widget.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final String propertyId;
  final ValueChanged<String> onColorSelected;
  final String? initialColor; // Добавлен параметр для начального значения

  const ColorPicker({
    Key? key,
    required this.propertyId,
    required this.onColorSelected,
    this.initialColor,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late String _selectedColorName;

  @override
  void initState() {
    super.initState();
    // Если задано начальное значение, используем его, иначе значение по умолчанию
    _selectedColorName = widget.initialColor ?? 'Выбрать цвет';
  }

  void _showColorOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredColors = categoryColors.keys
                .where((color) => (categoryColorNames[color] ?? '')
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    const Text(
                      'Выберите цвет',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredColors.length,
                        itemBuilder: (context, index) {
                          final colorKey = filteredColors[index];
                          final colorName =
                              categoryColorNames[colorKey] ?? 'Неизвестно';
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: categoryColors[colorKey],
                            ),
                            title: Text(
                              colorName,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedColorName = colorName;
                              });
                              widget.onColorSelected(colorName);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showColorOptions,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Цвет',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedColorName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: ThemeColors.grey5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
