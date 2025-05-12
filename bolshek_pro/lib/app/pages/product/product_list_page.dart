import 'dart:convert';

import 'package:bolshek_pro/app/pages/product/product_change_page.dart';
import 'package:bolshek_pro/core/models/product_responses.dart';
import 'package:bolshek_pro/core/service/variants_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/generated/l10n.dart';
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
    int   _page = 0;     
  final int _take = 25;

  // ──────────────────────────────────────────────── lifecycle
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

  // ──────────────────────────────────────────────── cache helpers
Future<void> _loadCachedProducts() async {
  final prefs = await SharedPreferences.getInstance();
  final cached = prefs.getString('cached_products_${widget.status}');
  if (cached != null) {
    final list = (jsonDecode(cached) as List)
        .map((e) => ProductItems.fromJson(e))
        .toList();

    setState(() {
      _products.addAll(list);
      _page = (_products.length / _take).ceil();   // ← сколько страниц уже есть
    });
  }
}

  Future<void> _cacheProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _products.map((e) => e.toJson()).toList();
    await prefs.setString('cached_products_${widget.status}', jsonEncode(data));
  }

  // ──────────────────────────────────────────────── data
  Future<void> _fetchProducts() async {
  if (_isLoading || !_hasMore) return;
  setState(() => _isLoading = true);

  try {
    final response = await _productService.fetchProductsPaginated(
      context: context,
      take: _take,
      skip: _page * _take,
      status: widget.status,
    );

    final items  = response.items  ?? [];
    final total  = response.total ?? 0;

    for (final p in items) {
      if (!_products.any((e) => e.id == p.id)) _products.add(p);
    }

    _page++;
    _hasMore = _products.length < total;

    // ⬅️  сохраняем обновлённый список
    await _cacheProducts();         // <<< ДОБАВИЛИ
  } catch (e) {
    final loc = S.of(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${loc.load_error}$e')));
  } finally {
    setState(() => _isLoading = false);
  }
}


Future<void> _refreshProducts() async {
  setState(() {
    _products.clear();
    _page    = 0;
    _hasMore = true;
  });

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('cached_products_${widget.status}');  // очистили

  await _fetchProducts();         // первая свежая страница сразу попадёт в кэш
}


  void _addNewProduct(ProductItems p) {
    if (_products.any((e) => e.id == p.id)) return;
    setState(() => _products.insert(0, p));
    _cacheProducts();
  }

  // ──────────────────────────────────────────────── formatting
  String _formatPriceWithSpaces(double value) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return formatter.format(value).replaceAll(',', ' ');
  }

  // ──────────────────────────────────────────────── dialogs
  void _showPriceEditDialog({
    required ProductItems product,
  }) {
    final loc = S.of(context);
    final controller = TextEditingController(
      text: _formatPriceWithSpaces((product.price?.amount ?? 0) / 100),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          loc.change_price_dialog_title,
          style: const TextStyle(fontSize: 18),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: loc.enter_new_price_hint),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(
              loc.cancel,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () async {
              final entered =
                  double.tryParse(controller.text.replaceAll(' ', ''));
              if (entered == null) return;
              final newAmount = (entered * 100).toInt();

              // loader
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: ThemeColors.orange),
                ),
              );

              try {
                await VariantsService().updateProductVariant(
                  context,
                  productId: product.id ?? '',
                  variantId: product.id ?? '', // вариант = сам товар
                  newAmount: newAmount.toDouble(),
                  sku: product.sku ?? '',
                  manufacturerId: product.manufacturerId ?? '',
                  kind: product.kind ?? '',
                  discountedAmount:
                      (product.discountedPrice?.amount ?? 0).toDouble(),
                  discountedPersent: product.discountPercent ?? 0,
                );

                setState(() {
                  final idx = _products.indexWhere((e) => e.id == product.id);
                  if (idx != -1) {
                    _products[idx].price?.amount = newAmount;
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      loc.price_update_success,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: ThemeColors.green,
                  ),
                );
              } finally {
                Navigator.of(context).pop(); // loader
                Navigator.of(context).pop(); // dialog
              }
            },
            child: Text(
              loc.save,
              style: const TextStyle(
                  color: ThemeColors.orange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────── build
  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

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
                        ? _buildEmpty(loc)
                        : _buildList(loc),
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
              text: loc.add_new_good,
              onPressed: () async {
                final newProduct = await Navigator.push<ProductItems>(
                  context,
                  MaterialPageRoute(builder: (_) => ProductNameInputPage()),
                );
                if (newProduct != null) _addNewProduct(newProduct);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────── widgets
  Widget _buildEmpty(S loc) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svg/empty_goods.svg',
                    width: 100, height: 100),
                const SizedBox(height: 15),
                Text(
                  loc.no_products_message,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildList(S loc) => ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 62),
        itemCount: _products.length + (_hasMore ? 1 : 0),
        itemBuilder: (_, index) {
          if (index == _products.length) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
              child: Center(
                child: Column(
                  children: List.generate(
                    2,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          LoadingWidget(width: 360, height: 90),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          final product = _products[index];
          final amount = product.price?.amount;
          final priceStr = amount != null
              ? '${_formatPriceWithSpaces(amount / 100)} ₸'
              : loc.price_not_specified;

          return _buildProductItem(
            product: product,
            price: priceStr,
            discountPercent: product.discountPercent ?? 0,
          );
        },
      );

  Widget _buildProductItem({
    required ProductItems product,
    required String price,
    required int discountPercent,
  }) {
    final originalAmount = (product.price?.amount ?? 0) / 100;
    final loc = S.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ShopProductDetailScreen(productId: product.id ?? ''),
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
              _buildImage(product, discountPercent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? loc.no_name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildPriceWidget(price, discountPercent, originalAmount),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                elevation: 1,
                onSelected: (value) {
                  switch (value) {
                    case 'view_product':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopProductDetailScreen(
                            productId: product.id ?? '',
                          ),
                        ),
                      );
                      break;
                    case 'change_price':
                      _showPriceEditDialog(product: product);
                      break;
                    case 'edit_product':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductChangePage(
                            productId: product.id ?? '',
                            productService: _productService,
                          ),
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'view_product',
                    child: Text(loc.view_product),
                  ),
                  PopupMenuItem(
                    value: 'change_price',
                    child: Text(loc.change_price),
                  ),
                  PopupMenuItem(
                    value: 'edit_product',
                    child: Text(loc.edit_product),
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

  Widget _buildPriceWidget(
      String price, int discountPercent, double originalAmount) {
    if (discountPercent != 0) {
      final discounted = originalAmount * (100 - discountPercent) / 100;
      return Row(
        children: [
          Text(
            price,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.lineThrough,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${_formatPriceWithSpaces(discounted)} ₸',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      );
    }
    return Text(
      price,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildImage(ProductItems product, int discountPercent) {
    final imageUrl = product.images?.isNotEmpty == true
        ? product.images!.first.getBestFitImage() ?? ''
        : '';
    return Stack(
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
                ? Image.asset('assets/icons/error_image.png', fit: BoxFit.cover)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/icons/error_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        if (discountPercent != 0)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Text(
                '-$discountPercent%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
