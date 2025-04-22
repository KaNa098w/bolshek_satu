import 'dart:convert';
import 'dart:io';
import 'package:bolshek_pro/app/widgets/full_screen_image_widget.dart';
import 'package:bolshek_pro/core/models/category_response.dart';
import 'package:bolshek_pro/core/models/categorybyId_response.dart';
import 'package:bolshek_pro/core/models/product_responses.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/service/variants_service.dart';
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
import 'package:bolshek_pro/generated/l10n.dart'; // Импорт файла локализации

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
  String selectedBrand = '';
  final BrandsService _brandsService = BrandsService();
  List<BrandItems> brands = [];
  List<BrandItems> filteredBrands = [];
  bool isLoading = true;
  String categoryName = '';
  String parentName = '';

  final CategoriesService _categoriesService = CategoriesService();
  List<File> _images = [];
  final ProductService _productService = ProductService();
  CategoryByIdResponse? category;
  VariantsService _variantsService = VariantsService();
  ProductItems? product;
  bool _isCreatingProduct = false;
  final TextEditingController _priceController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Инициализируем строки по умолчанию в didChangeDependencies, т.к. здесь context еще не доступен
    selectedBrand = '';
    categoryName = '';
    parentName = '';
    _getProduct();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Если строки не установлены, получаем их через локализацию
    if (selectedBrand.isEmpty) {
      selectedBrand = S.of(context).chooseBrand;
    }
    if (categoryName.isEmpty) {
      categoryName = S.of(context).chooseCategory;
    }
    if (parentName.isEmpty) {
      parentName = S.of(context).chooseCategory;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _getProduct() async {
    try {
      final fetchedProduct = await _productService
          .fetchProduct(context: context, id: widget.productId)
          .timeout(const Duration(seconds: 10));
      debugPrint('Product successfully loaded');
      setState(() {
        product = fetchedProduct;
        selectedBrand = fetchedProduct.brandId ?? S.of(context).chooseBrand;
      });

      _getCategoryName();
    } catch (e) {
      debugPrint('Error loading product: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getCategoryName() async {
    if (product?.categoryId == null || product!.categoryId!.isEmpty) {
      setState(() {
        categoryName = S.of(context).chooseCategory;
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
        categoryName = category?.name ?? S.of(context).chooseCategory;
        parentName = category?.parent?.name ?? '';
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading category: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _duplicateProduct() async {
    setState(() {
      _isCreatingProduct = true;
    });
    try {
      final response = await _productService.productDuplicate(
        context,
        product?.id ?? '',
      );

      if (response.statusCode == 200) {
        // Предполагается, что тело ответа выглядит как: { "id": "213sad-sadsad-sadsad" }
        final responseBody = json.decode(response.body);
        final newProductId = responseBody['id'];

        // Получаем цену из GlobalProvider
        final priceAmount = context.read<GlobalProvider>().price;

        // Создаем вариант товара, передавая новый productId и цену.
        await _variantsService.createProductVariant(
          context,
          productId: newProductId,
          priceAmount: priceAmount,
          sku: product?.sku ?? '',
          manufacturerId: product?.manufacturer?.id ?? '',
          kind: product?.kind ?? '',
          discountedAmount: 0,
          discountedPersent: 0,
        );

        // Показываем диалог об успехе
        showSuccessDialog(context);
      }
    } catch (e) {
      debugPrint('Error creating product variant: $e');
    } finally {
      setState(() {
        _isCreatingProduct = false;
      });
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Запрещаем закрывать диалог нажатием вне его
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 60,
                color: Colors.green,
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).success,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            S.of(context).productCreated,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).ok,
                style: const TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchProductUrl() async {
    final url = Uri.parse('${Constants.apiProduct}${widget.productId}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      widget.showError('${S.of(context).failedToOpenLink} $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: ThemeColors.orange,
            ),
          )
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // При нажатии вне текстового поля закрываем клавиатуру
              FocusScope.of(context).unfocus();
              // Сохраняем текущее значение цены
              final price =
                  (double.tryParse(_priceController.text) ?? 0.0) * 100;
              context.read<GlobalProvider>().setPrice(price);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).productPhotos,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
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
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => FullScreenImage(
                                            imageUrl: fullImageUrl),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 120,
                                    height: 120,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imageUrl!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()
                            : [
                                Text(S.of(context).noImage),
                              ],
                      ),
                    ),
                    TextButton(
                      onPressed: _launchProductUrl,
                      child: Text(
                        S.of(context).viewProduct,
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    CustomDropdownField(
                      title: S.of(context).productName,
                      value: product?.name ?? S.of(context).notSpecified,
                      onTap: () {
                        if (product != null) {
                          context.read<GlobalProvider>().setName(product!.name);
                        }
                      },
                      showIcon: false,
                    ),
                    const SizedBox(height: 20),
                    CustomDropdownField(
                      title: S.of(context).category,
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
                                    decoration: InputDecoration(
                                      labelText: S.of(context).price,
                                      labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                      hintText: S.of(context).enterPrice,
                                      hintStyle: const TextStyle(
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
                        text: S.of(context).createProduct,
                        isLoading: _isCreatingProduct,
                        onPressed: () {
                          _duplicateProduct();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
