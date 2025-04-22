import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bolshek_pro/app/pages/home/add_product_page.dart';
import 'package:bolshek_pro/app/pages/home/with_search_name/add_product_with_name.dart';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_button_for_name.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/custom_editle_drop_down_two.dart';
import 'package:bolshek_pro/app/widgets/custom_editle_drop_down.dart';
import 'package:bolshek_pro/app/widgets/textfield_widget.dart';
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/category_response.dart';
import 'package:bolshek_pro/core/models/product_responses.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/service/brands_service.dart';
import 'package:bolshek_pro/core/service/category_service.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class InfoTab extends StatefulWidget {
  final String productName;
  final TabController tabController;
  final Function(String) onCategorySelected;
  final bool Function() validateInfoTab;
  final void Function(String) showError;

  const InfoTab({
    Key? key,
    required this.productName,
    required this.tabController,
    required this.onCategorySelected,
    required this.validateInfoTab,
    required this.showError,
  }) : super(key: key);

  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> with AutomaticKeepAliveClientMixin {
  Map<String, List<PropertyItems>> categoryPropertiesCache = {};
  Map<String, Map<String, String>> propertyValuesCache = {};
  String selectedBrand = S.current.choose_brand; // ключ: choose_brand
  final ProductService _productService = ProductService();
  List<ProductItems> _suggestedItems =
      []; // если используются товары для автодополнения
  List<BrandItems> brands = [];
  List<BrandItems> filteredBrands = [];
  bool isLoading = true;
  String selectedCategory = S.current.choose_category; // ключ: choose_category
  final CategoriesService _categoriesService = CategoriesService();
  List<CategoryItems> categories = [];
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  final TextEditingController _priceController = TextEditingController();
  BrandsService _brandsService = BrandsService();

  bool isLoadingCategories = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadBrands();
    _loadCategories();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File file = File(pickedFile.path);

        // Сжимаем изображение
        final compressedFile = await _compressImage(file);
        if (compressedFile == null) {
          _showError(
              S.of(context).image_compress_error); // ключ: image_compress_error
          return;
        }
        file = compressedFile;
        final fileSize = await file.length();
        if (fileSize > 15 * 1024 * 1024) {
          _showError(S.of(context).file_size_exceed); // ключ: file_size_exceed
          return;
        }
        if (_images.length < 5) {
          final imageData = await prepareImageData(file);
          context.read<GlobalProvider>().addImageData(imageData);
          print('Добавленное изображение: $imageData');
          setState(() {
            _images.add(file);
          });
        } else {
          _showError(
              S.of(context).max_images_exceeded); // ключ: max_images_exceeded
        }
      }
    } catch (e) {
      _showError(
          '${S.of(context).error_selecting_image}: $e'); // ключ: error_selecting_image
    }
  }

  Future<File?> _compressImage(File file) async {
    try {
      final targetPath =
          "${file.parent.path}/compressed_${path.basename(file.path)}";
      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 60,
        minWidth: 1080,
        minHeight: 1080,
      );
      return compressedXFile != null ? File(compressedXFile.path) : null;
    } catch (e) {
      print('Ошибка компрессии изображения: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> prepareImageData(File file) async {
    try {
      final name = path.basename(file.path);
      final size = await file.length();
      final type = file.path.endsWith('.png')
          ? 'image/png'
          : file.path.endsWith('.jpg') || file.path.endsWith('.jpeg')
              ? 'image/jpeg'
              : 'application/octet-stream';
      final bytes = await file.readAsBytes();
      final data = base64Encode(bytes);
      return {
        "name": name,
        "size": size,
        "type": type,
        "data": data,
      };
    } catch (e) {
      throw Exception(
          '${S.of(context).error_processing_file}: $e'); // ключ: error_processing_file
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
                title: Text(S.of(context).camera), // ключ: camera
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: Text(S.of(context).gallery), // ключ: gallery
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: Text(S.of(context).cancel), // ключ: cancel
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
      if (!mounted) return;
      setState(() {
        final parentCategories = parentResponse.items ?? [];
        final allCategories = allCategoriesResponse.items ?? [];
        categories = parentCategories.map((parent) {
          parent.children =
              allCategories.where((cat) => cat.parentId == parent.id).toList();
          return parent;
        }).toList();
        isLoadingCategories = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoadingCategories = false;
      });
      _showError(
          '${S.of(context).error_loading_categories}: $e'); // ключ: error_loading_categories
    }
  }

  Future<void> _loadBrands() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await _brandsService.fetchBrands(context);
      if (mounted) {
        setState(() {
          brands = response.items ?? [];
          filteredBrands = List.from(brands);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      _showError(
          '${S.of(context).error_loading_brands}: $e'); // ключ: error_loading_brands
    }
  }

  void _showCategories() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = '';
        List<CategoryItems> filteredCategories = categories.toList();

        return StatefulBuilder(
          builder: (context, setStateModal) {
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
            if (categories.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                  child: Text(
                      S.of(context).categories_empty), // ключ: categories_empty
                ),
              );
            }
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
                              hintText: S
                                  .of(context)
                                  .category_search, // ключ: category_search
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                            ),
                            onChanged: (value) {
                              setStateModal(() {
                                searchQuery = value.trim().toLowerCase();
                                filteredCategories = categories.where((cat) {
                                  final catName = cat.name?.toLowerCase() ?? '';
                                  return catName.contains(searchQuery);
                                }).toList();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
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
                            title: Text(parentCategory.name ??
                                S.of(context).no_name), // ключ: no_name
                            children: subcategories.map((subcategory) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: ListTile(
                                  title: Text(subcategory.name ??
                                      S.of(context).no_name),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      selectedCategory = subcategory.name ??
                                          S.of(context).no_name;
                                    });
                                    _selectCategory(subcategory.id ?? '');
                                    FocusScope.of(context).unfocus();
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
          title: Text(S.of(context).error), // ключ: error
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).ok), // ключ: ok
            ),
          ],
        );
      },
    );
  }

  void _showBrands() async {
    filteredBrands = List.from(brands);
    final TextEditingController searchController = TextEditingController();
    final FocusNode searchFocusNode = FocusNode();

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
                            controller: searchController,
                            focusNode: searchFocusNode,
                            decoration: InputDecoration(
                              hintText: S
                                  .of(context)
                                  .brand_search, // ключ: brand_search
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                            ),
                            onChanged: (value) {
                              setStateModal(() {
                                filteredBrands = brands
                                    .where((brand) =>
                                        brand.name != null &&
                                        brand.name!
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    filteredBrands.isEmpty
                        ? Center(
                            child: Text(
                                S.of(context).no_brands)) // ключ: no_brands
                        : Expanded(
                            child: ListView.builder(
                              itemCount: filteredBrands.length,
                              itemBuilder: (context, index) {
                                final brand = filteredBrands[index];
                                return ListTile(
                                  title:
                                      Text(brand.name ?? S.of(context).no_name),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      selectedBrand =
                                          brand.name ?? S.of(context).no_name;
                                      context
                                          .read<GlobalProvider>()
                                          .setBrandId(brand.id ?? '');
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: CustomButton(
                        text: S
                            .of(context)
                            .create_your_brand, // ключ: create_your_brand
                        onPressed: () {
                          _showAddBrandDialog(setStateModal);
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

  void _selectCategory(String categoryId) {
    context.read<GlobalProvider>().setCategoryId(categoryId);
    widget.onCategorySelected(categoryId);
  }

  void _showAddBrandDialog(Function setStateModal) {
    String newBrandName = '';
    String selectedType = 'product';
    showCustomAlertDialog(
      context: context,
      title: S.of(context).add_brand, // ключ: add_brand
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText:
                  S.of(context).enter_brand_name, // ключ: enter_brand_name
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
                child: CircularProgressIndicator(
              color: Colors.grey,
            )),
          );
          try {
            await _brandsService.createBrand(
              context,
              selectedType,
              newBrandName,
              newBrandName,
            );
            await _loadBrands();
            if (mounted) {
              setStateModal(() {});
            }
            Navigator.pop(context);
            Navigator.pop(context);
          } catch (e) {
            Navigator.pop(context);
            _showError(
                '${S.of(context).error}: $e'); // ключ: error_adding_brand
          }
        } else {
          _showError(S.of(context).error); // ключ: brand_name_empty
        }
      },
    );
  }

  Widget _buildImagesRow() {
    final List<Widget> children = [];
    if (_images.length < 5) {
      children.add(
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Container(
            margin: const EdgeInsets.only(right: 10),
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
      );
    }
    children.addAll(
      _images.map((image) {
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
              right: 5,
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
    );
    final rowContent = Row(children: children);
    return children.length > 3
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: rowContent,
          )
        : rowContent;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizations = S.of(context);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(color: ThemeColors.orange))
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.upload_photos, // ключ: upload_photos
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    _buildImagesRow(),
                    const SizedBox(height: 20),
                    CustomDropdownField(
                      title: localizations.product_name, // ключ: product_name
                      value: widget.productName.isNotEmpty
                          ? widget.productName
                          : localizations.not_specified, // ключ: not_specified
                      onTap: () {
                        context
                            .read<GlobalProvider>()
                            .setName(widget.productName);
                      },
                      showIcon: false,
                    ),
                    const SizedBox(height: 20),
                    CustomDropdownField(
                      title: localizations.brand, // ключ: brand
                      value: selectedBrand,
                      onTap: _showBrands,
                    ),
                    const SizedBox(height: 20),
                    CustomDropdownField(
                      title: localizations.category, // ключ: category
                      value: selectedCategory,
                      onTap: _showCategories,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText:
                                          localizations.price, // ключ: price
                                      labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                      hintText: localizations
                                          .enter_price, // ключ: enter_price
                                      hintStyle: const TextStyle(
                                          color: ThemeColors.grey5,
                                          fontWeight: FontWeight.w500),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      final price =
                                          (double.tryParse(value) ?? 0.0) * 100;
                                      context
                                          .read<GlobalProvider>()
                                          .setPrice(price);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  localizations
                                      .currency, // ключ: currency (например, KZT)
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    const SizedBox(height: 20),
                    Center(
                      child: CustomButton(
                        text:
                            localizations.continue_text, // ключ: continue_text
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          final price = context.read<GlobalProvider>().price;
                          if (price <= 0) {
                            widget.showError(localizations
                                .enter_valid_price); // ключ: enter_valid_price
                            return;
                          }
                          if (widget.validateInfoTab()) {
                            widget.tabController.index = 1;
                          } else {
                            widget.showError(localizations
                                .fill_required_fields); // ключ: fill_required_fields
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
