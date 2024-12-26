import 'dart:ui';

import 'package:flutter/material.dart';

enum CategoryPropertyTypeColor {
  black,
  white,
  gray,
  silver,
  blue,
  pink,
  green,
  red,
  orange,
  yellow,
  purple,
  brown,
  beige,
  rgb,
  transparent
}

Color _colorFromString(CategoryPropertyTypeColor color) {
  switch (color) {
    case CategoryPropertyTypeColor.black:
      return Colors.black;
    case CategoryPropertyTypeColor.white:
      return Colors.white;
    case CategoryPropertyTypeColor.gray:
      return Colors.grey;
    case CategoryPropertyTypeColor.silver:
      return Colors.grey.shade300;
    case CategoryPropertyTypeColor.blue:
      return Colors.blue;
    case CategoryPropertyTypeColor.pink:
      return Colors.pink;
    case CategoryPropertyTypeColor.green:
      return Colors.green;
    case CategoryPropertyTypeColor.red:
      return Colors.red;
    case CategoryPropertyTypeColor.orange:
      return Colors.orange;
    case CategoryPropertyTypeColor.yellow:
      return Colors.yellow;
    case CategoryPropertyTypeColor.purple:
      return Colors.purple;
    case CategoryPropertyTypeColor.brown:
      return Colors.brown;
    case CategoryPropertyTypeColor.beige:
      return const Color(0xFFF5F5DC);
    case CategoryPropertyTypeColor.rgb:
      return Colors.black; // Например, оставить чёрным
    case CategoryPropertyTypeColor.transparent:
      return Colors.transparent;
  }
}
