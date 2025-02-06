import 'package:extended_tabs/extended_tabs.dart';
import 'package:bolshek_pro/app/pages/orders/orders_list_page.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class OrdersPage extends StatefulWidget {
  final int initialTabIndex;

  const OrdersPage({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 5, vsync: this, initialIndex: widget.initialTabIndex);
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
              child: ExtendedTabBar(
                labelColor: ThemeColors.orange,

                unselectedLabelColor: ThemeColors.grey, // менее заметный цвет
                labelStyle: const TextStyle(
                  fontSize: 15, // размер шрифта для выбранной вкладки
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14, // меньший размер шрифта для неактивных вкладок
                ),
                controller: _tabController,
                indicatorColor: ThemeColors.orange,
                indicatorWeight: 4.0,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Новые'),
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
                OrderListPage(statusFilter: Constants.newOrders),
                OrderListPage(statusFilter: Constants.paidOrders),
                OrderListPage(statusFilter: Constants.processingOrders),
                OrderListPage(statusFilter: Constants.deliveredOrders),
                OrderListPage(statusFilter: Constants.cancelledOrders),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
