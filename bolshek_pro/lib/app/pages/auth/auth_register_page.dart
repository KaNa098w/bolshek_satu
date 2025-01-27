import 'package:bolshek_pro/app/pages/auth/code_input_page.dart';
import 'package:bolshek_pro/app/pages/auth/code_input_register_page.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/phoneNumber_widget.dart';
import 'package:bolshek_pro/app/widgets/textfield_widget.dart';
import 'package:bolshek_pro/app/widgets/yandex_map_widget.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/core/service/category_service.dart';
import 'package:bolshek_pro/core/service/brands_service.dart';
import 'package:bolshek_pro/core/models/category_response.dart' as category;
import 'package:bolshek_pro/core/models/brands_response.dart';

class AuthRegisterScreen extends StatefulWidget {
  // final String otpId;
  final String? phoneNumber;

  const AuthRegisterScreen({
    Key? key,
    // required this.otpId,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _AuthRegisterScreenState createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> {
  final CategoriesService _categoriesService = CategoriesService();
  final BrandsService _brandsService = BrandsService();
  final AuthService _authService = AuthService();

  /// Родительские категории (у каждой внутри [children]).
  List<category.CategoryItems> categories = [];
  List<BrandItems> brands = [];

  bool isLoadingCategories = true;
  bool isLoadingBrands = true;

  /// Выбранные категории (ID).
  Set<String> _selectedCategoryIds = {};

  /// Выбранные бренды (ID).
  Set<String> _selectedBrandIds = {};
  final TextEditingController address = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController otpCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadBrands();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleSendSms() async {
    if (_isLoading) return; // Блокируем повторное нажатие во время загрузки

    setState(() {
      _isLoading = true;
    });

    String phoneNumber =
        phoneNumberController.text.replaceAll(RegExp(r'[^\d+]'), '');

    try {
      final response = await _authService.fetchOtpId(context, phoneNumber);

      final isRegistered = response['isRegistered'] as bool;
      final otpId = response['otpId'] as String;

      if (isRegistered == false) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CodeInputRegister(
                    otpId: otpId,
                    phoneNumber: phoneNumberController.text,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    longitude: longitude,
                    latitude: latitude,
                    address: address.text,
                    shopName: shopNameController.text,
                    selectedCategoryIds: _selectedCategoryIds.toList(),
                    selectedBrandIds: _selectedBrandIds.toList(),
                  )),
        );
      } else {
        print('Регистрация есть');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Такой номер уже был зарегистрирован $e',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.grey[600],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCategories() async {
    try {
      setState(() => isLoadingCategories = true);

      // 1. Загружаем список родительских категорий
      final parentResponse =
          await _categoriesService.fetchCategoriesParent(context);
      // 2. Загружаем полный список категорий
      final allCategoriesResponse =
          await _categoriesService.fetchCategories(context);

      if (!mounted) return;

      setState(() {
        final parentCategories = parentResponse.items ?? [];
        final allCats = allCategoriesResponse.items ?? [];

        // У каждого родителя заполняем поле .children
        categories = parentCategories.map((parent) {
          parent.children =
              allCats.where((c) => c.parentId == parent.id).toList();
          return parent;
        }).toList();

        isLoadingCategories = false;
      });
    } catch (e) {
      setState(() => isLoadingCategories = false);
      _showError('Ошибка загрузки категорий: $e');
    }
  }

  // ------------------- ЗАГРУЗКА БРЕНДОВ -------------------
  Future<void> _loadBrands() async {
    try {
      setState(() => isLoadingBrands = true);

      final response = await _brandsService.fetchBrands(context);
      if (!mounted) return;

      setState(() {
        brands = response.items ?? [];
        isLoadingBrands = false;
      });
    } catch (e) {
      setState(() => isLoadingBrands = false);
      _showError('Ошибка загрузки брендов: $e');
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

  Future<Set<String>?> _showCategoryDialog() async {
    final localSelectedIds = Set<String>.from(_selectedCategoryIds);

    return showModalBottomSheet<Set<String>?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        // Переменные для поиска
        String searchQuery = '';
        List<category.CategoryItems> filteredCategories = categories.toList();

        return StatefulBuilder(
          builder: (context, setStateModal) {
            // Если ещё грузим категории
            if (isLoadingCategories) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ThemeColors.orange,
                  ),
                ),
              );
            }

            // Если категорий нет
            if (categories.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Center(
                  child: Text('Список категорий пуст'),
                ),
              );
            }

            // Проверка, выбрана ли категория
            bool isCategorySelected(String id) => localSelectedIds.contains(id);

            // Переключаем чекбокс
            void toggleCategory(String id) {
              setStateModal(() {
                final parentCategory =
                    categories.firstWhereOrNull((cat) => cat.id == id);

                if (parentCategory != null) {
                  // Родительская категория: выбираем/снимаем все её подкатегории
                  final subcategories = parentCategory.children ?? [];
                  if (localSelectedIds.contains(id)) {
                    localSelectedIds.remove(id);
                    for (var subcategory in subcategories) {
                      localSelectedIds.remove(subcategory.id ?? '');
                    }
                  } else {
                    localSelectedIds.add(id);
                    for (var subcategory in subcategories) {
                      localSelectedIds.add(subcategory.id ?? '');
                    }
                  }
                } else {
                  // Это подкатегория: просто переключаем её выбор
                  if (localSelectedIds.contains(id)) {
                    localSelectedIds.remove(id);
                  } else {
                    localSelectedIds.add(id);
                  }

                  // Если все подкатегории выбраны, выбираем родителя
                  for (var category in categories) {
                    final children = category.children ?? [];
                    final allChildrenSelected = children
                        .every((child) => localSelectedIds.contains(child.id));

                    if (allChildrenSelected) {
                      localSelectedIds.add(category.id ?? '');
                    } else {
                      localSelectedIds.remove(category.id ?? '');
                    }
                  }
                }
              });
            }

            // Фильтрация
            void filterCategories(String query) {
              setStateModal(() {
                searchQuery = query.trim().toLowerCase();
                filteredCategories = categories.where((cat) {
                  final catName = cat.name?.toLowerCase() ?? '';
                  return catName.contains(searchQuery);
                }).toList();
              });
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  // Поиск
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
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
                            onChanged: filterCategories,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context, null),
                        ),
                      ],
                    ),
                  ),

                  // Список родительских + детей
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final parentCategory = filteredCategories[index];
                        final subcategories = parentCategory.children ?? [];

                        final selectedSubcategoriesCount = subcategories
                            .where((subcategory) =>
                                isCategorySelected(subcategory.id ?? ''))
                            .length;

                        return Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors
                                .white, // Устанавливаем цвет разделителя (по умолчанию черный)
                          ),
                          child: ExpansionTile(
                            leading: Checkbox(
                              value:
                                  isCategorySelected(parentCategory.id ?? ''),
                              onChanged: (val) {
                                toggleCategory(parentCategory.id ?? '');
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                              checkColor: ThemeColors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.green;
                                }
                                return Colors.grey.shade100;
                              }),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    parentCategory.name ?? 'Без названия',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                if (selectedSubcategoriesCount > 0) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '$selectedSubcategoriesCount',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            children: subcategories.map((subcategory) {
                              return Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: ListTile(
                                  leading: Checkbox(
                                    value: isCategorySelected(
                                        subcategory.id ?? ''),
                                    onChanged: (val) {
                                      toggleCategory(subcategory.id ?? '');
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey.shade400,
                                      width: 1,
                                    ),
                                    checkColor: ThemeColors.white,
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return Colors.green;
                                      }
                                      return Colors.grey.shade100;
                                    }),
                                  ),
                                  title:
                                      Text(subcategory.name ?? 'Без названия'),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),

                  // const Divider(),

                  // Блок выбранных
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 35, left: 15, right: 15),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, localSelectedIds);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeColors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Подтвердить',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<Set<String>?> _showBrandDialog() async {
    final localSelectedBrandIds = Set<String>.from(_selectedBrandIds);

    return showModalBottomSheet<Set<String>?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        if (isLoadingBrands) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: const Center(
              child: CircularProgressIndicator(
                color: ThemeColors.orange,
              ),
            ),
          );
        }

        if (brands.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: const Center(
              child: Text('Список брендов пуст'),
            ),
          );
        }

        String searchQuery = '';
        List<BrandItems> filteredBrands = brands.toList();

        return StatefulBuilder(
          builder: (context, setStateModal) {
            bool isBrandSelected(String brandId) {
              return localSelectedBrandIds.contains(brandId);
            }

            void toggleBrand(String brandId) {
              setStateModal(() {
                if (localSelectedBrandIds.contains(brandId)) {
                  localSelectedBrandIds.remove(brandId);
                } else {
                  localSelectedBrandIds.add(brandId);
                }
              });
            }

            void filterBrands(String query) {
              setStateModal(() {
                searchQuery = query.trim().toLowerCase();
                filteredBrands = brands.where((brand) {
                  final name = brand.name?.toLowerCase() ?? '';
                  return name.contains(searchQuery);
                }).toList();
              });
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  // Поисковая строка
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
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
                            onChanged: filterBrands,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context, null),
                        ),
                      ],
                    ),
                  ),

                  // Список брендов + чекбоксы (слева)
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredBrands.length,
                      itemBuilder: (context, index) {
                        final brand = filteredBrands[index];
                        final brandId = brand.id ?? '';

                        return ListTile(
                          leading: Checkbox(
                            value: isBrandSelected(brandId),
                            onChanged: (val) => toggleBrand(brandId),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // Закругляем углы
                            ),
                            side: BorderSide(
                              color:
                                  Colors.grey.shade400, // Тонкий серый бордер
                              width: 1, // Толщина бордера
                            ),
                            checkColor: ThemeColors.white, // Цвет галочки
                            fillColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors
                                    .green; // Цвет при активном состоянии
                              }
                              return Colors.grey
                                  .shade100; // Цвет при неактивном состоянии
                            }),
                          ),
                          title: Text(brand.name ?? 'Без названия'),
                          onTap: () => toggleBrand(brandId),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 35, left: 15, right: 15),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, localSelectedBrandIds);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeColors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Подтвердить',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        // Убираем фокус при нажатии вне текстовых полей
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // Основная часть
            Form(
              key: _formKey,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      CustomEditableField(
                        title: "Имя",
                        value: "",
                        onChanged: (value) {
                          firstNameController.text = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomEditableField(
                        title: 'Фамилия',
                        value: '',
                        onChanged: (value) {
                          lastNameController.text = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomEditableField(
                        title: "Название магазина",
                        value: "",
                        onChanged: (value) {
                          shopNameController.text = value;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Выбор категорий (множественный выбор)
                      CustomDropdownField(
                        title: 'Категории',
                        value: _selectedCategoryIds.isEmpty
                            ? 'Выберите категорию'
                            : 'Выбрано: ${_selectedCategoryIds.length}',
                        onTap: () async {
                          FocusScope.of(context).unfocus(); // Снять фокус
                          final result = await _showCategoryDialog();
                          if (result != null) {
                            setState(() {
                              _selectedCategoryIds = result;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Выбор брендов (множественный выбор)
                      CustomDropdownField(
                        title: 'Бренды',
                        value: _selectedBrandIds.isEmpty
                            ? 'Выберите бренд'
                            : 'Выбрано: ${_selectedBrandIds.length}',
                        onTap: () async {
                          FocusScope.of(context).unfocus(); // Снять фокус
                          final result = await _showBrandDialog();
                          if (result != null) {
                            setState(() {
                              _selectedBrandIds = result;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Поле для кода из СМС
                      OTPInputField(
                        title: 'Введите свой номер',
                        onChanged: (value) {
                          phoneNumberController.text = value;
                        },
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: CustomEditableField(
                              title: 'Адрес',
                              value: address.text,
                              onChanged: (value) {
                                // Логика обработки адреса
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus(); // Снять фокус
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const YandexMapPickerScreen(),
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  address.text = result['address'];
                                  latitude = result['latitude'];
                                  longitude = result['longitude'];
                                  print(
                                      'Полученный адрес: ${result['address']}');
                                  print(
                                      'Координаты: lat=$latitude, lng=$longitude');
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.location_pin,
                              size: 30,
                              color: Colors.grey,
                            ),
                            tooltip: 'Открыть карту',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Кнопка "Зарегистрироваться"
            Padding(
              padding: const EdgeInsets.only(bottom: 45, left: 12, right: 12),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSendSms,
                style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.orange,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Зарегистрироваться',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
