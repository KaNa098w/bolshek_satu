import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bolshek_pro/app/pages/return/return_page.dart';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/app/pages/home/add_name_product_page.dart';
import 'package:bolshek_pro/core/service/orders_service.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/service/returnings_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/home_widgets/empty_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = ProductService();
  final OrdersService _ordersService = OrdersService();
  final ReturningsService _returningsService = ReturningsService();

  int _activeTotal = 0;
  int _inactiveTotal = 0;
  int _watingTotal = 0;
  int _newOrdersTotal = 0;
  int _processingOrderTotal = 0;
  int _deliveredOrdersTotal = 0;
  int _cancelledOrdersTotal = 0;
  int _newReturnsTotal = 0;
  int _completedReturnsTotal = 0;
  int _currentIndex = 0;

  /// Список товаров со статусами (результат fetchProductsStatuses)
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _openWhatsAppChat() async {
    const phoneNumber = '77001012200'; // Пример для Казахстана
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).whatsapp_launch_error),
        ),
      );
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Загружаем данные по заказам и товарам параллельно
      final results = await Future.wait([
        _ordersService.fetchOrdersTotals(context: context),
        _productService.fetchProductTotals(context: context),
        _returningsService.fetchReturnTotals(context: context)
      ]);

      final ordersData = results[0] as Map<String, int>;
      final productsData = results[1] as Map<String, int>;
      final returnsData = results[2] as Map<String, int>;

      setState(() {
        _newOrdersTotal = ordersData['newOrders']!;
        _processingOrderTotal = ordersData['processingOrders']!;
        _deliveredOrdersTotal = ordersData['deliveredOrders']!;
        _cancelledOrdersTotal = ordersData['cancelledOrders']!;

        _activeTotal = productsData['active']!;
        _inactiveTotal = productsData['inactive']!;
        _watingTotal = productsData['awaiting']!;

        _newReturnsTotal = returnsData['newReturnsTotal']!;
        _completedReturnsTotal = returnsData['completedReturnsTotal']!;

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Ошибка загрузки данных: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.grey,
              )
            : _activeTotal > 0
                ? _buildStatusesTable(localizations)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const EmptyState(),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: localizations.add_first_product,
                        onPressed: () {
                          final globalProvider = Provider.of<GlobalProvider>(
                              context,
                              listen: false);
                          globalProvider
                              .clearProductData(); // Очистка данных в провайдере
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductNameInputPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 13),
                      CustomButton(
                        text: localizations.open_chat_with_bolshek,
                        onPressed: _openWhatsAppChat,
                        isPrimary: false,
                      ),
                    ],
                  ),
      ),
    );
  }

  /// Метод, создающий таблицу со списком товаров/статусов
  Widget _buildStatusesTable(S localizations) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.orders_header,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildStatusRow(
              label: localizations.new_orders,
              value: _newOrdersTotal,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainControllerNavigator(
                      initialIndex: 1,
                      ordersTabIndex: 0,
                    ),
                  ),
                );
              },
            ),
            _buildStatusRow(
              label: localizations.processing_orders,
              value: _processingOrderTotal,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainControllerNavigator(
                      initialIndex: 1,
                      ordersTabIndex: 2,
                    ),
                  ),
                );
              },
            ),
            _buildStatusRow(
              label: localizations.delivered_orders,
              value: _deliveredOrdersTotal,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainControllerNavigator(
                      initialIndex: 1,
                      ordersTabIndex: 3,
                    ),
                  ),
                );
              },
            ),
            _buildStatusRow(
              label: localizations.cancelled_orders,
              value: _cancelledOrdersTotal,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainControllerNavigator(
                      initialIndex: 1,
                      ordersTabIndex: 4,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              localizations.goods_header,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildStatusRow(
              label: localizations.active_goods,
              value: _activeTotal,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainControllerNavigator(
                      initialIndex: 2,
                      goodsIndex: 0,
                    ),
                  ),
                );
              },
            ),
            _buildStatusRow(
              label: localizations.inactive_goods,
              value: _inactiveTotal,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainControllerNavigator(
                      initialIndex: 2,
                      goodsIndex: 2,
                    ),
                  ),
                );
              },
            ),
            _buildStatusRow(
              label: localizations.waiting_goods,
              value: _watingTotal,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainControllerNavigator(
                      initialIndex: 2,
                      goodsIndex: 1,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              localizations.returns_header,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildStatusRow(
              label: localizations.new_returns,
              value: _newReturnsTotal,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text(
                          localizations.new_returns,
                          textAlign: TextAlign.start,
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      body: ReturnPage(), // Показываем страницу возврата
                      bottomNavigationBar:
                          _buildBottomNavigationBar(localizations),
                    ),
                  ),
                );
              },
            ),
            _buildStatusRow(
              label: localizations.completed_returns,
              value: _completedReturnsTotal,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text(
                          localizations.completed_returns,
                          textAlign: TextAlign.start,
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      body: ReturnPage(
                        initialTabIndex: 5,
                      ), // Показываем страницу возврата с нужным индексом
                      bottomNavigationBar:
                          _buildBottomNavigationBar(localizations),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.open_chat_with_bolshek,
              onPressed: _openWhatsAppChat,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(S localizations) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      iconSize: 25,
      selectedLabelStyle: const TextStyle(fontSize: 12, height: 1.2),
      unselectedLabelStyle: const TextStyle(fontSize: 12, height: 1.2),
      onTap: (index) {
        Navigator.pop(context);
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
          label: localizations.bottom_nav_home,
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
          label: localizations.bottom_nav_orders,
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
          label: localizations.bottom_nav_goods,
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
          label: localizations.bottom_nav_settings,
        ),
      ],
    );
  }

  Widget _buildStatusRow({
    required String label,
    required int value,
    required Color color,
    required VoidCallback onTap, // Добавил колбэк для нажатия
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        value.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: 25,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
