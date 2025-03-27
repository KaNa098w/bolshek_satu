import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/editable_dropdown_field.dart';
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/fetch_product_response.dart';
import 'package:bolshek_pro/core/service/brands_service.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class CharacteristicsTabWithName extends StatefulWidget {
  final String productId;
  const CharacteristicsTabWithName({super.key, required this.productId});

  @override
  State<CharacteristicsTabWithName> createState() =>
      _CharacteristicsTabWithNameState();
}

class _CharacteristicsTabWithNameState extends State<CharacteristicsTabWithName>
    with AutomaticKeepAliveClientMixin {
  final ProductService _productService = ProductService();
  FetchProductResponse? product;
  bool isLoading = true;
  final BrandsService _brandsService = BrandsService();
  BrandItems? brand;

  @override
  bool get wantKeepAlive => true; // Сохраняем состояние экрана

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
        isLoading = false;
      });
      _getBrandName();
    } catch (e) {
      debugPrint('Ошибка загрузки продукта: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getBrandName() async {
    try {
      final fetchBrandName = await _brandsService
          .fetchBrandById(context, product?.brandId ?? '')
          .timeout(const Duration(seconds: 10));
      debugPrint('Бренд успешно загружен');
      setState(() {
        brand = fetchBrandName;
      });
    } catch (e) {
      debugPrint('Ошибка загрузки бренда: $e');
    }
  }

  String getVariantTitle(String? variantKind) {
    if (variantKind == 'original') {
      return 'Оригинал';
    } else if (variantKind == 'sub_original') {
      return 'Под оригинал';
    } else if (variantKind == 'disassemble') {
      return 'Авторазбор';
    } else {
      return 'Неизвестный';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Не забудьте вызвать super.build при использовании AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : (product?.properties == null || product!.properties!.isEmpty)
              ? const Center(child: Text('Нет характеристик'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                      child: Text(
                        'Изменение доступно только после создания товара',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(8.0),
                        children: [
                          // Виджеты характеристик
                          ...product!.properties!.map((propertyItem) {
                            final propertyName =
                                propertyItem.property?.name ?? '';
                            final propertyValue = propertyItem.value ?? '';
                            final propertyType =
                                propertyItem.property?.unit ?? '';
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CustomDropdownField(
                                title: propertyType.isEmpty
                                    ? propertyName
                                    : '$propertyName $propertyType',
                                value: propertyValue,
                                onTap: () {},
                                showIcon: false,
                              ),
                            );
                          }).toList(),
                          // Виджет бренда
                          CustomDropdownField(
                            title: 'Бренд',
                            value: brand?.name ?? '',
                            onTap: () {},
                            showIcon: false,
                          ),
                          const SizedBox(height: 12),
                          // Виджет кода товара
                          CustomDropdownField(
                            title: 'Код товара',
                            value: product?.vendorCode ?? '',
                            onTap: () {},
                            showIcon: false,
                          ),
                          const SizedBox(height: 12),
                          // Виджет типа
                          CustomDropdownField(
                            title: 'Тип',
                            value:
                                getVariantTitle(product?.variants?.first.kind),
                            onTap: () {},
                            showIcon: false,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
