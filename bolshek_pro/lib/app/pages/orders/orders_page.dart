import 'package:bolshek_pro/app/pages/orders/orders_list_page.dart';
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
    _tabController = TabController(length: 6, vsync: this);
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
          PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              color: Colors.white,
              child: TabBar(
                labelColor: ThemeColors.orange,
                indicatorColor: ThemeColors.orange,
                controller: _tabController,
                indicatorWeight: 4.0,
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Новые'),
                  // Tab(text: 'Ожидание оплаты'),
                  Tab(text: 'Оплаченный'),
                  Tab(text: 'В обработке'),
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
                OrderListPage(
                    statusFilter:
                        'awaiting_confirmation&status=awaiting_payment&status=new'),
                // OrderListPage(statusFilter: 'awaiting_payment'),
                OrderListPage(statusFilter: 'paid'),
                OrderListPage(statusFilter: 'processing'),
                OrderListPage(
                    statusFilter: 'delivered&status=partially_delivired'),
                OrderListPage(
                    statusFilter: 'cancelled&status=partially_cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
