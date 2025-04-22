import 'dart:async';
import 'package:bolshek_pro/app/pages/home/add_product_page.dart';
import 'package:bolshek_pro/app/pages/home/with_search_name/add_product_with_name.dart';
import 'package:bolshek_pro/app/widgets/custom_button_for_name.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/custom_editle_drop_down_two.dart';
import 'package:bolshek_pro/app/widgets/custom_editle_drop_down.dart';
import 'package:bolshek_pro/app/widgets/textfield_widget.dart';
import 'package:bolshek_pro/core/models/product_responses.dart';
import 'package:bolshek_pro/core/models/product_response.dart';
import 'package:bolshek_pro/core/service/product_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:intl/intl.dart';

class ProductNameInputPage extends StatefulWidget {
  @override
  _ProductNameInputPageState createState() => _ProductNameInputPageState();
}

class _ProductNameInputPageState extends State<ProductNameInputPage> {
  String _productName = '';
  Timer? _debounce;
  List<ProductItems> _suggestedItems = [];
  final ProductService _productService = ProductService();

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
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          localizations.enter_product_name, // ключ: enter_product_name
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        // Скрываем клавиатуру при нажатии вне поля ввода
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
                    title: localizations
                        .enter_product_name, // ключ: enter_product_name
                    value: _productName,
                    onChanged: _onChanged,
                    focusNode: _focusNode, // Передаём focusNode
                    autofocus: true,
                  ),
                ),
                const SizedBox(height: 5),
                // Кнопка "Не нашли ваш товар? Добавьте сами" показывается только при вводе текста
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
                        const Icon(
                          Icons.add,
                          size: 32,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          localizations
                              .not_found_add_yourself, // ключ: not_found_add_yourself
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 5),
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
                          padding: const EdgeInsets.all(12),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Левая часть с изображением
                                Container(
                                  width: 70,
                                  height: 70,
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
                                const SizedBox(width: 12),
                                // Правая часть с названием и кнопкой
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? "",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CustomButtonForName(
                                          text: localizations
                                              .choose, // ключ: choose
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
                              ],
                            ),
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
