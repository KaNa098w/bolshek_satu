import 'dart:convert';
import 'package:bolshek_pro/app/pages/product/product_detail_screen.dart';
import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/add_name_product_page.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class OnSale extends StatefulWidget {
  const OnSale({Key? key}) : super(key: key);

  @override
  State<OnSale> createState() => _OnSaleState();
}

class _OnSaleState extends State<OnSale> {
  final ProductService _productService = ProductService();
  final List<ProductItems> _products = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;
  final int _take = 25;

  @override
  void initState() {
    super.initState();
    _fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Очищаем контроллер
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _productService.fetchProductsPaginated(
          context: context, take: _take, skip: _skip, status: 'active');

      if (!mounted) return; // Проверяем, что виджет всё ещё активен

      setState(() {
        final newProducts = response.items ?? [];
        for (var product in newProducts) {
          if (!_products.any((p) => p.id == product.id)) {
            _products.add(product);
          }
        }
        _skip += _take;
        _hasMore = (response.items?.length ?? 0) == _take;
      });
    } catch (e) {
      if (!mounted) return; // Проверяем, что виджет всё ещё активен
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
    } finally {
      if (!mounted) return; // Проверяем, что виджет всё ещё активен
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _products.clear(); // Очищаем текущий список
      _skip = 0; // Сбрасываем позицию для пагинации
      _hasMore = true; // Сбрасываем индикатор наличия данных
    });
    await _fetchProducts(); // Загружаем данные заново
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.greyF,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Оборачиваем ListView в RefreshIndicator
                RefreshIndicator(
                  color: ThemeColors.orange,
                  onRefresh: _refreshProducts, // Метод обновления данных
                  child: ListView.builder(
                    controller: _scrollController, // Привязываем контроллер
                    itemCount: _products.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _products.length) {
                        // Загрузчик внизу списка
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10),
                          child: Center(
                            child: Column(
                              children: List.generate(
                                6, // Количество повторений
                                (index) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10), // Отступ между строками
                                  child: Row(
                                    children: [
                                      // Левая часть загрузочного индикатора
                                      LoadingWidget(
                                        width: 80, // Меньшая ширина
                                        height: 70, // Высота строки товара
                                      ),
                                      const SizedBox(
                                          width: 10), // Отступ между частями
                                      // Правая часть загрузочного индикатора
                                      LoadingWidget(
                                        width: 280, // Большая ширина
                                        height: 70, // Высота строки товара
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final product = _products[index];
                      return _buildProductItem(
                        name: product.name ?? 'Без названия',
                        price: product.variants != null &&
                                product.variants!.isNotEmpty
                            ? '${(product.variants!.first.price?.amount ?? 0) / 100} ₸'
                            : 'Цена не указана',
                        image: product.images?.isNotEmpty == true
                            ? product.images!.first
                            : null,
                        productId: product.id ?? '', // Передаем productId
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 5),
            child: CustomButton(
              text: 'Добавить новый товар',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductNameInputPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem({
    required String name,
    required String price,
    required Images? image,
    required String productId, // Добавляем параметр productId
  }) {
    final imageUrl = image?.getBestFitImage() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Белый фон
          borderRadius: BorderRadius.circular(12), // Слегка овальные края
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.1),
          //     blurRadius: 6,
          //     offset: const Offset(0, 3), // Слегка приподнятая тень
          //   ),
          // ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
          leading: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(8), // Овальные края для изображения
            ),
            child: imageUrl.isEmpty
                ? const Icon(Icons.image, size: 40, color: Colors.grey)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(imageUrl, fit: BoxFit.contain),
                  ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              price,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: const Icon(Icons.more_vert),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopProductDetailScreen(
                    productId: productId), // Передаем productId
              ),
            );
          },
        ),
      ),
    );
  }
}
