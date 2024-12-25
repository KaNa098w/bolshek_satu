import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/app/pages/product/product_detail_screen.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/add_name_product_page.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/app/widgets/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductListPage extends StatefulWidget {
  final String status;

  const ProductListPage({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
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
    _loadCachedProducts();
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
    _scrollController.dispose();
    super.dispose();
  }

  /// Загрузка данных из кэша
  Future<void> _loadCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_products_${widget.status}');
    if (cachedData != null) {
      final List<dynamic> cachedList = jsonDecode(cachedData);
      setState(() {
        _products.addAll(
          cachedList.map((e) => ProductItems.fromJson(e)).toList(),
        );
        _skip = _products.length;
      });
    }
  }

  /// Сохранение данных в кэш
  Future<void> _cacheProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _products.map((e) => e.toJson()).toList();
    await prefs.setString('cached_products_${widget.status}', jsonEncode(data));
  }

  Future<void> _fetchProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _productService.fetchProductsPaginated(
        context: context,
        take: _take,
        skip: _skip,
        status: widget.status,
      );

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

      // Сохраняем обновлённый список в кэш
      await _cacheProducts();
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

  Future<void> _refreshProducts() async {
    setState(() {
      _products.clear();
      _skip = 0;
      _hasMore = true;
    });
    await _fetchProducts();
  }

  void _addNewProduct(ProductItems newProduct) {
    if (!_products.any((product) => product.id == newProduct.id)) {
      setState(() {
        _products.insert(0, newProduct);
      });
      _cacheProducts(); // Обновляем кэш
    }
  }

  String _formatPriceWithSpaces(double price) {
    final formatter = NumberFormat("#,###", "ru_RU");
    return formatter.format(price).replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.greyF,
      body: Stack(
        children: [
          // Список товаров с обновлением через RefreshIndicator
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    color: ThemeColors.orange,
                    onRefresh: _refreshProducts,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _products.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _products.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 10),
                            child: Center(
                              child: Column(
                                  children:
                                      widget.status == Constants.activeStatus
                                          ? List.generate(
                                              2,
                                              (index) => const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Row(
                                                  children: [
                                                    LoadingWidget(
                                                      width: 360,
                                                      height: 90,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : List.generate(
                                              2,
                                              (index) => const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Row(
                                                  children: [
                                                    LoadingWidget(
                                                      width: 360,
                                                      height: 90,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                            ),
                          );
                        }

                        final product = _products[index];
                        return _buildProductItem(
                          name: product.name ?? 'Без названия',
                          price: product.variants != null &&
                                  product.variants!.isNotEmpty
                              ? '${_formatPriceWithSpaces((product.variants!.first.price?.amount ?? 0) / 100)} ₸'
                              : 'Цена не указана',
                          imageUrl: product.images?.isNotEmpty == true
                              ? product.images!.first.getBestFitImage() ?? ''
                              : '',
                          productId: product.id ?? '',
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Плавающая кнопка добавления нового товара
          Positioned(
            bottom: 8,
            left: 16,
            right: 16,
            child: CustomButton(
              text: Constants.addNewGood,
              onPressed: () async {
                final newProduct = await Navigator.push<ProductItems>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductNameInputPage(),
                  ),
                );

                if (newProduct != null) {
                  _addNewProduct(newProduct);
                }
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
    required String imageUrl,
    required String productId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopProductDetailScreen(productId: productId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 80,
                  minHeight: 80,
                  maxWidth: 80,
                  maxHeight: 80,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl.isEmpty
                      ? Image.asset('assets/icons/error_image.png',
                          fit: BoxFit.cover)
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/icons/error_image.png',
                                fit: BoxFit.cover);
                          },
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Обработка нажатия на троеточие
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
