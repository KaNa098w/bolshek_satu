import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/app/pages/home/home_widgets/add_name_product_page.dart';
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

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _productService.fetchProductsPaginated(
          context: context,
          take: _take,
          skip: _skip,
          status: 'awaiting_approval');

      setState(() {
        _products.addAll(response.items ?? []);
        _skip += _take;
        _hasMore = (response.items?.length ?? 0) == _take;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
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
              controller: _scrollController, // Привязываем контроллер
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
