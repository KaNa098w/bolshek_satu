import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:bolshek_pro/app/widgets/product_detail_widget.dart';
import 'package:bolshek_pro/app/pages/product/product_detail_screen.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/add_name_product_page.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class Discontinued extends StatefulWidget {
  const Discontinued({Key? key}) : super(key: key);

  @override
  State<Discontinued> createState() => _Discontinued();
}

class _Discontinued extends State<Discontinued> {
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

    // Добавляем обработчик для прокрутки
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

    if (!mounted) return; // Проверяем, что виджет всё ещё смонтирован
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _productService.fetchProductsStatuses(
        context: context,
      );

      if (!mounted) return; // Проверяем, что виджет всё ещё смонтирован
      setState(() {
        _products.addAll(response.items ?? []);
        _skip += _take;
        _hasMore = (response.items?.length ?? 0) == _take;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Проверяем, что виджет всё ещё смонтирован
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $e')),
        );
      }
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
      backgroundColor: ThemeColors.white,
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
                                3, // Количество повторений
                                (index) => const Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 10), // Отступ между строками
                                  child: LoadingWidget(
                                    width: 380, // Занимает всю ширину строки
                                    height: 75, // Высота строки товара
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
            padding: const EdgeInsets.all(16.0),
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

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leading: Container(
        width: 80,
        height: 80,
        color: Colors.white,
        child: imageUrl.isEmpty
            ? const Icon(Icons.image, size: 40, color: Colors.grey)
            : Image.network(imageUrl, fit: BoxFit.contain),
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
    );
  }
}
