import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/app/pages/product/product_list_page.dart';

class GoodsPage extends StatefulWidget {
  final int initialTabIndex;

  const GoodsPage({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              color: Colors.white,
              child: TabBar(
                labelColor: ThemeColors.orange,
                unselectedLabelColor: Colors.black,
                indicatorColor:
                    ThemeColors.orange, // Линия индикатора белого цвета
                controller: _tabController,
                indicatorWeight: 4.0,
                indicatorSize: TabBarIndicatorSize.tab,
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
              children: const [
                ProductListPage(status: Constants.activeStatus),
                ProductListPage(status: Constants.awaitingStatus),
                ProductListPage(status: Constants.inactiveStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
