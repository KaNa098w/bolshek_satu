import 'dart:io';
import 'package:bolshek_pro/app/widgets/full_screen_image_widget.dart';
import 'package:bolshek_pro/core/models/category_response.dart';
import 'package:bolshek_pro/core/models/categorybyId_response.dart';
import 'package:bolshek_pro/core/models/fetch_product_response.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/core/models/category_response.dart' as category;
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/service/brands_service.dart';
import 'package:bolshek_pro/core/service/category_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoTabWithName extends StatefulWidget {
  final String productId;
  final TabController tabController;
  final void Function(String) showError;

  const InfoTabWithName({
    Key? key,
    required this.productId,
    required this.tabController,
    required this.showError,
  }) : super(key: key);

  @override
  _InfoTabWithNameState createState() => _InfoTabWithNameState();
}

class _InfoTabWithNameState extends State<InfoTabWithName>
    with AutomaticKeepAliveClientMixin {
  Map<String, List<PropertyItems>> categoryPropertiesCache = {};
  Map<String, Map<String, String>> propertyValuesCache = {};
  String selectedBrand = 'Выберите бренд';
  final BrandsService _brandsService = BrandsService();
  List<BrandItems> brands = [];
  List<BrandItems> filteredBrands = [];
  bool isLoading = true;
  String categoryName = 'Выберите категорию';
  String parentName = 'Выберите категорию';

  final CategoriesService _categoriesService = CategoriesService();
  List<File> _images = [];
  final ProductService _productService = ProductService();
  CategoryByIdResponse? category;

  FetchProductResponse? product;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  Future<void> _getProduct() async {
    try {
      final fetchedProduct = await _productService
          .fetchProduct(context: context, id: widget.productId)
          .timeout(const Duration(seconds: 10));
      debugPrint('Продукт успешно загружен');
      setState(() {
        product = fetchedProduct;
        selectedBrand = fetchedProduct.brandId ?? 'Выберите бренд';
      });

      _getCategoryName();
    } catch (e) {
      debugPrint('Ошибка загрузки продукта: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getCategoryName() async {
    if (product?.categoryId == null || product!.categoryId!.isEmpty) {
      setState(() {
        categoryName = 'Выберите категорию';
        parentName = '';
        isLoading = false;
      });
      return;
    }
    try {
      final fetchCategoryName = await _categoriesService.fetchCategoriesById(
          context, product!.categoryId!);
      setState(() {
        category = fetchCategoryName;
        categoryName = category?.name ?? 'Выберите категорию';
        parentName = category?.parent?.name ?? '';
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Ошибка загрузки категории: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _launchProductUrl() async {
    final url = Uri.parse('${Constants.apiProduct}${widget.productId}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      widget.showError('Не удалось открыть ссылку: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: ThemeColors.orange,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Фото товара',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: product?.images != null &&
                              product!.images!.isNotEmpty
                          ? product!.images!.map((img) {
                              final fullImageUrl = img?.url ?? '';

                              final imageUrl =
                                  (img.sizes != null && img.sizes!.isNotEmpty)
                                      ? (() {
                                          final firstSize = img.sizes!.first;
                                          if (firstSize.width! < 120 &&
                                              img.sizes!.length > 1) {
                                            return img.sizes![1].url;
                                          }
                                          return firstSize.url;
                                        })()
                                      : '';
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) =>
                                        FullScreenImage(imageUrl: fullImageUrl),
                                  ));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 120,
                                  height: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl!,
                                      fit: BoxFit
                                          .contain, // Остается без изменений
                                    ),
                                  ),
                                ),
                              );
                            }).toList()
                          : const [Text("Нет изображения")],
                    ),
                  ),
                  TextButton(
                    onPressed: _launchProductUrl,
                    child: const Text(
                      'Посмотреть товар на bolshek.kz',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  CustomDropdownField(
                    title: 'Наименование товара',
                    value: product?.name ?? 'Не указано',
                    onTap: () {
                      if (product != null) {
                        context.read<GlobalProvider>().setName(product!.name);
                      }
                    },
                    showIcon: false,
                  ),
                  const SizedBox(height: 20),
                  CustomDropdownField(
                    title: 'Категория',
                    value: parentName,
                    showIcon: false,
                    onTap: () {
                      // Реализуйте логику выбора категории
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Цена',
                                    labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500),
                                    hintText: 'Введите цену',
                                    hintStyle: TextStyle(
                                        color: ThemeColors.grey5,
                                        fontWeight: FontWeight.w500),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    final price =
                                        (double.tryParse(value) ?? 0.0) * 100;
                                    context
                                        .read<GlobalProvider>()
                                        .setPrice(price);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'KZT',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      text: 'Создать такой же товар',
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        final price = context.read<GlobalProvider>().price;
                        if (price <= 0) {
                          widget.showError(
                              'Пожалуйста, введите корректную цену.');
                          return;
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
