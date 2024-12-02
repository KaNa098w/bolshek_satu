import 'dart:io';
import 'package:bolshek_pro/core/models/category_response.dart' as category;
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/models/brands_response.dart';
import 'package:bolshek_pro/core/models/category_response.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/core/models/fetch_product_response.dart';
import 'package:image_picker/image_picker.dart';

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
  late List<Items> _brands;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _addImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _product!.images!.add(
          Images(url: pickedFile.path), // Добавляем локальный путь как URL
        );
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _product!.images!.removeAt(index);
    });
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
          CustomDropdownField(
            title: 'Название товара',
            value: _product!.name ?? 'Не указано',
            onTap: () {
              print('Нажата строка с названием товара');
            },
            onValueChanged: (newValue) {
              print("Новое значение: $newValue");
            },
            showIcon: false,
          ),
          const SizedBox(height: 10),

          // Статус
          CustomDropdownField(
            title: 'Статус товара',
            value: _product!.status ?? 'Не указано',
            onTap: () {
              print('Нажата строка со статусом товара');
            },
          ),
          const SizedBox(height: 10),

          // Изображения
          if (_product!.images != null && _product!.images!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Изображения:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
          CustomDropdownField(
            title: 'Описание товара',
            value: _product!.description?.blocks?.first.data?.text ??
                'Нет описания',
            onTap: () {
              print('Нажата строка с описанием товара');
            },
            onValueChanged: (newValue) {
              print('Новое значение: $newValue');
            },
            maxLines: 3, // Всегда показывать 3 строки
            showIcon: false,
          ),

          const SizedBox(height: 10),

          // Производитель
          CustomDropdownField(
            title: 'Производитель',
            value: _product!.variants?.first.manufacturer?.name ?? 'Не указано',
            onTap: () {},
          ),
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
          CustomDropdownField(
            title: 'Код товара',
            value: _product?.vendorCode ?? '',
            onTap: () {},
          ),
          const SizedBox(height: 10),

          // Артикул товара
          CustomDropdownField(
            title: 'Артикул товара',
            value: _product?.variants?.first.sku ?? '',
            onTap: () {},
          ),
          const SizedBox(height: 10),

          // Тип
          CustomDropdownField(
            title: 'Тип',
            value: _product?.variants?.first.kind ?? '',
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Обновить товар',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
