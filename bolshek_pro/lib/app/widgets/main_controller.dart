import 'package:bolshek_pro/app/pages/home/home_page.dart';
import 'package:bolshek_pro/app/pages/my_organization/my_organiztion_page.dart';
import 'package:bolshek_pro/app/pages/orders/orders_page.dart';
import 'package:bolshek_pro/app/pages/product/product_page.dart';
import 'package:bolshek_pro/app/pages/settings/settings_page.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainControllerNavigator extends StatefulWidget {
  const MainControllerNavigator({Key? key}) : super(key: key);

  @override
  _MainControllerNavigatorState createState() =>
      _MainControllerNavigatorState();
}

class _MainControllerNavigatorState extends State<MainControllerNavigator> {
  int _currentIndex = 0;
  String? organizationName;

  @override
  void initState() {
    super.initState();
    _fetchOrganizationName();

    // Установка стартового индекса из переданных аргументов
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as int?;
      if (args != null && args < _pages.length) {
        setState(() {
          _currentIndex = args;
        });
      }
    });
  }

  // Список страниц для переключения
  final List<Widget> _pages = [
    const HomePage(),
    // const OrdersPage(),
    const GoodsPage(),
    const SettingsPage(), // Настройки
  ];
  Future<void> _fetchOrganizationName() async {
    try {
      final authSession = await AuthService().fetchAuthSession(context);
      setState(() {
        organizationName =
            authSession.user?.organization?.name ?? 'Без названия';
      });
    } catch (e) {
      print('Error fetching organization name: $e');
      setState(() {
        organizationName = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: ThemeColors.orange,
        title: Text(
          organizationName ?? '',
          style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: ThemeColors.blackWithPath),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.business_rounded, // Иконка профиля
              size: 30,
              color: ThemeColors.grey5, // Цвет иконки
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyOrganizationPage(
                      // organizationName: "Tech Corp", // Пример данных
                      // organizationType: "Головная",
                      // isActive: true,
                      // creationDate: "01.12.2023",
                      // city: "Алматы",
                      // address: "ул. Абая, д. 123, офис 456",
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex, // Показываем выбранную страницу
        children: _pages, // Страницы, которые мы хотим переключать
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex, // Выбранный индекс
        iconSize: 25, // Уменьшаем размер иконок
        selectedLabelStyle: const TextStyle(
          fontSize: 12, // Уменьшаем шрифт для выбранных элементов
          height: 1.2, // Делаем текст ближе к иконке
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12, // Уменьшаем шрифт для невыбранных элементов
          height: 1.2, // Делаем текст ближе к иконке
        ),
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Изменение текущего индекса при нажатии
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_home_outlined),
            label: 'Главная',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.list_alt),
          //   label: 'Заказы',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Товары',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
