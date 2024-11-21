import 'dart:io';

import 'package:bolshek_pro/core/models/category_response.dart' as category;
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/service/brands_service.dart';
import 'package:bolshek_pro/core/service/category_service.dart';
import 'package:bolshek_pro/core/service/properties_service.dart';
import 'package:bolshek_pro/app/pages/home/home_widgets/add_name_product_page.dart';
import 'package:bolshek_pro/app/pages/home/home_widgets/add_variant_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:image_picker/image_picker.dart';

class InfoTab extends StatefulWidget {
  final String productName;
  final Function(List<PropertyItems>, Map<String, String>) onPropertiesLoaded;
  final TabController tabController;
  final Function(String) onCategorySelected;

  const InfoTab({
    Key? key,
    required this.productName,
    required this.onPropertiesLoaded,
    required this.tabController,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  Map<String, List<PropertyItems>> categoryPropertiesCache = {};
  Map<String, Map<String, String>> propertyValuesCache = {};
  String selectedBrand = 'Выберите бренд';
  final BrandsService _brandsService = BrandsService();
  List<Items> brands = [];
  List<Items> filteredBrands = [];
  bool isLoading = true;
  String selectedCategory = 'Выберите категорию';
  final CategoriesService _categoriesService = CategoriesService();
  List<category.CategoryItems> categories = [];
  List<category.CategoryItems> filteredCategories = [];
  Map<String, String> _propertyValues = {};
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadBrands();
    _loadCategories();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          if (_images.length < 5) {
            _images.add(File(pickedFile.path));
          } else {
            _showError('Можно загрузить максимум 5 фото');
          }
        });
      }
    } catch (e) {
      _showError('Ошибка при выборе фото: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Камера'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Галерея'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Отмена'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
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

  Future<void> _loadBrands() async {
    try {
      setState(() {
        isLoading = true; // Устанавливаем флаг загрузки
      });
      final response = await _brandsService.fetchBrands(context);
      setState(() {
        brands = response.items ?? [];
        filteredBrands = brands;
        isLoading = false; // Загрузка завершена
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Завершаем загрузку даже при ошибке
      });
      _showError('Ошибка загрузки брендов: $e');
    }
  }

  void _showCategories() {
    if (categories.isEmpty) {
      _showError('Список категорий пуст');
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
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredCategories = categories
                .where((category) =>
                    category.name != null &&
                    category.name!
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
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final parentCategory = filteredCategories[index];
                          final subcategories = parentCategory.children ?? [];
                          return ExpansionTile(
                            title: Text(parentCategory.name ?? 'Без названия'),
                            children: subcategories.map((subcategory) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0), // Абзац для подкатегорий
                                child: ListTile(
                                  title:
                                      Text(subcategory.name ?? 'Без названия'),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    setState(() {
                                      selectedCategory =
                                          subcategory.name ?? 'Без названия';
                                    });

                                    // Проверяем, есть ли данные в кэше
                                    if (categoryPropertiesCache
                                        .containsKey(subcategory.id)) {
                                      widget.onPropertiesLoaded(
                                        categoryPropertiesCache[
                                            subcategory.id]!,
                                        propertyValuesCache[subcategory.id]!,
                                      );
                                    } else {
                                      try {
                                        // Загрузка данных, если их нет в кэше
                                        final propertiesResponse =
                                            await PropertiesService()
                                                .fetchProperties(context,
                                                    subcategory.id ?? '');

                                        setState(() {
                                          categoryPropertiesCache[
                                                  subcategory.id!] =
                                              propertiesResponse.items ?? [];
                                          propertyValuesCache[subcategory.id!] =
                                              {
                                            for (var property
                                                in propertiesResponse.items ??
                                                    [])
                                              property.id ?? '': '',
                                          };
                                        });

                                        widget.onPropertiesLoaded(
                                          categoryPropertiesCache[
                                              subcategory.id]!,
                                          propertyValuesCache[subcategory.id]!,
                                        );
                                      } catch (e) {
                                        _showError(
                                            'Ошибка загрузки свойств: $e');
                                      }
                                    }

                                    // Передаём ID выбранной категории в родительский виджет
                                    widget.onCategorySelected(
                                        subcategory.id ?? '');
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

  void _filterBrands(String query) {
    if (query.length < 3) {
      setState(() {
        filteredBrands =
            brands; // Возвращаем весь список, если менее 3 символов
      });
      return;
    }

    setState(() {
      filteredBrands = brands
          .where((brand) =>
              brand.name != null &&
              brand.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
        String searchQuery = ''; // Локальная переменная для ввода
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                          itemCount: filteredBrands.length,
                          itemBuilder: (context, index) {
                            final brand = filteredBrands[index];
                            return ListTile(
                              title: Text(brand.name ?? 'Без названия'),
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  selectedBrand = brand.name ?? 'Без названия';
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Загрузите от 1 до 5 фото',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ..._images.map((image) {
                        int index = _images.indexOf(image);
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
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
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      if (_images.length < 5)
                        GestureDetector(
                          onTap: _showImageSourceDialog,
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
                  const SizedBox(height: 20),
                  CustomDropdownField(
                    title: 'Наименования товара',
                    value: widget.productName.isNotEmpty
                        ? widget.productName
                        : 'Антифриз',
                    onTap: () {
                      // Логика выбора категории
                    },
                    showIcon: false,
                  ),
                  const SizedBox(height: 20),
                  CustomDropdownField(
                    title: 'Категория',
                    value: selectedCategory,
                    onTap: _showCategories,
                  ),
                  const SizedBox(height: 20),
                  CustomDropdownField(
                    title: 'Бренд',
                    value: selectedBrand,
                    onTap: _showBrands,
                  ),
                  const SizedBox(height: 20),
                  // ..._properties.map((property) {
                  //   return Column(
                  //     children: [
                  //       CustomInputField(
                  //         title: property.name ?? 'Свойство',
                  //         value: _propertyValues[property.id ?? ''] ?? '',
                  //         hint: 'Введите значение',
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _propertyValues[property.id ?? ''] = value;
                  //           });
                  //         },
                  //       ),
                  //       const SizedBox(height: 20),
                  //     ],
                  //   );
                  // }).toList(),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(label: 'Цена', hint: '0'),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: _buildStyledDropdown(
                          label: 'Валюта',
                          items: ['KZT', 'USD', 'EUR'],
                          value: 'KZT', // Укажите значение по умолчанию
                          onChanged: (value) {
                            // Логика обработки выбора
                            print('Вы выбрали: $value');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      text: 'Продолжить',
                      onPressed: () {
                        widget.tabController.animateTo(
                            1); // Переход на вкладку "Характеристики"
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600)),
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStyledDropdown({
    required String label,
    required List<String> items,
    String? value,
    String? valueStatus,
    ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: value ?? items.first,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
