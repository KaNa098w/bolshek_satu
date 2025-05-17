import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bolshek_pro/app/pages/home/cross_number_screen.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/add_variant_widget.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/color_picker_widget.dart';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/app/widgets/quantity_widget.dart';
import 'package:bolshek_pro/app/widgets/textfield_widget.dart';
import 'package:bolshek_pro/app/widgets/warehouses_entrty.dart';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/models/warehouse_response.dart';
import 'package:bolshek_pro/core/service/cross_number_service.dart';
import 'package:bolshek_pro/core/service/images_service.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/service/properties_service.dart';
import 'package:bolshek_pro/core/service/tags_service.dart';
import 'package:bolshek_pro/core/service/variants_service.dart';
import 'package:bolshek_pro/core/service/warehouse_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Для FilteringTextInputFormatter
import 'package:provider/provider.dart';
import 'package:bolshek_pro/generated/l10n.dart';

class CharacteristicsTab extends StatefulWidget {
  const CharacteristicsTab({Key? key}) : super(key: key);

  @override
  _CharacteristicsTabState createState() => _CharacteristicsTabState();
}

class _CharacteristicsTabState extends State<CharacteristicsTab>
    with AutomaticKeepAliveClientMixin {
  // Значения свойств сохраняются в виде строки, преобразование происходит при отправке.
  Map<String, String> _propertyValues = {};
  ValueNotifier<List<PropertyItems>> propertiesNotifier = ValueNotifier([]);
  ValueNotifier<double> uploadProgressNotifier = ValueNotifier(0.0);
  bool isLoading = true;
  Map<String, bool> _propertyErrors = {};
  Map<String, bool> _fieldErrors = {};
  WarehouseService _warehouseService = WarehouseService();
  WarehouseResponse? war;
  WarehouseItem? _selectedWarehouse;
  int _selectedQuantity = 1;
  
   final List<WarehouseEntry> _entries = [ WarehouseEntry() ];

   bool _canAddMore() =>
    (war?.items.length ?? 0) > _selectedWarehouseIds().length;

  Set<String> _selectedWarehouseIds({int? exceptIdx}) {
  return _entries.asMap().entries
      .where((e) =>
          e.value.warehouse != null &&
          (exceptIdx == null || e.key != exceptIdx))
      .map((e) => e.value.warehouse!.id)
      .toSet();
}

  @override
  bool get wantKeepAlive => true; // Сохраняем состояние

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categoryId = context.watch<GlobalProvider>().selectedCategoryId;
    if (categoryId != null) {
      _loadProperties(categoryId);
    }
    _loadWarehouses();
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
      _showError('${S.of(context).error_loading_properties}: $e');
    }
  }
Future<void> _loadWarehouses() async {
  final permissions = context.read<GlobalProvider>().permissions;
  if (!permissions.contains('warehouse_read')) {
    return;
  }

  try {
    final orgId = context.read<GlobalProvider>().organizationId;
    final response = await _warehouseService.getWarehouses(context, orgId ?? '');
    setState(() {
      war = response;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    _showError('${S.of(context).error_loading_properties}: $e');
  }
}

  /// Преобразование значения свойства в строку в зависимости от типа
  dynamic _convertPropertyValue(String type, String value) {
    switch (type) {
      case 'boolean':
        return value.toLowerCase() == 'true';
      case 'number':
        return int.tryParse(value) ?? 0;
      case 'float':
        return double.tryParse(value) ?? 0.0;
      case 'color':
        return value; // Например, HEX-код
      case 'string':
      default:
        return value;
    }
  }

  void _showWarehouses(int idx) {
  if (war == null || war!.items.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).empty)),
    );
    return;
  }

    final busy = _selectedWarehouseIds(exceptIdx: idx);
  final options = war!.items.where((w) => !busy.contains(w.id)).toList();

  if (options.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Все склады выбран')),
    );
    return;
  }


  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5, // 60% высоты экрана
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).your_warehouse,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:ListView.separated(
      itemCount: options.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final wh = options[index];
        return ListTile(
          title: Text(wh.name),
          subtitle: Text(
            wh.address?.address?.replaceFirst(RegExp(r'^Казахстан,?\s*'), '') ??
                '',
          ),
          onTap: () {
            setState(() => _entries[idx].warehouse = wh);
            Navigator.pop(context);
          },
        );
      },
    ),
            ),
          ],
        ),
      ),
    ),
  );
}


  void _validateFields() {
    _propertyErrors.clear();
    _fieldErrors.clear();

    // Валидация свойств
    propertiesNotifier.value.forEach((property) {
      final propertyId = property.id ?? '';
      final value = _propertyValues[propertyId] ?? '';
      _propertyErrors[propertyId] = value.isEmpty;
    });

    // Валидация ключевых полей
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

    setState(() {});
  }

  bool _areAllFieldsValid() {
    _validateFields();
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
          title: Text(S.of(context).error),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
  }

  void _createProduct() async {
    if (!_areAllFieldsValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).fill_all_fields)),
      );
      return;
    }
    try {
      final authProvider = context.read<GlobalProvider>();
      // Инициализация прогресса загрузки
      const totalSteps = 5.0;
      ValueNotifier<double> uploadProgressNotifier = ValueNotifier(0.0);
      ValueNotifier<List<String>> completedStepsNotifier = ValueNotifier([]);
      ValueNotifier<String> currentStepNotifier =
          ValueNotifier(S.of(context).initialization);
      ValueNotifier<int> dotsNotifier = ValueNotifier(0);

      Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (dotsNotifier.value >= 3) {
          dotsNotifier.value = 0;
        } else {
          dotsNotifier.value += 1;
        }
      });

      // Диалог загрузки
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  S.of(context).creating_product,
                  style: const TextStyle(fontSize: 18),
                ),
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
                                strokeWidth: 7.0,
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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentStep,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: dotsNotifier,
                              builder: (context, dots, child) {
                                return Text(
                                  '${'.' * dots}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ],
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
      final crossNumberService = CrossNumberGenerateService();

      // 1. Создание продукта
      currentStepNotifier.value = S.of(context).creating_product;
      final productName = authProvider.name ?? S.of(context).not_specified;
      final brandId = authProvider.brandId ?? '';
      final categoryId = authProvider.selectedCategoryId ?? '';
      final deliveryType = authProvider.deliveryType;
      final vendorCode = authProvider.vendorCode;
      final descriptionText = authProvider.descriptionText ?? '';
      final carMappings = context.read<GlobalProvider>().carMappings;
      String firstCrossNumber = '';
      String firstVehicleId = '';
      if (carMappings.isNotEmpty) {
        firstCrossNumber = carMappings.first['oem'] ?? '';
        firstVehicleId = carMappings.first['vehicleId'] ?? '';
      }
      final response = await ProductService().createProduct(
        context,
        productName,
        productName.toLowerCase().replaceAll(' ', '-'),
        brandId,
        deliveryType,
        categoryId,
        vendorCode,
        descriptionText,
        firstCrossNumber,
        firstVehicleId,
        authProvider.price,
        authProvider.kind,
        authProvider.sku,
        authProvider.manufacturerId ?? '',
      );

      // 3. Создание варианта товара

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String productId = responseData['id'] ?? '';
      if (productId.isEmpty) {
        throw Exception(S.of(context).product_id_not_found);
      }
            uploadProgressNotifier.value += 1.0 / totalSteps;
      completedStepsNotifier.value.add(S.of(context).product_created);

      // 3. Создание склада товара

    final permissions = context.read<GlobalProvider>().permissions;
final hasWarehouseAccess = permissions.contains('warehouse_read');
// после получения productId…
if (hasWarehouseAccess)
for (final e in _entries) {
  await WarehouseService().createWarehouseProduct(
    context,
    e.qty,
    productId,
    e.warehouse!.id,           // warehouse гарантирован валидным
  );
}
uploadProgressNotifier.value += 1.0 / totalSteps;
completedStepsNotifier.value.add('Склады добавлены');




      

      // 2. Загрузка фотографий
      currentStepNotifier.value = S.of(context).uploading_photos;
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
      completedStepsNotifier.value.add(S.of(context).photos_uploaded);

      final List<Map<String, dynamic>> crossNumberGenerations = [];
      for (var mapping in carMappings) {
        if ((mapping['oem'] as String?)?.isNotEmpty == true &&
            (mapping['vehicleId'] as String?)?.isNotEmpty == true) {
          crossNumberGenerations.add({
            "crossNumber": mapping['oem'],
            "vehicleGenerationId": mapping['vehicleId'],
          });
        }
        final List<dynamic> alternatives =
            mapping['alternatives'] as List<dynamic>? ?? [];
        for (var alt in alternatives) {
          final altId = alt['id'] as String? ?? '';
          if (altId.isNotEmpty) {
            crossNumberGenerations.add({
              "crossNumber": alt['crossNumber'] ?? '',
              "vehicleGenerationId": altId,
            });
          }
        }
      }
      await crossNumberService.generateCrossNumber(
        context: context,
        productId: productId,
        crossNumberGenerations: crossNumberGenerations,
      );

      // // 3. Создание варианта товара
      // currentStepNotifier.value = S.of(context).creating_variant;
      // await VariantsService().createProductVariant(context,
      //     productId: productId,
      //     priceAmount: authProvider.price,
      //     sku: authProvider.sku,
      //     manufacturerId: authProvider.manufacturerId ?? '',
      //     kind: authProvider.kind ?? 'original',
      //     discountedAmount: 0,
      //     discountedPersent: 0);
      // uploadProgressNotifier.value += 1.0 / totalSteps;
      // completedStepsNotifier.value.add(S.of(context).variant_created);

      // if (authProvider.tagsId != null && authProvider.tagsId != '') {
      //   currentStepNotifier.value = S.of(context).creating_tags;
      //   await TagsService()
      //       .createTags(context, authProvider.tagsId ?? '', productId);
      //   uploadProgressNotifier.value = 1.0;
      //   completedStepsNotifier.value.add(S.of(context).tags_saved);
      // } else {
      //   currentStepNotifier.value = S.of(context).tags_empty;
      // }

      // 4. Отправка свойств
      currentStepNotifier.value = S.of(context).saving_properties;
      for (final property in propertiesNotifier.value) {
        final propertyId = property.id ?? '';
        final type = property.type ?? 'string';
        final rawValue = _propertyValues[propertyId] ?? '';
        if (rawValue.isNotEmpty) {
          final convertedValue = _convertPropertyValue(type, rawValue);
          await propertiesService.createProductProperties(
            context,
            productId: productId,
            propertyId: propertyId,
            value: convertedValue,
          );
        }
      }
      uploadProgressNotifier.value = 1.0;
      completedStepsNotifier.value.add(S.of(context).properties_saved);

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
      authProvider.clearProductData();

      Navigator.pop(context);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text(S.of(context).product_created_successfully),
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
                child: Text(
                  S.of(context).go_to_products,
                  style: const TextStyle(color: ThemeColors.orange),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      Navigator.pop(context);
      print('${S.of(context).error}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissions = context.read<GlobalProvider>().permissions;
final hasWarehouseAccess = permissions.contains('warehouse_read');

    final displayValue = (context.read<GlobalProvider>().carMappings.isNotEmpty)
        ? context.read<GlobalProvider>().carMappings.map((mapping) {
            final brand = mapping['brandName'] ?? '';
            final oem = mapping['oem'] ?? '';
            final firstName = brand.split(' ').first;
            return oem.isNotEmpty ? '$firstName ($oem)' : firstName;
          }).join(', ')
        : S.of(context).choose_vehicle;
    // final warehouseValue = war?.items.first.name;
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: ThemeColors.grey4,
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdownField(
              title: S.of(context).vehicle_compatibility,
              value: displayValue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CrossNumberScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            if (hasWarehouseAccess)
Column(
  children: [
    ..._entries.asMap().entries.map((e) {
      final i = e.key;
      final entry = e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Expanded(
              child: CustomDropdownField(
                title: S.of(context).your_warehouse,
                value: entry.warehouse?.name ?? S.of(context).choose,
                onTap: () => _showWarehouses(i),          // ← индекс
              ),
            ),
            const SizedBox(width: 10),
            QuantityInputField(
              initialValue: entry.qty,
              onChanged: (v) => entry.qty = v,
            ),
            // крестик, но не у первой строки
            if (_entries.length > 1)
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: GestureDetector(
                  onTap: () => setState(() => _entries.removeAt(i)),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ),
          ],
        ),
      );
    }),
if (_canAddMore())
  Center(
    child: Container(
      width: 500,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () {
          if (!_canAddMore()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Все склады выбран')),
            );
            return;
          }
          setState(() => _entries.add(WarehouseEntry()));
        },
        child: const Text('Добавить ещё склады +', style: TextStyle(color: ThemeColors.grey5),),
      ),
    ),
  ),

  ],
),


            const SizedBox(height: 12),

            ValueListenableBuilder<List<PropertyItems>>(
              valueListenable: propertiesNotifier,
              builder: (context, properties, child) {
                if (properties.isEmpty) {
                  return Center(
                      child: Text(S.of(context).properties_not_found));
                }
                return Column(
                  children: properties.map((property) {
                    final propertyId = property.id ?? '';
                    final hasError = _propertyErrors[propertyId] ?? false;
                    final title = property.unit == null
                        ? property.name
                        : '${property.name} (${property.unit})';
                    switch (property.type) {
                      case 'boolean':
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title ?? ''),
                              Checkbox(
                                value: _propertyValues[propertyId]
                                        ?.toLowerCase() ==
                                    'true',
                                onChanged: (value) {
                                  setState(() {
                                    _propertyValues[propertyId] =
                                        value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      case 'number':
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomEditableField(
                              title: title ?? '',
                              value:
                                  _propertyValues[propertyId]?.toString() ?? '',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                _propertyValues[propertyId] = value;
                              },
                            ),
                            if (hasError)
                              Text(
                                S.of(context).enter_number,
                                style: const TextStyle(color: Colors.red),
                              ),
                            const SizedBox(height: 12),
                          ],
                        );
                      case 'float':
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomEditableField(
                              title: title ?? '',
                              value:
                                  _propertyValues[propertyId]?.toString() ?? '',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*')),
                              ],
                              onChanged: (value) {
                                _propertyValues[propertyId] = value;
                              },
                            ),
                            if (hasError)
                              Text(
                                S.of(context).enter_number,
                                style: const TextStyle(color: Colors.red),
                              ),
                            const SizedBox(height: 12),
                          ],
                        );
                      case 'string':
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomEditableField(
                              title: title ?? '',
                              value: _propertyValues[propertyId] ?? '',
                              onChanged: (value) {
                                _propertyValues[propertyId] = value;
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      case 'color':
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
                              Text(
                                S.of(context).choose_color,
                                style: const TextStyle(color: Colors.red),
                              ),
                            const SizedBox(height: 12),
                          ],
                        );
                      default:
                        return const SizedBox();
                    }
                  }).toList(),
                );
              },
            ),
            ProductDetailsWidget(),
            const SizedBox(height: 12),
            Center(
              child: CustomButton(
                text: S.of(context).create_product,
                onPressed: _createProduct,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
