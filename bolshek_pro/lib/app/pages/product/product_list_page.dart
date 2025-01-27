import 'package:bolshek_pro/app/pages/product/product_change_page.dart';
import 'package:bolshek_pro/core/service/variants_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/app/pages/product/product_detail_screen.dart';
import 'package:bolshek_pro/app/pages/home/add_name_product_page.dart';
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

  String _formatPrice(double price) {
    if (price == price.toInt()) {
      // Если число целое, убираем дробную часть
      return price.toInt().toString();
    } else {
      // Если дробная часть есть, оставляем её
      return price
          .toStringAsFixed(2)
          .replaceAll(RegExp(r"0+$"), "")
          .replaceAll(RegExp(r"\.$"), "");
    }
  }

  void _showPriceEditDialog(
    String productId,
    String variantId,
    double currentPrice,
    String sku,
    String manufacturerId,
    String kind,
  ) {
    final TextEditingController _priceController = TextEditingController(
      text: _formatPrice(currentPrice),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Изменить цену",
            style: TextStyle(fontSize: 18),
          ),
          content: TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Введите новую цену",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Отмена",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                final enteredPrice = double.tryParse(_priceController.text);
                if (enteredPrice != null) {
                  final newPrice = enteredPrice * 100;

                  // Показать индикатор загрузки
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ThemeColors.orange,
                        ),
                      );
                    },
                  );

                  try {
                    // Обновить цену через сервис
                    final variantsService = VariantsService();
                    await variantsService.updateProductVariant(
                      context,
                      productId: productId,
                      variantId: variantId,
                      newAmount: newPrice,
                      sku: sku,
                      manufacturerId: manufacturerId,
                      kind: kind,
                    );

                    setState(() {
                      // Найдите и обновите товар в списке
                      final productIndex = _products.indexWhere(
                        (product) => product.id == productId,
                      );
                      if (productIndex != -1) {
                        _products[productIndex].variants?.first.price?.amount =
                            newPrice.toInt();
                      }
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Цена успешно обновлена",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: ThemeColors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ошибка: $e")),
                    );
                  } finally {
                    Navigator.of(context).pop(); // Закрываем индикатор загрузки
                    Navigator.of(context)
                        .pop(); // Закрываем диалог изменения цены
                  }
                }
              },
              child: const Text(
                "Сохранить",
                style: TextStyle(
                    color: ThemeColors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
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
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    color: ThemeColors.orange,
                    onRefresh: _refreshProducts,
                    child: _products.isEmpty && !_isLoading
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              // Чтобы жест срабатывал, нужно чтобы был хоть какой-то
                              // «пространственный» контент. Можно задать minHeight,
                              // например, как высоту экрана, чтобы потянуть вниз.
                              height: MediaQuery.of(context).size.height -
                                  kToolbarHeight,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/empty_goods.svg',
                                      width: 100,
                                      height: 100,
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'В данном разделе\nнет товаров',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 62),
                            itemCount: _products.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _products.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 10),
                                  child: Center(
                                    child: Column(
                                      children: widget.status ==
                                              Constants.activeStatus
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
                                            ),
                                    ),
                                  ),
                                );
                              }

                              final product = _products[index];
                              return _buildProductItem(
                                index: index, // Передаём индекс
                                product: product, // Передаём продукт
                                name: product.name ?? 'Без названия',
                                price: product.variants != null &&
                                        product.variants!.isNotEmpty
                                    ? '${_formatPriceWithSpaces((product.variants!.first.price?.amount ?? 0) / 100)} ₸'
                                    : 'Цена не указана',
                                imageUrl: product.images?.isNotEmpty == true
                                    ? product.images!.first.getBestFitImage() ??
                                        ''
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
    required int index,
    required ProductItems product,
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
              // SizedBox(
              //   width: 50,
              // ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                elevation: 1,
                onSelected: (value) {
                  // Обработка выбранного действия
                  switch (value) {
                    case 'view_product':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShopProductDetailScreen(productId: productId),
                        ),
                      );
                      break;
                    case 'change_price':
                      final variant = _products[index].variants?.first;
                      if (variant != null) {
                        final variantId = variant.id ?? '';
                        final currentPrice = (variant.price?.amount ?? 0) / 100;
                        final sku = variant.sku ?? '';
                        final manufacturerId = variant.manufacturerId ?? '';
                        final kind = variant.kind ?? '';

                        _showPriceEditDialog(product.id ?? '', variantId,
                            currentPrice, sku, manufacturerId, kind);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('У товара нет вариантов с ценой'),
                          ),
                        );
                      }
                      break;
                    case 'edit_product':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductChangePage(
                            productId: productId,
                            productService: _productService,
                          ),
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view_product',
                    child: Text('Показать товар'),
                  ),
                  const PopupMenuItem(
                    value: 'change_price',
                    child: Text('Изменить цену'),
                  ),
                  const PopupMenuItem(
                    value: 'edit_product',
                    child: Text('Редактировать товар'),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                offset: const Offset(0, 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
