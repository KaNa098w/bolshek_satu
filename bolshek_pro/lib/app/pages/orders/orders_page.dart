import 'package:bolshek_pro/app/pages/product/product_widget/discontinued.dart';
import 'package:bolshek_pro/app/pages/product/product_widget/on_sale.dart';
import 'package:bolshek_pro/app/pages/product/product_widget/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 6, vsync: this); // Изменил на 6 вкладок
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Используем PreferredSize для кастомного отображения TabBar без AppBar
          PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              color: Colors.white,
              child: TabBar(
                labelColor: ThemeColors.orange,
                indicatorColor: ThemeColors.orange,
                controller: _tabController,
                indicatorWeight: 4.0, // Устанавливаем толщину индикатора
                indicatorSize:
                    TabBarIndicatorSize.tab, // Индикатор на всю ширину
                isScrollable: true, // Включаем горизонтальную прокрутку
                tabs: const [
                  Tab(text: 'Новые'),
                  Tab(text: 'На подписании'),
                  Tab(text: 'Самовывоз'),
                  Tab(text: 'В пути'),
                  Tab(text: 'Доставлены'),
                  Tab(text: 'Отмененные'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ProductListPage(status: 'active')
                // Добавьте содержимое для каждой вкладки по необходимости
              ],
            ),
          ),
        ],
      ),
    );
  }
}
