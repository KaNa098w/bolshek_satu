import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
// Импортируйте или задайте свои стили текста, если нужно
// import 'package:qonys/core/constants/theme_text_style.dart';

class CustomStyledSliverAppBar extends StatelessWidget {
  final String title;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const CustomStyledSliverAppBar({
    Key? key,
    required this.title,
    this.automaticallyImplyLeading = false,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Если кнопка "Назад" показывается, добавляем в правую часть placeholder,
    // чтобы заголовок оставался в центре.
    List<Widget> computedActions = actions != null ? List.from(actions!) : [];
    if (automaticallyImplyLeading) {
      // Стандартная ширина для кнопки "Назад" обычно равна kToolbarHeight (56.0)
      computedActions.add(const SizedBox(width: kToolbarHeight));
    }

    return SliverAppBar(
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: ThemeColors.white,
      // Добавляем flexibleSpace с тем же цветом, чтобы фон оставался неизменным
      flexibleSpace: Container(
        color: ThemeColors.white,
      ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black, // Или ThemeColors.black
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: computedActions,
    );
  }
}
