import 'package:bolshek_pro/app/pages/product/product_change_page.dart';
import 'package:bolshek_pro/app/widgets/full_screen_image_widget.dart';
import 'package:bolshek_pro/app/widgets/widget_from_bolshek/common_text_button.dart';
import 'package:bolshek_pro/app/widgets/widget_from_bolshek/theme_text_style.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/service/status_change_service.dart';
import 'package:bolshek_pro/core/service/variants_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String? _manufacturerId;

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
        _manufacturerId = product.variants?.first.manufacturerId;
        _variant_kind = product.variants?.first.kind;
        _variants_lenght = product.variants?.length;
        _variants_kod = product.variants?.first?.sku!;
        _manufacturers_name = product.variants?.first.manufacturer?.name;
        _articul = product?.vendorCode;
        _status = product.status;
        _variantId = product.variants?.first.id;
        // Название товара
        _productName = product.name ?? "Название отсутствует";

        // Описание товара
        _productDescription = product.description?.blocks?.isNotEmpty == true
            ? product.description?.blocks?.first.data?.text ??
                "Описание отсутствует"
            : "Описание отсутствует";

        // Список изображений
        _productImages = product.images?.map((e) => e.url ?? "").toList() ?? [];

        // Список характеристик
        _productCharacteristics = product.properties?.map((prop) {
              return {
                "title": prop.property?.name ?? "Название отсутствует",
                "value": prop.value ?? "Значение отсутствует",
              };
            }).toList() ??
            [];

        // Цена товара (берется из первого варианта)
        _productPrice = product.variants?.isNotEmpty == true
            ? product.variants?.first.price?.amount?.toDouble()
            : 0.0;

        // Устанавливаем, что загрузка завершена
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка при загрузке данных о товаре: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 32, // Уменьшаем высоту AppBar
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 25, // Уменьшаем размер иконки
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Действие для кнопки назад
              },
              constraints: const BoxConstraints(
                minWidth: 32, // Минимальная ширина кнопки
                minHeight: 32, // Минимальная высота кнопки
              ),
              padding: EdgeInsets.zero, // Убираем дополнительные отступы
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: ThemeColors.orange,
            ))
          : _buildProductDetails(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductDetails() {
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
          ],
        ),
      ),
    );
  }

  Widget _buildProductImages() {
    return _productImages.isNotEmpty
        ? GestureDetector(
            onTap: () {
              if (_productImages.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      imageUrl: _productImages[
                          0], // Вы можете изменить индекс или передать нужное изображение
                    ),
                  ),
                );
              } else {
                print('Нет доступных изображений для отображения.');
              }
            },
            child: Center(
              child: Container(
                width: 365,
                height: 365,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(12), // Более овальная форма
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: const Offset(0, 3), // Тень под изображением
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias, // Обрезка изображения по границе
                child: Image.network(
                  _productImages.first,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          )
        : Center(
            child: Container(
              width: 365,
              height: 365,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), // Более овальная форма
                color: Colors.grey[200],
              ),
              child: const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
          );
  }

  Widget _buildProductNameAndActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            _productName ?? "Название товара отсутствует",
            style: ThemeTextMontserratBold.size21.copyWith(
              fontSize: 16,
              color: ThemeColors.black,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                // Реализуйте добавление в избранное
                print('Добавить в избранное');
              },
              icon: Icon(Icons.favorite_border, color: Colors.grey[600]),
            ),
            IconButton(
              onPressed: () {
                // Реализуйте логику для "Поделиться"
                print('Поделиться товаром');
              },
              icon: Icon(Icons.share, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _productPrice != null
                  ? "${_formatPriceWithSpaces(_productPrice! / 100)} ₸"
                  : "Цена отсутствует",
              style: ThemeTextMontserratBold.size21.copyWith(
                fontSize: 17,
                color: ThemeColors.grey5,
              ),
            ),
            TextButton(
              onPressed: () {
                _showPriceEditDialog(widget.productId, _variantId!);
                // Открываем диалог для редактирования цены
              },
              child: Text(
                "Изменить цену",
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeColors.orange, // Цвет текста кнопки
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // SizedBox(
            //   width: 1,
            // ),
            // Text(
            //   'Артикул: $_articul',
            //   style: ThemeTextMontserratBold.size21.copyWith(
            //       fontSize: 12,
            //       color: ThemeColors.black,
            //       fontWeight: FontWeight.w400),
            // ),
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
                    width: 105, // Фиксированная ширина
                    height: 25, // Фиксированная высота
                    decoration: BoxDecoration(
                      color: ThemeColors.orange,
                      borderRadius: BorderRadius.circular(5), // Квадратный вид
                      border: Border.all(color: ThemeColors.orange),
                    ),
                    child: Center(
                      child: Text(
                        _variant_kind == 'original'
                            ? 'Оригинал'
                            : _variant_kind == 'sub_original'
                                ? 'Под оригинал'
                                : _variant_kind ?? '',
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
            Row(
              children: [
                Text(
                  'Артикул: $_articul',
                  style: ThemeTextMontserratBold.size21.copyWith(
                      fontSize: 12,
                      color: ThemeColors.black,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  String _formatPriceWithSpaces(double price) {
    final formatter = NumberFormat("#,###", "ru_RU"); // Формат с пробелами
    return formatter
        .format(price)
        .replaceAll(',', ' '); // Заменяем запятые на пробелы
  }

  /// Метод для форматирования цены без лишних нулей
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

  void _showPriceEditDialog(String productId, String variantId) {
    final TextEditingController _priceController = TextEditingController(
      text: _productPrice != null ? _formatPrice(_productPrice! / 100) : "",
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
                  // Конвертируем цену в копейки
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
                    // Вызываем сервис обновления цены
                    final variantsService = VariantsService();
                    await variantsService.updateProductVariant(
                      context,
                      productId: productId,
                      variantId: variantId,
                      newAmount: newPrice,
                      sku: _variants_kod,
                      manufacturerId: _manufacturerId,
                    );

                    setState(() {
                      _productPrice = newPrice; // Обновляем локальное состояние
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
                    // Закрываем индикатор загрузки
                    Navigator.of(context).pop();
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

  /// Метод для показа диалога изменения цены

  Widget _buildProductDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Описание",
          style: ThemeTextMontserratBold.size21.copyWith(
            color: ThemeColors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _productDescription ?? "Описание отсутствует",
          style: ThemeTextInterRegular.size11.copyWith(
            fontSize: 14,
            color: ThemeColors.grey8,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCharacteristics(String productCode, String brandName) {
    // Добавление Код товара и Название бренда в начале списка
    final updatedCharacteristics = [
      {
        "title": "Код товара",
        "value": productCode.isNotEmpty ? productCode : "Не указан",
      },
      {
        "title": "Производитель",
        "value": brandName.isNotEmpty ? brandName : "Не указан",
      },
      ..._productCharacteristics, // Остальные характеристики
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Характеристики",
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  characteristic["title"]!,
                  style: ThemeTextInterRegular.size11.copyWith(
                    fontSize: 14,
                    color: ThemeColors.grey8,
                  ),
                ),
                Text(
                  characteristic["value"]!,
                  style: ThemeTextInterRegular.size11.copyWith(
                    fontSize: 14,
                    color: ThemeColors.black,
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
    if (_isLoading) {
      // Показываем пустой контейнер или индикатор загрузки, пока данные загружаются
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
              // Кнопка: "Снять с продажи" или "Опубликовать"
              Expanded(
                child: CommonTextButton(
                  size: 15,
                  buttonText: _status == 'inactive'
                      ? 'Опубликовать'
                      : Constants.fromSale,
                  textColor: ThemeColors.blackWithPath,
                  onTap: () {
                    if (_status == 'inactive') {
                      // Если статус "inactive", отправляем запрос на публикацию
                      _showPublishConfirmationDialog(context);
                    } else {
                      // Если статус не "inactive", подтверждаем снятие с продажи
                      _showConfirmationDialog(context);
                    }
                  },
                  bgColor: _status == 'inactive'
                      ? ThemeColors.green
                      : ThemeColors.grey2,
                ),
              ),
              const SizedBox(width: 10),

              // Кнопка "Изменить товар"
              Expanded(
                child: CommonTextButton(
                  buttonText: Constants.changeProduct,
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

  void _showPublishConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Подтверждение',
            style: TextStyle(fontSize: 19),
          ),
          content: const Text('Вы уверены, что хотите опубликовать товар?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
              },
              child: const Text(
                'Отмена',
                style: TextStyle(color: ThemeColors.blackWithPath),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Закрываем диалог
                await _publishProduct(context);
              },
              child: const Text(
                'Да',
                style: TextStyle(color: ThemeColors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _publishProduct(BuildContext context) async {
    try {
      // Создаем экземпляр сервиса
      final statusChangeService = StatusChangeService();

      // Отправляем запрос для обновления статуса
      await statusChangeService.updateProductStatus(
        context: context,
        id: widget.productId, // ID продукта
        status: 'active', // Новый статус
      );

      // Обновляем статус локально
      setState(() {
        _status = 'active';
      });

      // Логика после успешного обновления
      print('Товар отправлен на публикацию');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Товар отправлен на публикацию')),
      );
    } catch (e) {
      // Обработка ошибки
      print('Ошибка при публикации товара: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: const Text('Вы уверены, что хотите снять товар с продажи?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Закрываем диалог
                await _updateProductStatus(context);
              },
              child: const Text('Да'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProductStatus(BuildContext context) async {
    try {
      // Создаем экземпляр сервиса
      final statusChangeService = StatusChangeService();

      // Отправляем запрос для обновления статуса
      await statusChangeService.updateProductStatus(
        context: context,
        id: widget.productId, // ID продукта
        status: 'inactive', // Новый статус
      );

      // Обновляем статус локально
      setState(() {
        _status = 'inactive'; // Устанавливаем статус как "inactive"
      });

      // Логика после успешного обновления
      print('Статус товара успешно обновлен на inactive');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Товар снят с продажи')),
      );
    } catch (e) {
      // Обработка ошибки
      print('Ошибка при обновлении статуса: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }
}
