import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/app/pages/home/home_widgets/add_product_widgets/characteristics_tab.dart';
import 'package:bolshek_pro/app/pages/home/home_widgets/add_product_widgets/info_tab.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/core/utils/theme.dart';

class AddProductPage extends StatefulWidget {
  final String productName;
  const AddProductPage({Key? key, required this.productName}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PropertyItems> cachedProperties = [];
  Map<String, String> cachedPropertyValues = {};

  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Добавляем слушатель переключения вкладок
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        // Если переключились на "Характеристики"
        setState(() {
          // Обновляем данные в CharacteristicsTab
          // Это уже делается через свойства _properties и _propertyValues
        });
      }
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
              setState(() {
                cachedProperties = properties;
                cachedPropertyValues = propertyValues;
              });
            },
            tabController: _tabController,
            onCategorySelected: (categoryId) {
              setState(() {
                selectedCategoryId = categoryId;
              });
            },
          ),
          CharacteristicsTab(
            categoryId: selectedCategoryId,
            cachedProperties: cachedProperties,
            cachedPropertyValues: cachedPropertyValues,
          ),
        ],
      ),
    );
  }
}
