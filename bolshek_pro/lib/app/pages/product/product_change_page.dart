import 'dart:convert';
import 'dart:io';
import 'package:bolshek_pro/app/pages/home/cross_number_screen.dart';
import 'package:bolshek_pro/app/widgets/animation_rotation_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/app/widgets/editable_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/color_picker_widget.dart';
import 'package:bolshek_pro/app/widgets/home_widgets/hex_colors_widget.dart';
import 'package:bolshek_pro/app/widgets/textfield_widget.dart';
import 'package:bolshek_pro/core/models/category_response.dart' as category;
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/manufacturers_response.dart';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/models/tags_response.dart';
import 'package:bolshek_pro/core/service/brands_service.dart';
import 'package:bolshek_pro/core/service/category_service.dart';
import 'package:bolshek_pro/core/service/images_service.dart';
import 'package:bolshek_pro/core/service/maufacturers_service.dart';
import 'package:bolshek_pro/core/service/properties_service.dart';
import 'package:bolshek_pro/core/service/tags_service.dart';
import 'package:bolshek_pro/core/service/variants_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/core/models/product_responses.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductChangePage extends StatefulWidget {
  final String productId;
  final ProductService productService;

  const ProductChangePage({
    Key? key,
    required this.productId,
    required this.productService,
  }) : super(key: key);

  @override
  _ProductChangePageState createState() => _ProductChangePageState();
}

class _ProductChangePageState extends State<ProductChangePage> {
  ProductItems? _product;
  bool _isLoading = true;
  String? _errorMessage;
  final ImagePicker _imagePicker = ImagePicker();
  List<category.CategoryItems> categories = [];
  late List<BrandItems> _brands;
  final ManufacturersService _service = ManufacturersService();
  List<ManufacturersItems> _manufacturers = [];
  ManufacturersItems? _selectedManufacturer;
  final BrandsService _brandsService = BrandsService();
  bool isLoading = true;
  List<BrandItems> brands = [];
  String selectedBrand = '';
  String selectedCategory = '';
  String _productName = ''; // Хранит текущее значение имени товара
  Map<String, dynamic> _updatedFields = {}; // Хранит все изменённые данные
  ProductItems? _originalProduct;
  String? _selectedBrandId;
  List<Images>? _originalImages;
  final ImagesService _imagesService = ImagesService();
  String selectedType = '';
  Map<String, String> _propertyValues = {};
  ValueNotifier<List<PropertyItems>> propertiesNotifier = ValueNotifier([]);
  List<XFile> _newImages = []; // Новые изображения, добавленные пользователем
  List<String> _deletedImages = []; // URL удалённых изображений
  List<ItemsTags> _selectedTags = [];
  List<ItemsTags>? list_tags;
  Map<String, bool> _propertyErrors = {};

  final TagsService _tagsService = TagsService();
  List<ItemsTags> _tags = [];

  bool isLoadingCategories = true;
  bool _didInitialize = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchProduct();
  //   _loadTags();
  //   _loadManufacturers();
  //   _loadBrands();
  //   _selectedBrandId = _product?.brandId;
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitialize) {
      _fetchProduct();
      _loadTags();
      _loadManufacturers();
      _loadBrands();
      // _selectedBrandId = _product?.brandId;

      _didInitialize = true;
      //   if (_product!.kind!.isEmpty ?? false) {
      //     final variantKind = _product?.kind;
      //     selectedType = variantKind == 'original'
      //         ? S.of(context).original
      //         : variantKind == 'sub_original'
      //             ? S.of(context).sub_original
      //             : S.of(context).auto_disassembly;
      //   } else {
      //     selectedType = S.of(context).original; // Значение по умолчанию
      //   }
      //   _didInitialize = true;
      // }
    }
  }

  Future<void> _loadTags() async {
    try {
      final responseTags = await _tagsService.getTags(context);
      setState(() {
        _tags = responseTags.items ?? [];
      });
    } catch (e) {
      print(e);
    }
  }

  void handleTagUpdate(BuildContext context) async {
    // Собираем ID выбранных тегов в строку через запятую
    final String tagIds = _selectedTags.map((tag) => tag.id).join(',');
    // Получаем productId из виджета
    final String productId = widget.productId;

    try {
      await _tagsService.deleteAndCreate(context, tagIds, productId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).success)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showTags() {
    final local = S.of(context);
    if (_tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).empty)),
      );
      return;
    }

    // Локальная копия выбранных тегов для работы в модальном окне
    List<ItemsTags> tempSelectedTags = List.from(_selectedTags);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = ''; // Локальная переменная для поиска
        return StatefulBuilder(
          builder: (context, setStateModal) {
            // Фильтрация по поисковому запросу
            final filteredTags = _tags
                .where((tag) =>
                    tag.text != null &&
                    tag.text!.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            // Исключаем из списка доступных те теги, которые уже выбраны
            final availableTags = filteredTags.where((tag) {
              return !tempSelectedTags
                  .any((selectedTag) => selectedTag.id == tag.id);
            }).toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок и кнопка закрытия
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          local.choose_tags,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    if (tempSelectedTags.isNotEmpty) Text(local.productTags),
                    // Отображение выбранных тегов сверху в виде Chip-виджетов
                    if (tempSelectedTags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          spacing: 8.0,
                          alignment: WrapAlignment
                              .start, // Выравнивание по левому краю
                          children: tempSelectedTags.map((tag) {
                            return Chip(
                              label: Text(
                                tag.text ?? '',
                                style: TextStyle(
                                  color: tag.textColor != null
                                      ? HexColor(tag.textColor!)
                                      : Colors.black,
                                ),
                              ),
                              backgroundColor: tag.backgroundColor != null
                                  ? HexColor(tag.backgroundColor!)
                                  : Colors.white,
                              onDeleted: () {
                                setStateModal(() {
                                  tempSelectedTags.removeWhere(
                                    (selected) => selected.id == tag.id,
                                  );
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    if (availableTags.isNotEmpty) Text(local.availableTags),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8.0,
                          alignment: WrapAlignment
                              .start, // Выравнивание по левому краю
                          children: availableTags.map((tag) {
                            return ActionChip(
                              label: Text(
                                tag.text ?? local.no_name,
                                style: TextStyle(
                                  color: tag.textColor != null
                                      ? HexColor(tag.textColor!)
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: tag.backgroundColor != null
                                  ? HexColor(tag.backgroundColor!)
                                  : Colors.white,
                              onPressed: () {
                                setStateModal(() {
                                  tempSelectedTags.add(tag);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // Кнопка сохранения
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CustomButton(
                        onPressed: () {
                          setState(() {
                            _selectedTags = tempSelectedTags;
                            context.read<GlobalProvider>().setTagsId(
                                  _selectedTags
                                      .map((tag) => tag.id ?? '')
                                      .join(','),
                                );
                          });
                          handleTagUpdate(context);
                          Navigator.pop(context);
                        },
                        text: local.save,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTypeOptions() {
    final local = S.of(context);
    final typeOptions = [
      local.original,
      local.sub_original,
      local.auto_disassembly
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(local.choose_type),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: typeOptions.length,
                        itemBuilder: (context, index) {
                          final type = typeOptions[index];
                          return ListTile(
                            title: Text(type),
                            onTap: () {
                              // 1. Запоминаем выбранное значение «по-человечески»
                              setState(() {
                                selectedType = type;
                              });
                              // 2. Преобразуем его в нужный формат для API
                              final updatedKind = type == local.original
                                  ? 'original'
                                  : (type == local.sub_original
                                      ? 'sub_original'
                                      : 'disassemble');
                              // 3. Ставим значение во внутреннем объекте
                              _product?.kind = updatedKind;

                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  dynamic _convertPropertyValue(String type, String value) {
    switch (type) {
      case 'boolean':
        return value.toLowerCase() == 'true';
      case 'number':
        return int.tryParse(value) ?? 0;
      case 'float':
        return double.tryParse(value) ?? 0.0;
      case 'color':
        return value; // Для цвета оставляем строку (например, HEX-код)
      case 'string':
      default:
        return value;
    }
  }

  Map<String, dynamic> _getUpdatedFields() {
    final updatedFields = <String, dynamic>{};

    // Сравнение и добавление изменённых полей
    if (_product?.name != _originalProduct?.name) {
      updatedFields['name'] = _product?.name;
    }
    if (_product?.slug != _originalProduct?.slug) {
      updatedFields['slug'] = _product?.slug;
    }
    if (_product?.brandId != _originalProduct?.brandId) {
      updatedFields['brandId'] = _product?.brandId;
    }

    if (_product?.status != _originalProduct?.status) {
      updatedFields['status'] = _product?.status;
    }
    if (_product?.deliveryType != _originalProduct?.deliveryType) {
      updatedFields['deliveryType'] = _product?.deliveryType;
    }
    if (_product?.categoryId != _originalProduct?.categoryId) {
      updatedFields['categoryId'] = _product?.categoryId;
    }
    if (_product?.vendorCode != _originalProduct?.vendorCode) {
      updatedFields['vendorCode'] = _product?.vendorCode;
    }
    // final currentKind = _product?.variants?.first.kind;
    // final originalKind = _originalProduct?.variants?.first.kind;

    // if (currentKind != originalKind) {
    //   updatedFields['kind'] = currentKind;
    // }
    // Сравнение описания
    if (_product?.description?.blocks !=
        _originalProduct?.description?.blocks) {
      updatedFields['description'] = {
        "time": DateTime.now().millisecondsSinceEpoch,
        "blocks": _product?.description?.blocks?.map((block) {
          return {
            "id": block.id,
            "type": block.type,
            "data": block.data?.toJson(),
          };
        }).toList(),
      };
    }

    return updatedFields;
  }

  Future<void> _fetchProduct() async {
    final local = S.of(context);
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final product = await widget.productService.fetchProduct(
        context: context,
        id: widget.productId,
      );
      setState(() {
        _product = product;
        _selectedTags = product.tags ?? [];
        _selectedBrandId = product.brandId;
        _originalProduct =
            ProductItems.fromJson(product.toJson()); // Сохраняем оригинал
        _originalImages = List.from(product.images ?? []);
        selectedType = product.kind == 'original'
            ? local.original
            : product.kind == 'sub_original'
                ? local.sub_original
                : local.auto_disassembly;
        _isLoading = false;
      });

      // Загрузка бренда по ID
      if (product.brandId != null) {
        await _loadBrandById(product.brandId!);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _onUpdateProduct() async {
    if (_product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Empty update')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UpdatingAnimationPage()),
    );

    final updatedFields = _getUpdatedFields();

    final updatedProperties = _propertyValues.entries.where((entry) {
      // Ищем соответствующее свойство в списке _product.properties по id свойства
      final p = _product?.properties
          ?.firstWhereOrNull((prop) => prop.property?.id == entry.key);
      // Сравниваем текущее значение с сохранённым (приводим к строке для сравнения)
      return p == null || entry.value != (p.value?.toString() ?? '');
    }).map((entry) {
      // Получаем тип свойства из оригинальных данных
      final p = _product?.properties
          ?.firstWhereOrNull((prop) => prop.property?.id == entry.key);
      final type = p?.property?.type ?? 'string';
      return {
        'id': entry.key,
        'value': entry.value,
        'type':
            type, // Добавляем тип, чтобы потом правильно преобразовать значение
      };
    }).toList();

    final bool hasImageChanges =
        _newImages.isNotEmpty || _deletedImages.isNotEmpty;
    final currentVariant = _product;
    final updatedManufacturerId = currentVariant?.manufacturerId;
    final updatedSku = currentVariant?.sku;
    final updatedKind = currentVariant?.kind;
    final originalVariant = _originalProduct;

    final hasVariantChanges = currentVariant != null &&
        (updatedManufacturerId != originalVariant?.manufacturerId ||
            updatedSku != originalVariant?.sku ||
            updatedKind != originalVariant?.kind);

    if (updatedFields.isEmpty &&
        updatedProperties.isEmpty &&
        !hasImageChanges &&
        !hasVariantChanges) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет изменений для сохранения')),
      );
      return;
    }

    try {
      for (final newImage in _newImages) {
        final file = File(newImage.path);
        final bytes = await file.readAsBytes();
        final base64Image = base64Encode(bytes);
        await _imagesService.createProductImage(
          context,
          productId: widget.productId,
          imageSize: bytes.lengthInBytes.toDouble(),
          imageData: base64Image,
          imageName: newImage.name,
        );
      }

      for (final imageUrl in _deletedImages) {
        final images = await _imagesService.fetchProductImages(context,
            productId: widget.productId);
        final imageHash = images
            .firstWhere((img) => img.url == imageUrl,
                orElse: () => throw Exception('Image hash not found'))
            .hash;
        if (imageHash != null) {
          await _imagesService.deleteProductImage(
            context,
            productId: widget.productId,
            imageHash: imageHash,
          );
        }
      }

      setState(() {
        _newImages.clear();
        _deletedImages.clear();
      });

      if (updatedProperties.isNotEmpty) {
        final propertiesService = PropertiesService();
        for (final prop in updatedProperties) {
          final propertyId = prop['id'];
          final rawValue = prop['value'];
          // Используем тип из объекта обновлённых свойств
          final type = prop['type'];
          // Преобразуем значение в нужный формат (для number, float, boolean – возвращаются соответствующие типы)
          final newValue =
              _convertPropertyValue(type ?? '', rawValue?.toString() ?? '');

          final pItem = _product?.properties?.firstWhereOrNull(
            (p) => p.property?.id == propertyId,
          );

          if (pItem != null && pItem.id != null) {
            await propertiesService.updateProductProperty(
              context,
              productId: widget.productId,
              propertiesId: pItem.id!,
              value: newValue, // Передаём значение корректного типа
            );
          }
        }
      }

      if (hasVariantChanges && currentVariant != null && _product != null) {
        final variantsService = VariantsService();
        final newAmount = currentVariant.price?.amount?.toDouble() ?? 0.0;
        await variantsService.updateProductVariant(
          context,
          productId: widget.productId,
          variantId: currentVariant.id ?? '',
          newAmount: newAmount,
          manufacturerId: updatedManufacturerId,
          sku: updatedSku,
          kind: updatedKind,
          discountedPersent: _product!.discountPercent ?? 0,
          discountedAmount: _product!.discountedPrice!.amount!.toDouble(),
        );
      }

      if (updatedFields.isNotEmpty) {
        final response = await widget.productService.updateProduct(
          context: context,
          id: widget.productId,
          updatedFields: updatedFields,
        );
        if (response.statusCode != 200 && response.statusCode != 204) {
          throw Exception('Error: ${response.body}');
        }
      }

      await _fetchProduct();
      Navigator.pop(context);
      _showSuccessDialog();
    } catch (e) {
      Navigator.pop(context);
      _showError('Error: $e');
    }
  }

  void _showSuccessDialog() {
    final local = S.of(context);
    showDialog(
      context: context,
      barrierDismissible: false, // Диалог нельзя закрыть кликом вне окна
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 55,
              ),
              const SizedBox(height: 16),
              Text(
                local.productUpdatedSuccessfully,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Закрываем диалог
                  Navigator.pop(
                      context, true); // Возвращаемся на предыдущую страницу
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: ThemeColors.orange, // Цвет текста кнопки
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ), // Внутренние отступы
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Закруглённые края кнопки
                  ),
                ),
                child: Text(
                  local.showProduct,
                  style: TextStyle(
                    fontSize: 12, // Размер шрифта
                    fontWeight: FontWeight.bold, // Толщина шрифта
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImages.add(pickedFile); // Сохраняем файл локально
      });
    }
  }

  Future<void> _removeImage(int index) async {
    final imageToRemove = _product?.images?[index];

    if (imageToRemove != null) {
      setState(() {
        _deletedImages
            .add(imageToRemove.url ?? ''); // Сохраняем URL для удаления
        _product?.images?.removeAt(index); // Удаляем из локального списка
      });
    } else if (index < _newImages.length) {
      setState(() {
        _newImages.removeAt(index); // Удаляем из добавленных
      });
    }
  }

  Future<void> _loadManufacturers() async {
    try {
      final response = await _service.fetchManufacturers(context);
      setState(() {
        _manufacturers = response.items ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _showAddManufacturerDialog() async {
    final local = S.of(context);
    final TextEditingController nameController = TextEditingController();

    await showCustomAlertDialog(
      context: context,
      title: local.add_manufacturer,
      content: TextField(
        controller: nameController,
        decoration: InputDecoration(
          // labelText: 'Название производителя',
          hintText: local.enter_manufacturer_name,
          // border: OutlineInputBorder(),
        ),
      ),
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () async {
        final name = nameController.text.trim();
        if (name.isNotEmpty) {
          try {
            // Создание производителя через сервис
            await _service.createManufacturers(context, name);

            // Показываем уведомление об успешном добавлении
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(local.success)),
            );

            // Обновляем список производителей
            await _loadManufacturers();

            // Закрываем диалог
            Navigator.pop(context);
          } catch (e) {
            // Показываем ошибку
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        } else {
          // Показываем ошибку, если поле ввода пустое
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(local.empty)),
          );
        }
      },
    );
  }

  Future<void> _loadBrands() async {
    try {
      setState(() {
        isLoading = true; // Устанавливаем флаг загрузки
      });
      final response = await _brandsService.fetchBrands(context);
      setState(() {
        brands = response.items ?? [];
        // filteredBrands = brands;
        isLoading = false; // Загрузка завершена
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Завершаем загрузку даже при ошибке
      });
      _showError('Error: $e');
    }
  }

  void _showBrands() {
    final local = S.of(context);
    if (brands.isEmpty) {
      _showError(S.of(context).emptyBrandList);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = ''; // Локальная переменная для поиска
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredBrands = brands
                .where((brand) =>
                    brand.name != null &&
                    brand.name!
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: local.searchBrand,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                            ),
                            onChanged: (value) {
                              setStateModal(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredBrands.length,
                        itemBuilder: (context, index) {
                          final brand = filteredBrands[index];
                          return ListTile(
                            title: Text(brand.name ?? local.no_name),
                            onTap: () {
                              if (_product?.brandId != brand.id) {
                                Navigator.pop(context);
                                setState(() {
                                  _selectedBrandId = brand.id;
                                  _product?.brandId = brand.id;
                                  selectedBrand = brand.name ?? local.no_name;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        text: local.create_your_brand,
                        onPressed: () {
                          _showAddBrandDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _loadBrandById(String brandId) async {
    try {
      final brand = await _brandsService.fetchBrandById(context, brandId);
      setState(() {
        selectedBrand = brand.name ?? S.of(context).no_name;
      });
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showAddBrandDialog() {
    final local = S.of(context);
    String newBrandName = '';
    String selectedType = 'product'; // Значение по умолчанию

    showCustomAlertDialog(
      context: context,
      title: local.add_brand,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: local.enter_brand_name,
            ),
            onChanged: (value) {
              newBrandName = value;
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () async {
        if (newBrandName.isNotEmpty) {
          try {
            // Выполняем POST-запрос для добавления бренда
            await _brandsService.createBrand(
              context,
              selectedType,
              newBrandName,
              newBrandName,
            );

            // Загружаем обновленный список брендов
            await _loadBrands();

            // Закрываем диалоговое окно после успешной операции
            Navigator.pop(context);
          } catch (e) {
            _showError('Error: $e');
            print('Error: $e');
          }
        } else {
          _showError(S.of(context).empty);
        }
      },
    );
  }

  void _showError(String message) {
    print(message);
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

  void _showManufacturers() {
    final local = S.of(context);
    if (_manufacturers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).empty)),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = ''; // Локальная переменная для поиска
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredManufacturers = _manufacturers
                .where((manufacturer) =>
                    manufacturer.name != null &&
                    manufacturer.name!
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: local.manufacturer_search,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                            ),
                            onChanged: (value) {
                              setStateModal(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredManufacturers.length,
                        itemBuilder: (context, index) {
                          final manufacturer = filteredManufacturers[index];
                          return ListTile(
                            title: Text(manufacturer.name ?? local.no_name),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedManufacturer = manufacturer;
                                _product?.manufacturerId = manufacturer.id;
                                // Сохраняем ID производителя в AuthProvider
                                context
                                    .read<GlobalProvider>()
                                    .setManufacturerId(manufacturer.id ?? '');
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        text: local.add_manufacturer,
                        onPressed: () {
                          _showAddManufacturerDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = S.of(context);
    return Scaffold(
      backgroundColor: ThemeColors.white,
      appBar: AppBar(
        title: Text(local.productEditing),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: ThemeColors.grey4,
            ))
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${local.error} $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: _fetchProduct,
                        child: Text(local.repeat),
                      ),
                    ],
                  ),
                )
              : _product != null
                  ? _buildProductDetails()
                  : Center(
                      child: Text(local.empty),
                    ),
    );
  }

  Widget _buildProductDetails() {
    final local = S.of(context);
    final displayValue = '';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Название товара
          EditableDropdownField(
            title: local.productName,
            value: _productName.isNotEmpty
                ? _productName
                : (_product?.name ?? local.no_name),
            onChanged: (newValue) {
              setState(() {
                _product?.name = newValue; // Обновляем текущее значение
              });
            },
          ),

          const SizedBox(height: 10),

          // Статус
          CustomDropdownField(
            title: local.productStatus,
            value:
                (_product!.status == 'created' || _product!.status == 'updated')
                    ? local.awaitingModeration
                    : (_product!.status == 'active'
                        ? local.active
                        : (_product!.status ?? local.no_name)),
            onTap: () {},
            showIcon: false,
          ),

          const SizedBox(height: 15),

          // Изображения

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${local.productPhotos}:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Builder(
                builder: (context) {
                  final int existingImagesCount = _product?.images?.length ?? 0;
                  final int newImagesCount = _newImages.length;
                  final int totalImages = existingImagesCount + newImagesCount;
                  final List<Widget> imageWidgets = [
                    // Отображение существующих изображений
                    ...?_product?.images?.map((image) {
                      int index = _product!.images!.indexOf(image);
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(image.url!),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: const Icon(Icons.close,
                                  color: Colors.red, size: 20),
                            ),
                          ),
                        ],
                      );
                    }).toList(),

                    // Отображение новых изображений
                    ..._newImages.map((newImage) {
                      int index = (_product?.images?.length ?? 0) +
                          _newImages.indexOf(newImage);
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(newImage.path)),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: const Icon(Icons.close,
                                  color: Colors.red, size: 20),
                            ),
                          ),
                        ],
                      );
                    }).toList(),

                    // Кнопка добавления изображения
                    if (totalImages < 5)
                      GestureDetector(
                        onTap: _addImage,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              const Icon(Icons.add_a_photo, color: Colors.grey),
                        ),
                      ),
                  ];

                  return totalImages > 3
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: imageWidgets),
                        )
                      : Row(children: imageWidgets);
                },
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Описание
          EditableDropdownField(
            title: local.description,
            value: _product?.description?.blocks?.first.data?.text ??
                local.description_absent,
            onChanged: (newValue) {
              setState(() {
                if (_product?.description?.blocks != null &&
                    _product!.description!.blocks!.isNotEmpty) {
                  _product?.description?.blocks?[0].data?.text =
                      newValue; // Обновляем описание
                }
              });
            },
            maxLines: 4,
          ),

          const SizedBox(height: 10),

          CustomDropdownField(
            title: local.brand,
            value: selectedBrand, // Отображаем имя бренда
            onTap: _showBrands,
            showIcon: true,
          ),

          // const SizedBox(height: 10),

          // CustomDropdownField(
          //   title: 'Категория',
          //   value: selectedCategory,
          //   onTap: _showCategories,
          // ),
          const SizedBox(height: 10),
          CustomDropdownField(
              title: local.manufacturer,
              value: _selectedManufacturer?.name ??
                  _product?.manufacturer?.name ??
                  local.no_name,
              onTap: _showManufacturers),

          const SizedBox(height: 10),
          CustomDropdownField(
            title: local.tags,
            value: _selectedTags.isNotEmpty
                ? _selectedTags.map((tag) => tag.text).join(', ')
                : local.choose_tags,
            onTap: _showTags,
          ),
          const SizedBox(height: 10),

          // Цена
          // EditableDropdownField(
          //   title: 'Цена',
          //   value: '${(_product!.variants!.first.price?.amount ?? 0) / 100}',
          //   onChanged: (newValue) {
          //     setState(() {
          //       _product?.vendorCode = newValue; // Обновляем код товара
          //     });
          //   },
          // ),
          // const SizedBox(height: 10),

          // Код товара
          EditableDropdownField(
            title: local.article,
            value: _product?.vendorCode ?? '',
            onChanged: (newValue) {
              setState(() {
                _product?.vendorCode = newValue; // Обновляем код товара
              });
            },
          ),
          const SizedBox(height: 10),

          if (_product?.crossNumber != null)
            EditableDropdownField(
              title: local.oemNumber,
              change: false,
              value: _product?.crossNumber ?? '',
              onChanged: (newValue) {
                setState(() {
                  _product?.crossNumber = newValue; // Обновляем код товара
                });
              },
            ),
          const SizedBox(height: 10),

          // Артикул товара
          EditableDropdownField(
            title: local.vendor_code,
            value: _product?.sku ?? '',
            onChanged: (newValue) {
              setState(() {
                // Обновляем реальное поле SKU в _product
                _product?.sku = newValue;
              });
            },
          ),

          const SizedBox(height: 10),
          // CustomDropdownField(
          //     title: 'Соотвествие с автомобилем',
          //     value: displayValue,
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const CrossNumberScreen()),
          //       );
          //     }),
          // // Тип
          // const SizedBox(height: 10),

          CustomDropdownField(
            title: local.type,
            value: selectedType ?? local.choose_type,
            onTap: _showTypeOptions,
          ),
          const SizedBox(height: 15),
          // Отображение свойств товара с учётом типа
          const SizedBox(height: 10),
          Text(
            local.productProperty,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          if (_product?.properties != null && _product!.properties!.isNotEmpty)
            ..._product!.properties!.map((property) {
              final propertyId = property.property?.id ?? '';
              final propertyName = property.property?.name ?? local.no_name;
              final propertyUnit = property.property?.unit;
              final propertyType = property.property?.type ?? 'string';
              // Берём текущее значение либо из локального словаря, либо из объекта свойства
              final currentValue = _propertyValues[propertyId] ??
                  property.value?.toString() ??
                  '';

              final title = propertyUnit == null
                  ? propertyName
                  : '$propertyName ($propertyUnit)';

              switch (propertyType) {
                case 'boolean':
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title),
                        Checkbox(
                          value: currentValue.toLowerCase() == 'true',
                          onChanged: (value) {
                            setState(() {
                              _propertyValues[propertyId] = value.toString();
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
                        title: title,
                        value: currentValue,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          setState(() {
                            _propertyValues[propertyId] = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                case 'float':
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomEditableField(
                        title: title,
                        value: currentValue,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _propertyValues[propertyId] = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                case 'color':
                  return SizedBox.shrink();

                // return Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     ColorPicker(
                //       propertyId: propertyId,
                //       initialColor:
                //           currentValue, // currentValue содержит id выбранного цвета, если он уже установлен
                //       onColorSelected: (selectedColorId) {
                //         setState(() {
                //           _propertyValues[propertyId] = selectedColorId;
                //         });
                //       },
                //     ),
                //     if (_propertyErrors[propertyId] ?? false)
                //       const Text(
                //         'Выберите цвет',
                //         style: TextStyle(color: Colors.red),
                //       ),
                //     const SizedBox(height: 12),
                //   ],
                // );

                case 'string':
                default:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomEditableField(
                        title: title,
                        value: currentValue,
                        onChanged: (value) {
                          setState(() {
                            _propertyValues[propertyId] = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
              }
            }).toList()
          else
            Center(child: Text(local.noAvailableProperties)),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: CustomButton(
              text: local.updateProduct,
              onPressed: () {
                _onUpdateProduct();
              },
            ),
          ),
        ],
      ),
    );
  }
}
