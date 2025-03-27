import 'package:bolshek_pro/app/pages/home/with_search_name/characteristics_tab_with_name.dart';
import 'package:bolshek_pro/app/pages/home/with_search_name/info_tab_with_name.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:provider/provider.dart';

class AddProductWithName extends StatefulWidget {
  final String productId;
  final String productName;
  const AddProductWithName(
      {Key? key, required this.productId, required this.productName})
      : super(key: key);

  @override
  _AddProductWithNameState createState() => _AddProductWithNameState();
}

class _AddProductWithNameState extends State<AddProductWithName>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Убираем проверку в слушателе – переход происходит без валидации.
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
      appBar: AppBar(
        title: Text(
          widget.productName,
          style: TextStyle(fontSize: 18),
        ),
        bottom: TabBar(
          labelColor: ThemeColors.orange,
          indicatorColor: ThemeColors.orange,
          controller: _tabController,
          indicatorWeight: 4.0,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Инфо'),
            Tab(text: 'Характеристики'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InfoTabWithName(
            productId: widget.productId,
            tabController: _tabController,
            showError: _showError,
          ),
          // Передаём productId в CharacteristicsTabWithName
          CharacteristicsTabWithName(productId: widget.productId),
        ],
      ),
    );
  }
}
