import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/editable_dropdown_field.dart';
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/product_responses.dart';
import 'package:bolshek_pro/core/service/brands_service.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/generated/l10n.dart';
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
  ProductItems? product;
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
      return S.of(context).original;
    } else if (variantKind == 'sub_original') {
      return S.of(context).sub_original;
    } else if (variantKind == 'disassemble') {
      return S.of(context).auto_disassembly;
    } else {
      return S.of(context).no_name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = S.of(context);
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
              ? Center(child: Text(local.not_specified))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                      child: Text(
                        S.of(context).editOnlyAfterProductCreated,
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
                            title: local.brand,
                            value: brand?.name ?? local.no_brands,
                            onTap: () {},
                            showIcon: false,
                          ),
                          const SizedBox(height: 12),
                          // Виджет кода товара
                          CustomDropdownField(
                            title: local.vendor_code,
                            value: product?.vendorCode ?? '',
                            onTap: () {},
                            showIcon: false,
                          ),
                          const SizedBox(height: 12),
                          // Виджет типа
                          CustomDropdownField(
                            title: local.choose_type,
                            value: getVariantTitle(product?.kind),
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
