import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/app/pages/product/product_list_page.dart';
import 'package:provider/provider.dart';

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
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final warehousesId = context.read<GlobalProvider>().warehouseId;

      // final permissions = context.read<GlobalProvider>().permissions;
      // final canReadWarehouse = permissions.contains('warehouse_read');
            final manager = context.read<GlobalProvider>().managerValue;


    final localizations = S.of(context);
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
                indicatorColor: ThemeColors.orange,
                controller: _tabController,
                indicatorWeight: 4.0,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: localizations.goods_tab_active),
                  Tab(text: localizations.goods_tab_awaiting),
                  Tab(text: localizations.goods_tab_inactive),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:  [
                ProductListPage(status: manager == Constants.manager  ? 'warehouseId=${warehousesId}&inStock=true' : Constants.activeStatus ),
                ProductListPage(status: manager == Constants.manager ? Constants.activeStatus : Constants.awaitingStatus),
                ProductListPage(status: manager == Constants.manager  ? 'warehouseId=$warehousesId&inStock=false' : Constants.inactiveStatus     ),
                // ProductListPage(status:  Constants.awaitingStatus),

              ],
            ),
          ),
          
          
        ],
      ),
    );
  }
}
