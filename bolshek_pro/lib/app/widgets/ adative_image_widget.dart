import 'package:flutter/material.dart';

/// Виджет, который выбирает оптимальный размер изображения из списка Sizes.
/// Он принимает список объектов Sizes, желаемую targetDimension и отображает изображение в оптимальном разрешении.
class OptimizedImageWidget extends StatelessWidget {
  final List<Sizes> sizes;
  final double targetDimension;
  final BoxFit fit;

  const OptimizedImageWidget({
    Key? key,
    required this.sizes,
    required this.targetDimension,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Копируем список и сортируем по ширине по возрастанию
    List<Sizes> sortedSizes = List.from(sizes);
    sortedSizes.sort((a, b) => (a.width ?? 0).compareTo(b.width ?? 0));

    // Ищем первый размер, у которого ширина больше или равна targetDimension
    Sizes? selectedSize;
    for (final size in sortedSizes) {
      if ((size.width ?? 0) >= targetDimension) {
        selectedSize = size;
        break;
      }
    }

    // Если ни один подходящий размер не найден, выбираем самый большой вариант
    selectedSize ??= sortedSizes.last;

    return Image.network(
      selectedSize.url ?? '',
      width: targetDimension,
      height: targetDimension,
      fit: fit,
    );
  }
}

/// Класс Sizes (ваша модель)
class Sizes {
  int? width;
  int? height;
  String? url;

  Sizes({this.width, this.height, this.url});

  Sizes.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['width'] = width;
    data['height'] = height;
    data['url'] = url;
    return data;
  }
}
