import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/app/pages/home/home_widgets/add_name_product_page.dart';
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
    _loadFromCache(); // Загружаем товары из кэша
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

      setState(() {
        _products.addAll(response.items ?? []);
        _skip += _take;
        _hasMore = (response.items?.length ?? 0) == _take;
      });

      // Сохраняем загруженные товары в кэш
      await _saveToCache();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonData =
          jsonEncode(_products.map((e) => e.toJson()).toList());
      await prefs.setString('cached_on_sale_products', jsonData);
    } catch (e) {
      debugPrint('Ошибка сохранения в кэш: $e');
    }
  }

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonData = prefs.getString('cached_on_sale_products');
      if (jsonData != null) {
        final List<dynamic> jsonList = jsonDecode(jsonData);
        setState(() {
          _products
              .addAll(jsonList.map((e) => ProductItems.fromJson(e)).toList());
        });
      }
    } catch (e) {
      debugPrint('Ошибка загрузки из кэша: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _products.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _products.length) {
                  return const Center(child: CircularProgressIndicator());
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
                );
              },
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
        // Логика при нажатии на товар
      },
    );
  }
}
