import 'dart:convert';
import 'dart:io';
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

  final CategoriesService _categoriesService = CategoriesService();
  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
    _loadManufacturers();
    _loadBrands();
    _selectedBrandId = _product?.brandId;
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
        String searchQuery = ''; // Локальная переменная для поиска
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredTypes = typeOptions
                .where((type) =>
                    type.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      children: [Text('Тип товара')],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTypes.length,
                        itemBuilder: (context, index) {
                          final type = filteredTypes[index];
                          return ListTile(
                            title: Text(type),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                selectedType = type;
                                String kind = '';
                                if (type == 'Оригинал') kind = 'original';
                                if (type == 'Под оригинал')
                                  kind = 'sub_original';
                                if (type == 'Авторазбор') kind = 'autorazbor';
                                context.read<GlobalProvider>().setKind(kind);
                              });
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

    // Получаем изменённые поля для обновления товара
    final updatedFields = _getUpdatedFields();

    // Проверяем, изменились ли свойства
    final updatedProperties = _propertyValues.entries.where((entry) {
      // Ищем существующее свойство по ID
      final existingProperty = _product?.properties?.firstWhereOrNull(
        (property) => property.id == entry.key, // Используем properties.id
      );

      // Если свойства нет или значение изменилось
      return existingProperty == null || entry.value != existingProperty.value;
    }).map((entry) {
      // Формируем список обновленных данных с использованием properties.id
      return {
        'id': entry.key, // Это ID свойства (properties.id)
        'value': entry.value, // Новое значение
      };
    }).toList();

    if (updatedFields.isEmpty && updatedProperties.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет изменений для сохранения')),
      );
      return;
    }

    try {
      // Обновляем свойства
      final propertiesService = PropertiesService();
      for (final updatedProperty in updatedProperties) {
        final propertyId = updatedProperty['id']; // Это `properties.id`
        final newValue = updatedProperty['value']; // Новое значение

        // Обновляем свойство через сервис
        await propertiesService.updateProductProperty(
          context,
          productId: widget.productId,
          propertiesId: _product?.properties?.first.id ??
              '', // Изменено на `propertiesId`
          value: newValue ?? '',
        );
      }

      // Обновляем остальные поля товара
      if (updatedFields.isNotEmpty) {
        final response = await widget.productService.updateProduct(
          context: context,
          id: widget.productId,
          updatedFields: updatedFields,
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Товар успешно обновлён')),
          );
          Navigator.pop(context, true);
        } else {
          throw Exception('Ошибка обновления товара: ${response.body}');
        }
      }

      // Перезагружаем данные товара
      await _fetchProduct();
    } catch (e) {
      _showError('Ошибка при обновлении товара: $e');
    }
  }

  Future<void> _addImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        // Показываем загрузчик
        _showLoadingDialog('Добавление изображения...');

        final file = File(pickedFile.path);
        final bytes = await file.readAsBytes();
        final base64Image = base64Encode(bytes);

        await _imagesService.createProductImage(
          context,
          productId: widget.productId,
          imageSize: bytes.lengthInBytes.toDouble(),
          imageData: base64Image,
          imageName: pickedFile.name ?? 'new_image',
        );

        // Обновляем данные
        await _fetchProduct();

        // Закрываем загрузчик
        Navigator.of(context).pop();

        // Показываем уведомление об успехе
        _showSnackBar('Изображение успешно добавлено');
      } catch (e) {
        Navigator.of(context).pop(); // Закрываем загрузчик
        _showError('Ошибка при добавлении изображения: $e');
      }
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
                const CircularProgressIndicator(),
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Подтвердить удаление'),
          content:
              const Text('Вы уверены, что хотите удалить это изображение?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        // Показываем загрузчик
        _showLoadingDialog('Удаление изображения...');

        // Получаем hash изображения
        final imageToRemove = _product?.images?[index];
        if (imageToRemove == null || imageToRemove.url == null) {
          throw Exception('Изображение не найдено');
        }

        final images = await _imagesService.fetchProductImages(
          context,
          productId: widget.productId,
        );

        final imageHash = images
            .firstWhere(
              (image) => image.url == imageToRemove.url,
              orElse: () => throw Exception('Image hash not found for URL'),
            )
            .hash;

        // Удаляем изображение
        await _imagesService.deleteProductImage(
          context,
          productId: widget.productId,
          imageHash: imageHash!,
        );

        // Убираем изображение из списка
        setState(() {
          _product?.images?.removeAt(index);
        });

        // Закрываем загрузчик
        Navigator.of(context).pop();

        // Показываем уведомление об успехе
        _showSnackBar('Изображение успешно удалено');
      } catch (e) {
        Navigator.of(context).pop(); // Закрываем загрузчик
        _showError('Ошибка при удалении изображения: $e');
      }
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
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить производителя'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Название производителя',
              hintText: 'Введите название',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  Navigator.of(context).pop(name);
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      try {
        await _service.createManufacturers(context, result);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Производитель "$result" успешно добавлен')),
        );
        await _loadManufacturers();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка добавления производителя: $e')),
        );
      }
    }
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
    showDialog(
      context: context,
      builder: (context) {
        String newBrandName = '';
        String selectedType = 'product'; // Значение по умолчанию

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Добавить бренд',
                style: TextStyle(fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                        hintText: 'Введите название бренда'),
                    onChanged: (value) {
                      newBrandName = value;
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () async {
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
                  child: const Text('Добавить'),
                ),
              ],
            );
          },
        );
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
          ? const Center(child: CircularProgressIndicator())
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
            value: _product!.status == 'created'
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
                  ..._product!.images!.map((image) {
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
                              image: image.url!.startsWith('http')
                                  ? NetworkImage(image.url!)
                                  : FileImage(File(image.url!))
                                      as ImageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  if (_product!.images!.length < 5)
                    GestureDetector(
                      onTap: _addImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey,
                        ),
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
          CustomDropdownField(
            title: 'Цена',
            value:
                '${(_product!.variants!.first.price?.amount ?? 0) / 100} KZT',
            onTap: () {},
          ),
          const SizedBox(height: 10),

          // Код товара
          EditableDropdownField(
            title: 'Код товара',
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
            title: 'Артикул товара',
            value: _product?.variants?.first.sku ?? '',
            onChanged: (newValue) {
              print("Новое значение: $newValue");
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
                    hint: 'Введите значение',
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
