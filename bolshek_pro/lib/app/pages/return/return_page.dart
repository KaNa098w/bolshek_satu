import 'package:flutter/material.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:bolshek_pro/app/pages/return/return_list_page.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class ReturnPage extends StatefulWidget {
  final int initialTabIndex;

  const ReturnPage({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  _ReturnPageState createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 6, vsync: this, initialIndex: widget.initialTabIndex);
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
          ExtendedTabBar(
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
              Tab(text: 'В обработке'),
              Tab(text: 'Забрать товар'),
              Tab(text: 'Отмененные'),
              Tab(text: 'Возврат средств'),
              Tab(text: 'Завершенные'),
            ],
          ),
          Expanded(
            child: ExtendedTabBarView(
              controller: _tabController,
              children: const [
                ReturnsListPage(statusFilter: Constants.createdReturn),
                ReturnsListPage(statusFilter: Constants.awaitingConfirmation),
                ReturnsListPage(statusFilter: Constants.awaitingPickReturn),
                ReturnsListPage(statusFilter: Constants.rejectedReturn),
                ReturnsListPage(statusFilter: Constants.awaitingRefund),
                ReturnsListPage(statusFilter: Constants.completedReturn),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
