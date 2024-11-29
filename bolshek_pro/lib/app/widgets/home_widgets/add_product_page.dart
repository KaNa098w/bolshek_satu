import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/add_product_widgets/characteristics_tab.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/add_product_widgets/info_tab.dart';
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

    // Слушатель для блокировки свайпа
    _tabController.addListener(() {
      if (_tabController.index == 1 && _tabController.previousIndex == 0) {
        if (!_validateInfoTab()) {
          _tabController.index = 0; // Возврат на вкладку "Инфо"
          _showError(
              'Пожалуйста, заполните обязательные поля на вкладке "Инфо"');
        }
      }
    });

    // Устанавливаем имя продукта в GlobalProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GlobalProvider>().setName(widget.productName);
    });
  }

  bool _validateInfoTab() {
    final globalProvider = context.read<GlobalProvider>();
    if (globalProvider.selectedCategoryId == null ||
        globalProvider.brandId == null ||
        globalProvider.price == null ||
        globalProvider.price == 0 ||
        (globalProvider.images.isEmpty)) {
      return false;
    }
    return true;
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
            tabController: _tabController,
            onCategorySelected: (categoryId) {
              context.read<GlobalProvider>().setCategoryId(categoryId);
            },
            validateInfoTab: _validateInfoTab,
            showError: _showError,
          ),
          const CharacteristicsTab(), // Используется без параметров
        ],
      ),
    );
  }
}
