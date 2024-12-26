import 'package:flutter/material.dart';

/// Перечисление доступных цветов
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
  transparent,
}

/// Карта соответствия перечисления и цветов
Map<CategoryPropertyTypeColor, Color> categoryColors = {
  CategoryPropertyTypeColor.black: Colors.black,
  CategoryPropertyTypeColor.white: Colors.white,
  CategoryPropertyTypeColor.gray: Colors.grey,
  CategoryPropertyTypeColor.silver: Colors.grey.shade300,
  CategoryPropertyTypeColor.blue: Colors.blue,
  CategoryPropertyTypeColor.pink: Colors.pink,
  CategoryPropertyTypeColor.green: Colors.green,
  CategoryPropertyTypeColor.red: Colors.red,
  CategoryPropertyTypeColor.orange: Colors.orange,
  CategoryPropertyTypeColor.yellow: Colors.yellow,
  CategoryPropertyTypeColor.purple: Colors.purple,
  CategoryPropertyTypeColor.brown: Colors.brown,
  CategoryPropertyTypeColor.beige: const Color(0xFFF5F5DC),
  CategoryPropertyTypeColor.rgb: Colors.black, // Можно заменить на кастомный
  CategoryPropertyTypeColor.transparent: Colors.transparent,
};

/// Карта соответствия перечисления и названий цветов
Map<CategoryPropertyTypeColor, String> categoryColorNames = {
  CategoryPropertyTypeColor.black: 'Чёрный',
  CategoryPropertyTypeColor.white: 'Белый',
  CategoryPropertyTypeColor.gray: 'Серый',
  CategoryPropertyTypeColor.silver: 'Серебристый',
  CategoryPropertyTypeColor.blue: 'Синий',
  CategoryPropertyTypeColor.pink: 'Розовый',
  CategoryPropertyTypeColor.green: 'Зелёный',
  CategoryPropertyTypeColor.red: 'Красный',
  CategoryPropertyTypeColor.orange: 'Оранжевый',
  CategoryPropertyTypeColor.yellow: 'Жёлтый',
  CategoryPropertyTypeColor.purple: 'Фиолетовый',
  CategoryPropertyTypeColor.brown: 'Коричневый',
  CategoryPropertyTypeColor.beige: 'Бежевый',
  CategoryPropertyTypeColor.rgb: 'RGB-подсветка',
  CategoryPropertyTypeColor.transparent: 'Прозрачный',
};
