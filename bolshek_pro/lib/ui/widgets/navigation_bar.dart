import 'package:bolshek_pro/ui/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Заказы',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Товары',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Настройки',
        ),
      ],
      onTap: (index) {
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        }
        // Добавь логику для других экранов по необходимости
      },
    );
  }
}
