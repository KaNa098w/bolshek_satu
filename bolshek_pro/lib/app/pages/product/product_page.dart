import 'package:bolshek_pro/app/pages/product/product_widget/discontinued.dart';
import 'package:bolshek_pro/app/pages/product/product_widget/inactive.dart';
import 'package:bolshek_pro/app/pages/product/product_widget/on_sale.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class GoodsPage extends StatefulWidget {
  const GoodsPage({Key? key}) : super(key: key);

  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
                tabs: const [
                  Tab(text: 'В продаже'),
                  Tab(text: 'Ожидает'),
                  Tab(text: 'Неактивные'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OnSale(),
                Discontinued(), //
                Inactive(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
