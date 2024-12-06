import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingWidget({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 10.0, // Значение по умолчанию для радиуса
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ThemeColors.grey2,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
