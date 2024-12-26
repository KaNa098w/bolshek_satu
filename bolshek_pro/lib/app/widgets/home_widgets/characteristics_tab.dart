import 'dart:convert';
import 'package:bolshek_pro/app/widgets/colors_enum_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/editable_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/add_variant_widget.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/category_colors_widget.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/color_picker_widget.dart';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/core/service/images_service.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/service/variants_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/service/properties_service.dart';
import 'package:bolshek_pro/app/widgets/custom_input_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';

class CharacteristicsTab extends StatefulWidget {
  const CharacteristicsTab({Key? key}) : super(key: key);

  @override
  _CharacteristicsTabState createState() => _CharacteristicsTabState();
}

class _CharacteristicsTabState extends State<CharacteristicsTab>
    with AutomaticKeepAliveClientMixin {
  Map<String, String> _propertyValues = {};
  ValueNotifier<List<PropertyItems>> propertiesNotifier = ValueNotifier([]);
  bool isLoading = true;

  @override
  bool get wantKeepAlive => true; // Гарантирует сохранение состояния

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categoryId = context.watch<GlobalProvider>().selectedCategoryId;

    if (categoryId != null) {
      _loadProperties(categoryId);
    }
  }

  Future<void> _loadProperties(String categoryId) async {
    try {
      final response =
          await PropertiesService().fetchProperties(context, categoryId);
      propertiesNotifier.value = response.items ?? [];
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Ошибка загрузки свойств: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  void _createProduct() async {
    try {
      final authProvider = context.read<GlobalProvider>();
      print('descriptionText: ${authProvider.descriptionText}');
      print('categoryId: ${authProvider.selectedCategoryId}');
      print('brandId: ${authProvider.brandId}');
      print('images: ${authProvider.images}');
      print('_propertyValues: $_propertyValues');
      showDialog(
        context: context,
        barrierDismissible: false, // Запретить закрытие по клику вне окна
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: ThemeColors.grey4,
            ),
          );
        },
      );

      final imagesService = ImagesService();
      final propertiesService = PropertiesService();

      // Данные для создания продукта
      final productName = authProvider.name ?? 'Не указано';
      final brandId = authProvider.brandId ?? '';
      final categoryId = authProvider.selectedCategoryId ?? '';
      final deliveryType = authProvider.deliveryType;
      final vendorCode = authProvider.vendorCode;
      final descriptionText = authProvider.descriptionText ?? '';

      // Создание продукта
      final response = await ProductService().createProduct(
          context,
          productName,
          productName.toLowerCase().replaceAll(' ', '-'), // slug
          brandId,
          deliveryType,
          categoryId,
          vendorCode,
          descriptionText!);

      // Парсинг ответа
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String productId = responseData['id'] ?? '';

      if (productId.isEmpty) {
        throw Exception('ID продукта не найден в ответе');
      }

      // Загрузка фотографий
      final images = authProvider.images;
      for (final image in images) {
        await imagesService.createProductImage(
          context,
          productId: productId,
          imageSize: image['size'].toDouble(),
          imageData: image['data'],
          imageName: image['name'],
        );
      }

      // Создание варианта
      final price = authProvider.price;
      final sku = authProvider.sku;
      final manufacturerId = authProvider.manufacturerId;

      await VariantsService().createProductVariant(
        context,
        productId: productId,
        priceAmount: price,
        sku: sku,
        manufacturerId: manufacturerId ?? '',
      );

      // Отправка свойств продукта
      for (final entry in _propertyValues.entries) {
        final propertyId = entry.key; // ID свойства
        final value = entry.value; // Значение свойства

        if (value.isNotEmpty) {
          await propertiesService.createProductProperties(
            context,
            productId: productId,
            propertyId: propertyId,
            value: value,
          );
        }
      }

      authProvider.setCategoryId(null);
      authProvider.setName(null);
      authProvider.setBrandId(null);
      authProvider.setDescriptionText('');
      authProvider.setVendorCode('');
      authProvider.setPrice(0.0);
      authProvider.setSku('');
      authProvider.clearImages();
      authProvider.setPropertyValues({});

      // Закрыть индикатор загрузки
      Navigator.pop(context);

      // Уведомление об успехе с кнопкой перехода
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Успех'),
            content: const Text('Товар успешно создан!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Закрыть диалог
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainControllerNavigator(),
                      settings:
                          const RouteSettings(arguments: 2), // Индекс "Товары"
                    ),
                    (route) => false, // Удалить все предыдущие маршруты
                  );
                },
                child: const Text(
                  'Перейти к товарам',
                  style: TextStyle(color: ThemeColors.orange),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Закрыть индикатор загрузки
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Для работы AutomaticKeepAliveClientMixin

    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: ThemeColors.grey4,
      ));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Основные характеристики',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Используем ValueListenableBuilder
            ValueListenableBuilder<List<PropertyItems>>(
              valueListenable: propertiesNotifier,
              builder: (context, properties, child) {
                if (properties.isEmpty) {
                  return const Center(child: Text('Свойства не найдены'));
                }
                return Column(
                  children: properties.map((property) {
                    if (property.type == 'color') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   property.name ?? 'Цвет',
                          //   style: const TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          // const SizedBox(height: 8),
                          ColorPicker(
                            propertyId: property.id ?? '',
                            onColorSelected: (selectedColor) {
                              setState(() {
                                _propertyValues[property.id ?? ''] =
                                    selectedColor;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EditableDropdownField(
                            title: property.unit == null
                                ? '${property.name}'
                                : '${property.name} (${property.unit})',
                            value: _propertyValues[property.id ?? ''] ?? '',
                            hint: 'Введите значение',
                            onChanged: (value) {
                              _propertyValues[property.id ?? ''] = value;
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }
                  }).toList(),
                );
              },
            ),

            ProductDetailsWidget(),
            const SizedBox(height: 12),
            Center(
              child: CustomButton(
                text: 'Создать товар',
                onPressed: () {
                  _createProduct();
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
