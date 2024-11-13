import 'package:bolshek_pro/ui/pages/home/home_widgets/add_product_widgets/characteristics_tab.dart';
import 'package:bolshek_pro/ui/pages/home/home_widgets/add_product_widgets/info_tab.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/ui/widgets/custom_button.dart';
import 'package:bolshek_pro/ui/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/utils/theme.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

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
        children: const [
          InfoTab(), // Вкладка "Инфо" из отдельного файла
          CharacteristicsTab(), // Вкладка "Характеристики" из отдельного файла
        ],
      ),
    );
  }
}
