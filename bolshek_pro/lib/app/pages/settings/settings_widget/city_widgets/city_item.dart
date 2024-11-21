import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class CityItem extends StatelessWidget {
  final String city;
  final bool isSelected;
  final VoidCallback onTap;

  const CityItem({
    Key? key,
    required this.city,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(city),
      trailing: isSelected
          ? const Icon(Icons.radio_button_checked, color: ThemeColors.orange)
          : const Icon(Icons.radio_button_unchecked),
      onTap: onTap,
    );
  }
}
