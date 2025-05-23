import 'package:bolshek_pro/app/pages/product/product_change_page.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/full_screen_image_widget.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/hex_colors_widget.dart';
import 'package:bolshek_pro/app/widgets/quantity_widget.dart';
import 'package:bolshek_pro/app/widgets/widget_from_bolshek/common_text_button.dart';
import 'package:bolshek_pro/app/widgets/widget_from_bolshek/theme_text_style.dart';
import 'package:bolshek_pro/core/models/product_responses.dart';
import 'package:bolshek_pro/core/models/tags_response.dart';
import 'package:bolshek_pro/core/models/warehouses_response.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/service/status_change_service.dart';
import 'package:bolshek_pro/core/service/variants_service.dart';
import 'package:bolshek_pro/core/service/warehouse_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:provider/provider.dart';

class ShopProductDetailScreen extends StatefulWidget {
  final String productId;

  const ShopProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  _ShopProductDetailScreenState createState() =>
      _ShopProductDetailScreenState();
}

class _ShopProductDetailScreenState extends State<ShopProductDetailScreen> {
  final ProductService _productService = ProductService();
  bool _isLoading = true;
  String? _productName;
  String? _productDescription;
  List<String> _productImages = [];
  double? _productPrice;
  int? _discountPersent;
  String? _variantId;
  String? _status;
  List<Map<String, String>> _productCharacteristics = [];
  String? _articul;
  String? _manufacturers_name;
  String? _variants_kod;
  int selectedImageIndex = 0;
  int selectedVariantIndex = 0;
  int? _variants_lenght;
  String? _variant_kind;
  ProductItems? _product;
  String? _manufacturerId;
  List<ItemsTags>? _tags;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final product = await _productService.fetchProduct(
        context: context,
        id: widget.productId,
      );
      setState(() {
        _tags = product.tags;
        _manufacturerId = product.manufacturerId;
        _variant_kind = product.kind;
        // _variants_lenght = product.length;
        _variants_kod = product.sku ?? '';
        _manufacturers_name = product.manufacturer?.name;
        _articul = product.vendorCode;
        _discountPersent = product.discountPercent ?? 0;
        _status = product.status;
        _variantId = product.id;
        // Название товара
        _productName = product.name ?? S.of(context).product_name_absent;
        _product = product;
        // Описание товара
        _productDescription = product.description?.blocks?.isNotEmpty == true
            ? product.description!.blocks!.first.data?.text ??
                S.of(context).product_description_absent
            : S.of(context).product_description_absent;
        // Список изображений
        _productImages = product.images?.map((e) => e.url ?? "").toList() ?? [];
        // Список характеристик
        _productCharacteristics = product.properties?.map((prop) {
              return {
                "title": prop.property?.name ??
                    S.of(context).characteristic_title_absent,
                "value":
                    prop.value ?? S.of(context).characteristic_value_absent,
              };
            }).toList() ??
            [];
        // Цена товара (берется из первого варианта)
        _productPrice = (product.price?.amount ??
                    product.discountedPrice?.amount ??
                    product.basePrice?.amount)
                ?.toDouble() ??
            0.0;
        _isLoading = false;
      });
    } catch (e) {
      print('${S.of(context).error}: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
            final permissions = context.read<GlobalProvider>().permissions;
            final manager = context.read<GlobalProvider>().managerValue;

    final localizations = S.of(context);

    return Scaffold(
      backgroundColor: ThemeColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 32, // Уменьшаем высоту AppBar
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 25, // Уменьшаем размер иконки
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            constraints: const BoxConstraints(
              minWidth: 32, // Минимальная ширина кнопки
              minHeight: 32, // Минимальная высота кнопки
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: ThemeColors.orange,
            ))
          : _buildProductDetails(),
      bottomNavigationBar: manager == Constants.manager  ?_buildBottomBarIsManager() :  _buildBottomBar() ,
    );
  }

  Widget _buildProductDetails() {
             final permissions = context.read<GlobalProvider>().permissions;
               final manager = context.read<GlobalProvider>().managerValue;

    return Container(
      color: ThemeColors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildProductImages(),
            const SizedBox(height: 20),
            _buildProductNameAndActions(),
            const SizedBox(height: 10),
            _buildProductPrice(),
            const SizedBox(height: 10),
            Divider(color: ThemeColors.grey2),
            _buildProductDescription(),
            const SizedBox(height: 20),
            _buildProductCharacteristics(
                _variants_kod ?? "", _manufacturers_name ?? ""),
            const SizedBox(height: 10),
            if (manager != Constants.manager)
            _buildProductWarehouses()
          ],
        ),
      ),
    );
  }

  Widget _buildProductImages() {
    final localizations = S.of(context);
    return _productImages.isNotEmpty
        ? GestureDetector(
            onTap: () {
              if (_productImages.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      imageUrl: _productImages[_currentPage],
                    ),
                  ),
                );
              } else {
                print(localizations.no_available_image);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 365,
                  height: 365,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _productImages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            _productImages[index],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_discountPersent != 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: ThemeColors.black,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  "-$_discountPersent%",
                                  style:
                                      ThemeTextMontserratBold.size16.copyWith(
                                    color: ThemeColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (_tags != null && _tags!.isNotEmpty)
                              ..._tags!.map((tag) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: tag.backgroundColor != null
                                        ? HexColor(tag.backgroundColor!)
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text(
                                    tag.text ?? localizations.tag_default,
                                    style: TextStyle(
                                      color: tag.textColor != null
                                          ? HexColor(tag.textColor!)
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _productImages.length > 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_productImages.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 12 : 8,
                            height: _currentPage == index ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? ThemeColors.orange
                                  : Colors.grey,
                            ),
                          );
                        }),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          )
        : Center(
            child: Container(
              width: 365,
              height: 365,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[200],
              ),
              child: const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
          );
  }

  Widget _buildProductNameAndActions() {
    final localizations = S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            _productName ?? localizations.product_name_absent,
            style: ThemeTextMontserratBold.size21.copyWith(
              fontSize: 16,
              color: ThemeColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductPrice() {
            final managerValue = context.read<GlobalProvider>().managerValue;

    final loc = S.of(context);
      //        final permissions = context.read<GlobalProvider>().permissions;
      // final isManager = permissions.contains('warehouse_read');

    final hasPrice = _productPrice != null && _productPrice! > 0;
    final priceKzt = _productPrice! / 100; // в тенге
    final discount = _discountPersent ?? 0;
    final hasDiscount = hasPrice && discount > 0;
    final discounted = hasDiscount ? priceKzt * (1 - discount / 100) : priceKzt;
      final warehouseId = context.read<GlobalProvider>().warehouseId;

final currentWarehouse = _product?.warehouses
    ?.firstWhereOrNull((wh) => wh.warehouse?.id == warehouseId);



    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: hasPrice
                  ? hasDiscount
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_formatPriceWithSpaces(priceKzt)} ₸',
                              style: ThemeTextMontserratBold.size18.copyWith(
                                fontSize: 14,
                                color: ThemeColors.grey5,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_formatPriceWithSpaces(discounted)} ₸',
                              style: ThemeTextMontserratBold.size21.copyWith(
                                fontSize: 18,
                                color: ThemeColors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          '${_formatPriceWithSpaces(priceKzt)} ₸',
                          style: ThemeTextMontserratBold.size21.copyWith(
                            fontSize: 17,
                            color: ThemeColors.grey5,
                          ),
                        )
                  : Text(
                      loc.price_absent,
                      style: ThemeTextMontserratBold.size21.copyWith(
                        fontSize: 17,
                        color: ThemeColors.grey5,
                      ),
                    ),
            ),
            if (managerValue != Constants.manager)
            TextButton(
              onPressed: () =>
                  _showPriceEditDialog(widget.productId, _variantId!),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                minimumSize: const Size(0, 0),
                side: const BorderSide(color: ThemeColors.orange, width: 0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                loc.change_price,
                style: const TextStyle(
                  fontSize: 14,
                  color: ThemeColors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    width: 110,
                    height: 25,
                    decoration: BoxDecoration(
                      color: ThemeColors.orange,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ThemeColors.orange),
                    ),
                    child: Center(
                      child: Text(
                        _variant_kind == 'original'
                            ? loc.original
                            : _variant_kind == 'sub_original'
                                ? loc.sub_original
                                : _variant_kind == 'disassemble'
                                    ? loc.auto_disassembly
                                    : loc.unknown_variant,
                        style: ThemeTextInterRegular.size11.copyWith(
                          color: ThemeColors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),


if (currentWarehouse != null)
  Row(
    children: [
      Text(
        'Количество: ${currentWarehouse.quantity}',
        style: ThemeTextMontserratBold.size21.copyWith(
          fontSize: 12,
          color: ThemeColors.black,
          fontWeight: FontWeight.w300,
        ),
      ),
    ],
  )

          ],
        ),
      ],
    );
  }

  String _formatPriceWithSpaces(double price) {
    final formatter = NumberFormat("#,###", "ru_RU");
    return formatter.format(price).replaceAll(',', ' ');
  }

  String _formatPrice(double price) {
    if (price == price.toInt()) {
      return price.toInt().toString();
    } else {
      return price
          .toStringAsFixed(2)
          .replaceAll(RegExp(r"0+$"), "")
          .replaceAll(RegExp(r"\.$"), "");
    }
  }

  void _showPriceEditDialog(String productId, String variantId) {
    final double initialPrice =
        _productPrice != null ? _productPrice! / 100 : 0.0;

    final priceController = TextEditingController(
      text: initialPrice > 0 ? _formatPrice(initialPrice) : "",
    );
    final discountPercentController = TextEditingController(
      text: _discountPersent?.toString() ?? "",
    );
    final finalPriceController = TextEditingController();

    // Если есть начальные значения – сразу посчитаем итог
    if (initialPrice > 0 && _discountPersent != null) {
      final finalPrice = initialPrice * (100 - _discountPersent!) / 100;
      finalPriceController.text = finalPrice.toStringAsFixed(0);
    }


    Widget buildCustomTextField({
      required TextEditingController controller,
      String hintText = "",
      String suffixText = "",
      bool readOnly = false,
      ValueChanged<String>? onChanged,
    }) {
      return TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        readOnly: readOnly,
        cursorColor: Colors.orange,
        decoration: InputDecoration(
          hintText: hintText,
          suffixText: suffixText,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
        onChanged: onChanged,
      );
    }

    void _recalculateFinal() {
      final price = double.tryParse(priceController.text) ?? 0.0;
      final percent = int.tryParse(discountPercentController.text) ?? 0;
      final finalPrice = price * (100 - percent) / 100;
      finalPriceController.text = finalPrice.toStringAsFixed(0);
    }

    showDialog(
      context: context,
      builder: (context) {
        final l = S.of(context);
        return AlertDialog(
          title: Text(l.change_price, style: const TextStyle(fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l.product_amount,
                    style: const TextStyle(color: Colors.grey)),
              ),
              buildCustomTextField(
                controller: priceController,
                hintText: l.enter_new_price,
                suffixText: "₸",
                onChanged: (_) => _recalculateFinal(),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l.discount_percent,
                    style: const TextStyle(color: Colors.grey)),
              ),
              buildCustomTextField(
                controller: discountPercentController,
                hintText: l.enter_discount_percent,
                suffixText: "%",
                onChanged: (value) {
                  // ограничим до 99
                  int? p = int.tryParse(value);
                  if (p != null && p > 99) {
                    p = 99;
                    discountPercentController.text = "99";
                    discountPercentController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                          offset: discountPercentController.text.length),
                    );
                  }
                  _recalculateFinal();
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l.discount_amount,
                    style: const TextStyle(color: Colors.grey)),
              ),
              buildCustomTextField(
                controller: finalPriceController,
                hintText: l.discount_amount,
                suffixText: "₸",
                readOnly: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.cancel,
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () async {
                final enteredPrice = double.tryParse(priceController.text);
                final enteredPercent =
                    int.tryParse(discountPercentController.text);
                if (enteredPrice != null && enteredPercent != null) {
                  final newAmount = (enteredPrice * 100).round();
                  final newDiscountPercent = enteredPercent;
                  final newDiscountedAmount =
                      ((enteredPrice * (100 - newDiscountPercent) / 100) * 100)
                          .round();

                  // Покажем лоадер
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child:
                          CircularProgressIndicator(color: ThemeColors.orange),
                    ),
                  );

                  try {
                    final svc = VariantsService();
                    await svc.updateProductVariant(
                      context,
                      productId: productId,
                      variantId: variantId,
                      newAmount: newAmount.toDouble(),
                      sku: _variants_kod,
                      manufacturerId: _manufacturerId,
                      kind: _variant_kind,
                      discountedAmount: newDiscountedAmount.toDouble(),
                      discountedPersent: newDiscountPercent,
                    );
                    await _fetchProductDetails();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.price_updated,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        backgroundColor: ThemeColors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${l.error}: $e")),
                    );
                  } finally {
                    Navigator.of(context).pop(); // убираем лоадер
                    Navigator.of(context)
                        .pop(); // убираем диалог редактирования
                  }
                }
              },
              child: Text(l.save,
                  style: const TextStyle(
                      color: ThemeColors.orange, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductDescription() {
    final localizations = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.description,
          style: ThemeTextMontserratBold.size21.copyWith(
            color: ThemeColors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _productDescription ?? localizations.description_absent,
          style: ThemeTextInterRegular.size11.copyWith(
            fontSize: 14,
            color: ThemeColors.grey8,
          ),
        ),
      ],
    );
  }

Widget _buildProductWarehouses() {
  final localizations = S.of(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        localizations.your_warehouse,
        style: ThemeTextMontserratBold.size21.copyWith(
          color: ThemeColors.black,
        ),
      ),
      const SizedBox(height: 8),
      if (_product?.warehouses != null && _product!.warehouses!.isNotEmpty)
        ..._product!.warehouses!.map((item) {
          final warehouseName = item.warehouse?.name ?? '';
          final quantity = item.quantity?.toString() ?? '';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(warehouseName),
                Text(quantity),
              ],
            ),
          );
        }).toList()
      else
        Text(localizations.empty), // можно добавить ключ перевода
    ],
  );
}


  Widget _buildProductCharacteristics(String productCode, String brandName) {
    final localizations = S.of(context);
    final updatedCharacteristics = [
      {
        "title": localizations.product_code,
        "value":
            productCode.isNotEmpty ? productCode : localizations.not_specified,
      },
      {
        "title": localizations.manufacturer,
        "value": brandName.isNotEmpty ? brandName : localizations.not_specified,
      },
      ..._productCharacteristics,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.characteristics,
          style: ThemeTextMontserratBold.size21.copyWith(
            color: ThemeColors.black,
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final characteristic = updatedCharacteristics[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  characteristic["title"]!,
                  style: ThemeTextInterRegular.size11.copyWith(
                    fontSize: 14,
                    color: ThemeColors.grey8,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    characteristic["value"]!,
                    style: ThemeTextInterRegular.size11.copyWith(
                      fontSize: 14,
                      color: ThemeColors.black,
                    ),
                    textAlign: TextAlign.right,
                    softWrap: true,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          itemCount: updatedCharacteristics.length,
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final localizations = S.of(context);
    if (_isLoading) {
      return Container(
        height: 0,
        color: Colors.transparent,
      );
    }

    return Container(
      color: ThemeColors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonTextButton(
                  size: 15,
                  buttonText: _status == 'inactive'
                      ? localizations.publish
                      : localizations.from_sale,
                  textColor: ThemeColors.blackWithPath,
                  onTap: () {
                    if (_status == 'inactive') {
                      _showPublishConfirmationDialog(context);
                    } else {
                      _showConfirmationDialog(context);
                    }
                  },
                  bgColor: _status == 'inactive'
                      ? ThemeColors.green
                      : ThemeColors.grey2,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CommonTextButton(
                  buttonText: localizations.change_product,
                  size: 15,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductChangePage(
                          productId: widget.productId,
                          productService: _productService,
                        ),
                      ),
                    );
                    if (result == true) {
                      _fetchProductDetails();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarIsManager() {
  final warehouseId = context.read<GlobalProvider>().warehouseId;
  final localizations = S.of(context);

  final currentWarehouse = _product?.warehouses
      ?.firstWhereOrNull((wh) => wh.warehouse?.id == warehouseId);

  final hasCurrentWarehouse = currentWarehouse != null;
  final isZeroQuantity = currentWarehouse?.quantity == 0;

  if (_isLoading) {
    return Container(
      height: 0,
      color: Colors.transparent,
    );
  }

  return Container(
    color: ThemeColors.white,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommonTextButton(
                
                size: 15,
                buttonText: !hasCurrentWarehouse
                    ? localizations.publish
                    : isZeroQuantity
                        ? 'Опубликовать заново'
                        : localizations.from_sale,
                textColor: ThemeColors.blackWithPath,
                onTap: () {
                  if (!hasCurrentWarehouse) {
                    _showPublishConfirmationDialogIsManager(context, true);
                  } else if (isZeroQuantity) {
                    _showPublishConfirmationDialogIsManager(context, false);
                  } else {
                    _showConfirmationDialogIsManager(context);
                  }
                },
                bgColor: !hasCurrentWarehouse || isZeroQuantity
                    ? ThemeColors.green
                    : ThemeColors.grey2,
              ),
            ),
            if (hasCurrentWarehouse && !isZeroQuantity) ...[
              const SizedBox(width: 10),
              Expanded(
                child: CommonTextButton(
                  buttonText: 'Изменить количество',
                  size: 15,
                  onTap: () async {
                    _showPublishConfirmationDialogIsManager(context, false);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}


  void _showPublishConfirmationDialog(BuildContext context) {
    final localizations = S.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.confirmation,
            style: const TextStyle(fontSize: 19),
          ),
          content: Text(localizations.publish_confirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                localizations.cancel,
                style: const TextStyle(color: ThemeColors.blackWithPath),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _publishProduct(context);
              },
              child: Text(
                localizations.confirm,
                style: const TextStyle(color: ThemeColors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _publishProduct(BuildContext context) async {
    final localizations = S.of(context);
    try {
      final statusChangeService = StatusChangeService();
      await statusChangeService.updateProductStatus(
        context: context,
        id: widget.productId,
        status: 'active',
      );
      setState(() {
        _status = 'active';
      });
      print(localizations.product_published);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.product_published)),
      );
    } catch (e) {
      print('${localizations.error}: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${localizations.error}: $e")),
      );
    }
  }

  void _showPublishConfirmationDialogIsManager(BuildContext context, bool public) {
  final localizations = S.of(context);
  int? quantity;
  final warehouseId = context.read<GlobalProvider>().warehouseId;
  final currentWarehouse = _product?.warehouses
      ?.firstWhereOrNull((wh) => wh.warehouse?.id == warehouseId);
  final warehousesQuantity = currentWarehouse?.quantity;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder( // <--- важно: для локального setState внутри bottomSheet
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 40,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Введите количество товара',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                QuantityInputField(
                  key: const ValueKey('quantity_input'),
                  initialValue: warehousesQuantity ?? 1,
                  onChanged: (value) {
                    quantity = value;
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: CustomButton(
                    isLoading: _isLoading,
                    text: public ? localizations.publish : localizations.confirm,
                    onPressed: () async {
                      if (quantity == null || quantity! <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.empty),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setModalState(() => _isLoading = true); // показать лоадер

                      try {
                        if (public) {
                          await _publishProductToWarehouses(context, quantity!);
                        } else {
                          await _updateWarehousesQuantity(context, quantity!);
                        }

                        Navigator.of(context).pop(); // закрыть bottom sheet
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${localizations.error}: $e")),
                        );
                      } finally {
                        setModalState(() => _isLoading = false); // скрыть лоадер
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      );
    },
  );
}


    Future<void> _publishProductToWarehouses(BuildContext context, int quantity) async {
    final localizations = S.of(context);
          final warehouseId = context.read<GlobalProvider>().warehouseId;

    try {

      final warehousesService = WarehouseService();
      await warehousesService.createWarehouseProduct(
         context,
         quantity,
         _product?.id ?? '',
         warehouseId ?? ''
    
      );

      await _fetchProductDetails();


// setState(() {
//   _status = 'active';
// });

      print(localizations.product_published);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.product_published), backgroundColor: Colors.green,),
      );
    } catch (e) {
      print('${localizations.error}: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${localizations.error}: $e")),
      );
    }
  }

      Future<void> _updateWarehousesQuantity(BuildContext context, int quantity) async {
    final localizations = S.of(context);
          final warehouseId = context.read<GlobalProvider>().warehouseId;

    try {
      //  await _showLoader(context);
      final warehousesService = WarehouseService();
      await warehousesService.updateWarehouseProductQuantity(
         context,
         quantity.toString(),
         _product?.id ?? '',
         warehouseId ?? ''
    
      );

      await _fetchProductDetails();
      setState(() {
        _status = 'active';
      });

    // Navigator.of(context).pop(); 

      print(localizations.product_published);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(localizations.success), backgroundColor: Colors.green,),
      // );
    } catch (e) {
      print('${localizations.error}: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${localizations.error}: $e")),
      );
    }
  }


  void _showConfirmationDialog(BuildContext context) {
    final localizations = S.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.confirmation,
            style: const TextStyle(fontSize: 19),
          ),
          content: Text(localizations.remove_sale_confirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                localizations.cancel,
                style: const TextStyle(color: ThemeColors.blackWithPath),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _updateProductStatus(context);
              },
              child: Text(
                localizations.confirm,
                style: const TextStyle(color: ThemeColors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

   void _showConfirmationDialogIsManager(BuildContext context) {
    final localizations = S.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.confirmation,
            style: const TextStyle(fontSize: 19),
          ),
          content: Text(localizations.remove_sale_confirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                localizations.cancel,
                style: const TextStyle(color: ThemeColors.blackWithPath),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProductInWarehouses(context);
              },
              child: Text(
                localizations.confirm,
                style: const TextStyle(color: ThemeColors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

    Future<void> _deleteProductInWarehouses(BuildContext context) async {
    final localizations = S.of(context);
          final warehouseId = context.read<GlobalProvider>().warehouseId;


    try {
      
      final warehousesService = WarehouseService();
      await warehousesService.updateWarehouseProductQuantity(
        context,
        '0',
        _product?.id ?? '',
        warehouseId ?? '',

      );

      _fetchProductDetails();
      // setState(() {
      //   _status = 'inactive';
      // });
      print(localizations.product_removed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.product_removed)),
      );
    } catch (e) {
      print('${localizations.error}: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${localizations.error}: $e")),
      );
    }
  }

  Future<void> _showLoader(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(color: ThemeColors.orange),
    ),
  );
}


  Future<void> _updateProductStatus(BuildContext context) async {
    final localizations = S.of(context);
    try {
      final statusChangeService = StatusChangeService();
      await statusChangeService.updateProductStatus(
        context: context,
        id: widget.productId,
        status: 'inactive',
      );
      setState(() {
        _status = 'inactive';
      });
      print(localizations.product_removed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.product_removed)),
      );
    } catch (e) {
      print('${localizations.error}: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${localizations.error}: $e")),
      );
    }
  }
}
