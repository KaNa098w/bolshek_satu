import 'dart:convert';
import 'dart:io';
import 'package:bolshek_pro/app/widgets/animation_rotation_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/app/widgets/editable_dropdown_field.dart';
import 'package:bolshek_pro/core/models/category_response.dart' as category;
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/category_response.dart';
import 'package:bolshek_pro/core/models/manufacturers_response.dart';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/service/brands_service.dart';
import 'package:bolshek_pro/core/service/category_service.dart';
import 'package:bolshek_pro/core/service/images_service.dart';
import 'package:bolshek_pro/core/service/maufacturers_service.dart';
import 'package:bolshek_pro/core/service/properties_service.dart';
import 'package:bolshek_pro/core/service/variants_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/core/models/fetch_product_response.dart';
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
  FetchProductResponse? _product;
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
  String selectedBrand = 'Загружается бренд...';
  String selectedCategory = 'Загружается категория...';
  String _productName = ''; // Хранит текущее значение имени товара
  Map<String, dynamic> _updatedFields = {}; // Хранит все изменённые данные
  FetchProductResponse? _originalProduct;
  String? _selectedBrandId;
  List<Images>? _originalImages;
  final ImagesService _imagesService = ImagesService();
  String selectedType = 'Оригинал';
  Map<String, String> _propertyValues = {};
  ValueNotifier<List<PropertyItems>> propertiesNotifier = ValueNotifier([]);
  List<XFile> _newImages = []; // Новые изображения, добавленные пользователем
  List<String> _deletedImages = []; // URL удалённых изображений

  final CategoriesService _categoriesService = CategoriesService();
  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
    _loadManufacturers();
    _loadBrands();
    _selectedBrandId = _product?.brandId;
    if (_product?.variants?.isNotEmpty ?? false) {
      final variantKind = _product?.variants?.first.kind;
      selectedType = variantKind == 'original'
          ? 'Оригинал'
          : variantKind == 'sub_original'
              ? 'Под оригинал'
              : 'Авторазбор';
    } else {
      selectedType = 'Оригинал'; // Значение по умолчанию
    }
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        isLoadingCategories = true;
      });

      final parentResponse =
          await _categoriesService.fetchCategoriesParent(context);
      final allCategoriesResponse =
          await _categoriesService.fetchCategories(context);

      if (!mounted) return; // Проверка перед вызовом setState

      setState(() {
        final parentCategories = parentResponse.items ?? [];
        final allCategories = allCategoriesResponse.items ?? [];

        categories = parentCategories.map((parent) {
          parent.children = allCategories
              .where((category) => category.parentId == parent.id)
              .toList();
          return parent;
        }).toList();

        isLoadingCategories = false;
      });
    } catch (e) {
      if (!mounted) return; // Проверка перед вызовом setState

      setState(() {
        isLoadingCategories = false;
      });
      _showError('Ошибка загрузки категорий: $e');
    }
  }

  void _showCategories() {
    // Показываем модальное окно
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        // Используем StatefulBuilder для управления состоянием модального окна
        return StatefulBuilder(
          builder: (context, setStateModal) {
            // Проверяем состояние загрузки
            if (isLoadingCategories) {
              // Пока данные загружаются, показываем индикатор
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Center(
                    child: CircularProgressIndicator(
                  color: ThemeColors.orange,
                )),
              );
            }

            // Если данные загружены, проверяем их наличие
            if (categories.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Center(
                  child: Text('Список категорий пуст'),
                ),
              );
            }

            // Если категории загружены, отображаем список
            String searchQuery = '';
            final filteredCategories = categories;

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
                              hintText: 'Поиск категории',
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
                                filteredCategories.clear();
                                filteredCategories.addAll(
                                  categories.where((category) =>
                                      category.name != null &&
                                      category.name!
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase())),
                                );
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
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
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final parentCategory = filteredCategories[index];
                          final subcategories = parentCategory.children ?? [];
                          return ExpansionTile(
                            title: Text(parentCategory.name ?? 'Без названия'),
                            children: subcategories.map((subcategory) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: ListTile(
                                  title:
                                      Text(subcategory.name ?? 'Без названия'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      selectedCategory =
                                          subcategory.name ?? 'Без названия';
                                    });
                                  },
                                ),
                              );
                            }).toList(),
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

    // Проверяем, загружены ли данные, и при необходимости запускаем загрузку
    if (categories.isEmpty) {
      _loadCategories().then((_) {
        // После завершения загрузки вызываем обновление состояния модального окна
        if (context.mounted) {
          Navigator.pop(context); // Закрываем текущее окно
          _showCategories(); // Повторно открываем с загруженными данными
        }
      }).catchError((error) {
        // Если произошла ошибка, отображаем сообщение
        _showError('Ошибка загрузки категорий: $error');
      });
    }
  }

  void _showTypeOptions() {
    final typeOptions = ['Оригинал', 'Под оригинал', 'Авторазбор'];

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
                    const Text('Выберите тип товара'),
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
                              final updatedKind = type == 'Оригинал'
                                  ? 'original'
                                  : (type == 'Под оригинал'
                                      ? 'sub_original'
                                      : 'disassemble');
                              // 3. Ставим значение во внутреннем объекте
                              _product?.variants?.first.kind = updatedKind;

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
        _originalProduct = FetchProductResponse.fromJson(
            product.toJson()); // Сохраняем оригинал
        _originalImages = List.from(product.images ?? []);
        selectedType = product.variants?.first.kind == 'original'
            ? 'Оригинал'
            : product.variants?.first.kind == 'sub_original'
                ? 'Под оригинал'
                : 'Авторазбор';
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
        const SnackBar(content: Text('Нет данных для обновления')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UpdatingAnimationPage()),
    );

    final updatedFields = _getUpdatedFields();

    final updatedProperties = _propertyValues.entries
        .where((entry) {
          final existing = _product?.properties
              ?.firstWhereOrNull((prop) => prop.id == entry.key);
          return existing == null || entry.value != existing.value;
        })
        .map((entry) => {
              'id': entry.key,
              'value': entry.value,
            })
        .toList();

    final bool hasImageChanges =
        _newImages.isNotEmpty || _deletedImages.isNotEmpty;
    final currentVariant = _product?.variants?.first;
    final updatedManufacturerId = currentVariant?.manufacturerId;
    final updatedSku = currentVariant?.sku;
    final updatedKind = currentVariant?.kind;
    final originalVariant = _originalProduct?.variants?.first;
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
          final newValue = prop['value'];
          final pItem = _product?.properties?.firstWhereOrNull(
            (p) => p.property?.id == propertyId,
          );
          if (pItem != null && pItem.id != null) {
            await propertiesService.updateProductProperty(
              context,
              productId: widget.productId,
              propertiesId: pItem.id!,
              value: newValue ?? '',
            );
          }
        }
      }

      if (hasVariantChanges &&
          currentVariant != null &&
          originalVariant != null) {
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
        );
      }

      if (updatedFields.isNotEmpty) {
        final response = await widget.productService.updateProduct(
          context: context,
          id: widget.productId,
          updatedFields: updatedFields,
        );
        if (response.statusCode != 200 && response.statusCode != 204) {
          throw Exception('Ошибка обновления товара: ${response.body}');
        }
      }

      await _fetchProduct();
      Navigator.pop(context);
      _showSuccessDialog();
    } catch (e) {
      Navigator.pop(context);
      _showError('Ошибка при обновлении товара: $e');
    }
  }

  void _showSuccessDialog() {
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
              const Text(
                'Товар успешно обновлён!',
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
                child: const Text(
                  'Показать товар',
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

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircularProgressIndicator(
                  color: ThemeColors.grey4,
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(message)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold), // Белый текст
        ),
        backgroundColor: isSuccess
            ? Colors.green
            : Colors.red, // Зелёный для успеха, красный для ошибки
      ),
    );
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
        SnackBar(content: Text('Ошибка загрузки производителей: $e')),
      );
    }
  }

  Future<void> _showAddManufacturerDialog() async {
    final TextEditingController nameController = TextEditingController();

    await showCustomAlertDialog(
      context: context,
      title: 'Добавить производителя',
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          // labelText: 'Название производителя',
          hintText: 'Введите название',
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
              SnackBar(content: Text('Производитель "$name" успешно добавлен')),
            );

            // Обновляем список производителей
            await _loadManufacturers();

            // Закрываем диалог
            Navigator.pop(context);
          } catch (e) {
            // Показываем ошибку
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка добавления производителя: $e')),
            );
          }
        } else {
          // Показываем ошибку, если поле ввода пустое
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Название производителя не может быть пустым')),
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
      _showError('Ошибка загрузки брендов: $e');
    }
  }

  void _showBrands() {
    if (brands.isEmpty) {
      _showError('Список брендов пуст');
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
                              hintText: 'Поиск бренда',
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
                            title: Text(brand.name ?? 'Без названия'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedBrandId =
                                    brand.id; // Сохраняем brandId
                                _product?.brandId =
                                    brand.id; // Обновляем продукт
                                selectedBrand = brand.name ??
                                    'Не указано'; // Отображаем имя
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
                        text: 'Создать свой бренд',
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
        selectedBrand = brand.name ?? 'Не указано';
      });
    } catch (e) {
      _showError('Ошибка загрузки бренда: $e');
    }
  }

  void _showAddBrandDialog() {
    String newBrandName = '';
    String selectedType = 'product'; // Значение по умолчанию

    showCustomAlertDialog(
      context: context,
      title: 'Добавить бренд',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Введите название бренда',
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
            _showError('Ошибка при добавлении бренда: $e');
            print('Ошибка при добавлении бренда: $e');
          }
        } else {
          _showError('Название бренда не может быть пустым');
        }
      },
    );
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

  void _showManufacturers() {
    if (_manufacturers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Список производителей пуст')),
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
                              hintText: 'Поиск производителя',
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
                            title: Text(manufacturer.name ?? 'Без названия'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedManufacturer = manufacturer;
                                _product?.variants?.first.manufacturerId =
                                    manufacturer.id;
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
                        text: 'Добавить производителя',
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
    return Scaffold(
      backgroundColor: ThemeColors.white,
      appBar: AppBar(
        title: const Text('Редактирование товара'),
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
                        'Ошибка: $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: _fetchProduct,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : _product != null
                  ? _buildProductDetails()
                  : const Center(
                      child: Text('Товар не найден'),
                    ),
    );
  }

  Widget _buildProductDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Название товара
          EditableDropdownField(
            title: 'Название товара',
            value: _productName.isNotEmpty
                ? _productName
                : (_product?.name ?? 'Не указано'),
            onChanged: (newValue) {
              setState(() {
                _product?.name = newValue; // Обновляем текущее значение
              });
            },
          ),

          const SizedBox(height: 10),

          // Статус
          CustomDropdownField(
            title: 'Статус товара',
            value:
                (_product!.status == 'created' || _product!.status == 'updated')
                    ? 'Ожидает модерации'
                    : (_product!.status == 'active'
                        ? 'Активный'
                        : (_product!.status ?? 'Не указано')),
            onTap: () {
              print('Нажата строка со статусом товара');
            },
            showIcon: false,
          ),

          const SizedBox(height: 15),

          // Изображения
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Изображения:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
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
                    int index = _product?.images?.length ??
                        0 + _newImages.indexOf(newImage);
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
                  if ((_product?.images?.length ?? 0) + _newImages.length < 5)
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
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Описание
          EditableDropdownField(
            title: 'Описание товара',
            value: _product?.description?.blocks?.first.data?.text ??
                'Нет описания',
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
            title: 'Бренд',
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
              title: 'Производитель',
              value: _selectedManufacturer?.name ??
                  _product?.variants?.first.manufacturer?.name ??
                  'Не указано',
              onTap: _showManufacturers),

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
            title: 'Артикул товара',
            value: _product?.vendorCode ?? '',
            onChanged: (newValue) {
              setState(() {
                _product?.vendorCode = newValue; // Обновляем код товара
              });
            },
          ),

          const SizedBox(height: 10),

          // Артикул товара
          EditableDropdownField(
            title: 'Код товара',
            value: _product?.variants?.first.sku ?? '',
            onChanged: (newValue) {
              setState(() {
                // Обновляем реальное поле SKU в _product
                _product?.variants?.first.sku = newValue;
              });
            },
          ),

          const SizedBox(height: 10),

          // Тип

          CustomDropdownField(
            title: 'Тип',
            value: selectedType ?? 'Выберите тип',
            onTap: _showTypeOptions,
          ),
          const SizedBox(height: 15),
          Text(
            'Свойство товара:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),

          // Проверяем, есть ли свойства
          if (_product?.properties != null && _product!.properties!.isNotEmpty)
            ..._product!.properties!.map((property) {
              final propertyId = property.property?.id ?? '';
              final propertyName = property.property?.name ?? 'Не указано';
              final propertyUnit = property.property?.unit;
              final currentValue =
                  _propertyValues[propertyId] ?? property.value ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditableDropdownField(
                    title: propertyUnit == null
                        ? propertyName
                        : '$propertyName ($propertyUnit)',
                    value: currentValue,
                    // hint: 'Введите значение',
                    onChanged: (value) {
                      setState(() {
                        _propertyValues[propertyId] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList()
          else
            const Center(
              child: Text('Нет доступных свойств'),
            ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Обновить товар',
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
