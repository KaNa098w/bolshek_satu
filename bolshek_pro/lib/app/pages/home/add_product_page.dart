import 'package:bolshek_pro/app/pages/home/characteristics_tab_page.dart';
import 'package:bolshek_pro/app/pages/home/info_tab_page.dart';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/generated/l10n.dart';

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

    // Слушатель для блокировки свайпа между вкладками
    _tabController.addListener(() {
      if (_tabController.index == 1 && _tabController.previousIndex == 0) {
        if (!_validateInfoTab()) {
          _tabController.index = 0; // Возврат на вкладку "Инфо"
          _showError(
              S.of(context).fill_required_info); // ключ: fill_required_info
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
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(localizations.add_product), // ключ: add_product
        bottom: TabBar(
          labelColor: ThemeColors.orange,
          indicatorColor: ThemeColors.orange,
          controller: _tabController,
          indicatorWeight: 4.0,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: localizations.info_tab), // ключ: info_tab
            Tab(text: localizations.characteristics), // ключ: characteristics
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
          const CharacteristicsTab(),
        ],
      ),
    );
  }
}
