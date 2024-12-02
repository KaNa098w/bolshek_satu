import 'package:bolshek_pro/app/widgets/widget_from_bolshek/theme_text_style.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class CommonTextButton extends StatelessWidget {
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  final double? size;
  final String buttonText;
  final Function() onTap;
  const CommonTextButton({
    super.key,
    this.bgColor,
    this.textColor,
    this.borderColor,
    this.size,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.white),
          borderRadius: BorderRadius.circular(12),
          color: bgColor ?? ThemeColors.orange,
        ),
        child: Text(
          buttonText,
          style: ThemeTextInterRegular.size11.copyWith(
            fontSize: size ?? 17,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
