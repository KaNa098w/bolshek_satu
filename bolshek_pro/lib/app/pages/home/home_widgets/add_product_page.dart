import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/app/pages/home/home_widgets/add_product_widgets/characteristics_tab.dart';
import 'package:bolshek_pro/app/pages/home/home_widgets/add_product_widgets/info_tab.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  final String productName;
  const AddProductPage({Key? key, required this.productName}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Устанавливаем name в AuthProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GlobalProvider>().setName(widget.productName);
    });
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
        title: const Text('Добавить товар'),
        bottom: TabBar(
          labelColor: ThemeColors.orange,
          indicatorColor: ThemeColors.orange,
          controller: _tabController,
          indicatorWeight: 4.0, // Устанавливаем толщину индикатора
          indicatorSize: TabBarIndicatorSize.tab, // Индикатор на всю ширину
          tabs: const [
            Tab(text: 'Инфо'),
            Tab(text: 'Характеристики'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InfoTab(
            productName: widget.productName,
            onPropertiesLoaded: (properties, propertyValues) {
              // Устанавливаем кешированные данные, если нужно
              // Это больше не используется напрямую для CharacteristicsTab
            },
            tabController: _tabController,
            onCategorySelected: (categoryId) {
              // Устанавливаем выбранную категорию в AuthProvider
              context.read<GlobalProvider>().setCategoryId(categoryId);
            },
          ),
          const CharacteristicsTab(), // Используется без параметров
        ],
      ),
    );
  }
}
