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
    MyOrganizationPage(), // Настройки
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
      ),
      body: IndexedStack(
        index: _currentIndex, // Показываем выбранную страницу
        children: _pages, // Страницы, которые мы хотим переключать
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Отключаем ripple-анимацию
          highlightColor: Colors.transparent, // Отключаем подсветку при нажатии
          hoverColor: Colors.transparent, // На всякий случай отключаем hover
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          iconSize: 25,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            height: 1.2,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            height: 1.2,
          ),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 0
                    ? 'assets/svg/home_icon_on.svg'
                    : 'assets/svg/home_icon2.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 0 ? ThemeColors.orange : Colors.grey,
              ),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 1
                    ? 'assets/svg/orders_off.svg'
                    : 'assets/svg/orders_on.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 1 ? ThemeColors.orange : Colors.grey,
              ),
              label: 'Товары',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 2
                    ? 'assets/svg/settings_off.svg'
                    : 'assets/svg/settings_on.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 2 ? ThemeColors.orange : Colors.grey,
              ),
              label: 'Настройки',
            ),
          ],
        ),
      ),
    );
  }
}
