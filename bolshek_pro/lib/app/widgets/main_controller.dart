import 'package:bolshek_pro/app/pages/home/home_page.dart';
import 'package:bolshek_pro/app/pages/notification/notification_screen.dart';
import 'package:bolshek_pro/app/pages/orders/orders_page.dart';
import 'package:bolshek_pro/app/pages/product/product_page.dart';
import 'package:bolshek_pro/app/pages/settings/settings_page.dart';
import 'package:bolshek_pro/core/models/notifications_response.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/core/service/notification_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Не забудьте создать глобальный observer в main.dart:
// final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MainControllerNavigator extends StatefulWidget {
  final int initialIndex;
  final int? ordersTabIndex;
  final int? goodsIndex;

  const MainControllerNavigator(
      {Key? key, this.initialIndex = 0, this.ordersTabIndex, this.goodsIndex})
      : super(key: key);

  @override
  _MainControllerNavigatorState createState() =>
      _MainControllerNavigatorState();
}

class _MainControllerNavigatorState extends State<MainControllerNavigator>
    with RouteAware {
  int _currentIndex = 0;
  int? _ordersTabIndex;
  String? organizationName;
  int? _goodsIndex;
  late Future<NotificationsResponse> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _loadOrganizationName();
    _fetchNotifications();
    _currentIndex = widget.initialIndex;
    _ordersTabIndex = widget.ordersTabIndex;
    _goodsIndex = widget.goodsIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as int?;
      if (args != null && args < _pages.length) {
        setState(() {
          _currentIndex = args;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Этот метод вызывается, когда возвращаемся на этот маршрут
  @override
  void didPopNext() {
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _notificationsFuture = NotificationService()
          .getNotifications(context: context, modelId: '1');
    });
  }

  // Список страниц для переключения
  List<Widget> get _pages => [
        const HomePage(),
        OrdersPage(initialTabIndex: _ordersTabIndex ?? 0),
        GoodsPage(initialTabIndex: _goodsIndex ?? 0),
        MyOrganizationPage(),
      ];

  Future<void> _loadOrganizationName() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedName = prefs.getString('organization_name');

    if (cachedName != null) {
      setState(() {
        organizationName = cachedName;
      });
    } else {
      _fetchAndCacheOrganizationName();
    }
  }

  Future<void> _fetchAndCacheOrganizationName() async {
    try {
      final authSession = await AuthService().fetchAuthSession(context);
      final fetchedName =
          authSession.user?.organization?.name ?? 'Без названия';

      setState(() {
        organizationName = fetchedName;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('organization_name', fetchedName);
    } catch (e) {
      print('Error fetching organization name: $e');
      setState(() {
        organizationName = '';
      });
    }
  }

  void _notificationScreen() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const NotificationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          organizationName ?? '',
          style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: ThemeColors.blackWithPath),
        ),
        actions: [
          FutureBuilder<NotificationsResponse>(
            future: _notificationsFuture,
            builder: (context, snapshot) {
              int unreadCount = 0;
              if (snapshot.hasData) {
                unreadCount = snapshot.data!.items
                    .where((item) => item.readedAt == null)
                    .length;
              }
              return IconButton(
                onPressed: () {
                  _notificationScreen();
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: Colors.grey.shade700,
                      size: 28,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: -3,
                        top: -3,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
        centerTitle: false,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          iconSize: 25,
          selectedLabelStyle: const TextStyle(fontSize: 12, height: 1.2),
          unselectedLabelStyle: const TextStyle(fontSize: 12, height: 1.2),
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
              label: 'Заказы',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 2
                    ? 'assets/svg/goods_off.svg'
                    : 'assets/svg/goods_on.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 2 ? ThemeColors.orange : Colors.grey,
              ),
              label: 'Товары',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == 3
                    ? 'assets/svg/settings_off.svg'
                    : 'assets/svg/settings_on.svg',
                width: 24,
                height: 24,
                color: _currentIndex == 3 ? ThemeColors.orange : Colors.grey,
              ),
              label: 'Настройки',
            ),
          ],
        ),
      ),
    );
  }
}
