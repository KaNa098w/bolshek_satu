import 'dart:async';
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
  ValueNotifier<double> uploadProgressNotifier = ValueNotifier(0.0);
  bool isLoading = true;
  Map<String, bool> _propertyErrors = {};
  Map<String, bool> _fieldErrors = {};

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

  void _validateFields() {
    _propertyErrors.clear(); // Сброс ошибок свойств
    _fieldErrors.clear(); // Сброс ошибок ключевых полей

    // Проверить свойства
    propertiesNotifier.value.forEach((property) {
      final propertyId = property.id ?? '';
      final value = _propertyValues[propertyId] ?? '';

      if (value.isEmpty) {
        _propertyErrors[propertyId] = true;
      } else {
        _propertyErrors[propertyId] = false;
      }
    });

    // Проверить ключевые поля
    final authProvider = context.read<GlobalProvider>();
    _fieldErrors['productName'] = (authProvider.name?.isEmpty ?? true);
    _fieldErrors['brandId'] = (authProvider.brandId?.isEmpty ?? true);
    _fieldErrors['deliveryType'] = (authProvider.deliveryType == null);
    _fieldErrors['categoryId'] =
        (authProvider.selectedCategoryId?.isEmpty ?? true);
    _fieldErrors['vendorCode'] = (authProvider.vendorCode?.isEmpty ?? true);
    _fieldErrors['descriptionText'] =
        (authProvider.descriptionText?.isEmpty ?? true);
    _fieldErrors['priceAmount'] =
        (authProvider.price == null || authProvider.price <= 0);
    _fieldErrors['sku'] = (authProvider.sku?.isEmpty ?? true);
    _fieldErrors['manufacturerId'] =
        (authProvider.manufacturerId?.isEmpty ?? true);

    setState(() {}); // Обновить интерфейс
  }

  bool _areAllFieldsValid() {
    _validateFields();

    // Если есть хотя бы одно поле или свойство с ошибкой, вернуть false
    final hasPropertyErrors =
        _propertyErrors.values.any((hasError) => hasError);
    final hasFieldErrors = _fieldErrors.values.any((hasError) => hasError);
    return !hasPropertyErrors && !hasFieldErrors;
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
    if (!_areAllFieldsValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return; // Остановить выполнение
    }

    try {
      final authProvider = context.read<GlobalProvider>();
      // print('descriptionText: ${authProvider.descriptionText}');
      // print('categoryId: ${authProvider.selectedCategoryId}');
      // print('brandId: ${authProvider.brandId}');
      // print('images: ${authProvider.images}');
      // print('_propertyValues: $_propertyValues');

      // Инициализация прогресса загрузки
      const totalSteps = 4.0; // Количество этапов
      ValueNotifier<double> uploadProgressNotifier = ValueNotifier(0.0);
      ValueNotifier<List<String>> completedStepsNotifier = ValueNotifier([]);
      ValueNotifier<String> currentStepNotifier =
          ValueNotifier('Инициализация');
      ValueNotifier<int> dotsNotifier = ValueNotifier(0);

      // Анимация для мигающих точек
      Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (dotsNotifier.value >= 3) {
          dotsNotifier.value = 0;
        } else {
          dotsNotifier.value += 1;
        }
      });

      // Отображение прогресса загрузки
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Создание товара'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ValueListenableBuilder<double>(
                          valueListenable: uploadProgressNotifier,
                          builder: (context, progress, child) {
                            return SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: progress,
                                color: ThemeColors.orange,
                                strokeWidth: 8.0,
                              ),
                            );
                          },
                        ),
                        ValueListenableBuilder<double>(
                          valueListenable: uploadProgressNotifier,
                          builder: (context, progress, child) {
                            return Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<String>(
                      valueListenable: currentStepNotifier,
                      builder: (context, currentStep, child) {
                        return ValueListenableBuilder<int>(
                          valueListenable: dotsNotifier,
                          builder: (context, dots, child) {
                            return Text(
                              '$currentStep${'.' * dots}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<List<String>>(
                      valueListenable: completedStepsNotifier,
                      builder: (context, completedSteps, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: completedSteps.map((step) {
                            return Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  step,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

      final imagesService = ImagesService();
      final propertiesService = PropertiesService();

      // 1. Создание продукта
      currentStepNotifier.value = 'Создание товара';
      final productName = authProvider.name ?? 'Не указано';
      final brandId = authProvider.brandId ?? '';
      final categoryId = authProvider.selectedCategoryId ?? '';
      final deliveryType = authProvider.deliveryType;
      final vendorCode = authProvider.vendorCode;
      final descriptionText = authProvider.descriptionText ?? '';

      final response = await ProductService().createProduct(
          context,
          productName,
          productName.toLowerCase().replaceAll(' ', '-'), // slug
          brandId,
          deliveryType,
          categoryId,
          vendorCode,
          descriptionText);

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String productId = responseData['id'] ?? '';

      if (productId.isEmpty) {
        throw Exception('ID продукта не найден в ответе');
      }
      uploadProgressNotifier.value += 1.0 / totalSteps;
      completedStepsNotifier.value.add('Товар создан');

      // 2. Загрузка фотографий
      currentStepNotifier.value = 'Загрузка фотографий';
      final images = authProvider.images;
      for (var i = 0; i < images.length; i++) {
        await imagesService.createProductImage(
          context,
          productId: productId,
          imageSize: images[i]['size'].toDouble(),
          imageData: images[i]['data'],
          imageName: images[i]['name'],
        );
        uploadProgressNotifier.value += (1.0 / totalSteps) / images.length;
      }
      completedStepsNotifier.value.add('Фотографии загружены');

      // 3. Создание варианта
      currentStepNotifier.value = 'Создание варианта товара';
      await VariantsService().createProductVariant(
        context,
        productId: productId,
        priceAmount: authProvider.price,
        sku: authProvider.sku,
        manufacturerId: authProvider.manufacturerId ?? '',
        kind: authProvider.kind ?? 'original',
      );
      uploadProgressNotifier.value += 1.0 / totalSteps;
      completedStepsNotifier.value.add('Вариант товара создан');

      // 4. Отправка свойств
      currentStepNotifier.value = 'Сохранение характеристик';
      for (final entry in _propertyValues.entries) {
        final propertyId = entry.key;
        final value = entry.value;

        if (value.isNotEmpty) {
          await propertiesService.createProductProperties(
            context,
            productId: productId,
            propertyId: propertyId,
            value: value,
          );
        }
      }
      uploadProgressNotifier.value = 1.0;
      completedStepsNotifier.value.add('Характеристики сохранены');

      // Очистка данных
      authProvider.setCategoryId(null);
      authProvider.setName(null);
      authProvider.setBrandId(null);
      authProvider.setDescriptionText('');
      authProvider.setVendorCode('');
      authProvider.setPrice(0.0);
      authProvider.setSku('');
      authProvider.clearImages();
      authProvider.setPropertyValues({});

      // Закрыть диалог загрузки
      Navigator.pop(context);

      // Уведомление об успехе
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: const Text('Успех'),
            content: const Text('Товар успешно создан!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainControllerNavigator(),
                      settings: const RouteSettings(arguments: 2),
                    ),
                    (route) => false,
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
      // Закрыть диалог загрузки
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
            // const Text(
            //   'Основные характеристики',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 20),
            ValueListenableBuilder<List<PropertyItems>>(
              valueListenable: propertiesNotifier,
              builder: (context, properties, child) {
                if (properties.isEmpty) {
                  return const Center(child: Text('Свойства не найдены'));
                }
                return Column(
                  children: properties.map((property) {
                    final propertyId = property.id ?? '';
                    final hasError = _propertyErrors[propertyId] ?? false;

                    if (property.type == 'color') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColorPicker(
                            propertyId: propertyId,
                            onColorSelected: (selectedColor) {
                              setState(() {
                                _propertyValues[propertyId] = selectedColor;
                              });
                            },
                          ),
                          if (hasError)
                            const Text(
                              'Выберите цвет',
                              style: TextStyle(color: Colors.red),
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
                            value: _propertyValues[propertyId] ?? '',
                            // hint: 'Введите значение',
                            onChanged: (value) {
                              _propertyValues[propertyId] = value;
                            },
                          ),
                          // if (hasError)
                          //   const Text(
                          //     'Заполните это поле',
                          //     style: TextStyle(color: Colors.red),
                          //   ),
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
