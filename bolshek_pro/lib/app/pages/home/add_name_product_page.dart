import 'dart:async';

import 'package:bolshek_pro/app/pages/home/add_product_page.dart';
import 'package:bolshek_pro/app/pages/home/with_search_name/add_product_with_name.dart';
import 'package:bolshek_pro/app/widgets/custom_button_for_name.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/custom_editle_drop_down_two.dart';
import 'package:bolshek_pro/app/widgets/custom_editle_drop_down.dart';
import 'package:bolshek_pro/app/widgets/textfield_widget.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class ProductNameInputPage extends StatefulWidget {
  @override
  _ProductNameInputPageState createState() => _ProductNameInputPageState();
}

class _ProductNameInputPageState extends State<ProductNameInputPage> {
  String _productName = '';
  Timer? _debounce;
  List<ProductItems> _suggestedItems = [];
  ProductService _productService = ProductService();

  // FocusNode для автофокуса поля ввода
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Запрашиваем фокус после построения экрана, чтобы сразу открывалась клавиатура
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _onChanged(String value) {
    setState(() {
      _productName = value;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      if (value.length > 1) {
        try {
          final response = await _productService.fetchProductsName(
              context: context, name: value);
          setState(() {
            _suggestedItems = response.items ?? [];
          });
        } catch (e) {
          print('Ошибка при получении данных: $e');
        }
      } else {
        setState(() {
          _suggestedItems = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Введите название товара',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        // При нажатии вне поля ввода скрываем клавиатуру
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Поле ввода с автофокусом
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomEditableDropdownFieldTwo(
                    title: 'Введите название товара',
                    value: _productName,
                    onChanged: _onChanged,
                    focusNode: _focusNode, // Передаём focusNode
                    autofocus: true, // Если поддерживается вашим виджетом
                  ),
                ),
                SizedBox(height: 5),
                // Кнопка "Применить" показывается только после ввода текста
                if (_productName.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddProductPage(productName: _productName),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 32,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Не нашли ваш товар? Добавьте сами',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 5),
                // Список найденных товаров
                if (_suggestedItems.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _suggestedItems.map((item) {
                      return Card(
                        color: Colors.grey.shade100,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Первая строка с изображением и названием товара
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 50,
                                      minHeight: 50,
                                      maxWidth: 50,
                                      maxHeight: 50,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: (item.images!.isNotEmpty &&
                                              item.images!.first.sizes!
                                                  .isNotEmpty &&
                                              !(item.images!.first.sizes!.first
                                                  .url!.isEmpty))
                                          ? Image.network(
                                              item.images!.first.sizes!.first
                                                  .url!,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/icons/error_image.png',
                                                  fit: BoxFit.contain,
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              'assets/icons/error_image.png',
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Текст с названием товара, который может занимать несколько строк
                                  Expanded(
                                    child: Text(
                                      item.name ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Кнопка "Выбрать" на правой стороне, размещённая отдельно
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomButtonForName(
                                  text: 'Выбрать',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddProductWithName(
                                          productId: item.id ?? '',
                                          productName: item.name ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
