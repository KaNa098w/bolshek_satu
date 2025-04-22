import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class UpdatingAnimationPage extends StatefulWidget {
  const UpdatingAnimationPage({Key? key}) : super(key: key);

  @override
  _UpdatingAnimationPageState createState() => _UpdatingAnimationPageState();
}

class _UpdatingAnimationPageState extends State<UpdatingAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Повторяем анимацию бесконечно
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi, // Вращение по кругу
                  child: child,
                );
              },
              child: Icon(
                Icons.settings_outlined, // Иконка, похожая на шестерёнку
                size: 85,
                color: ThemeColors.orange,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).updateProductLoading,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.blackWithPath,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
