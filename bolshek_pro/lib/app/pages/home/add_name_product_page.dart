import 'package:bolshek_pro/app/pages/home/add_product_page.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';

class ProductNameInputPage extends StatefulWidget {
  @override
  _ProductNameInputPageState createState() => _ProductNameInputPageState();
}

class _ProductNameInputPageState extends State<ProductNameInputPage> {
  final TextEditingController _productNameController = TextEditingController();

  void _saveProductName() {
    final productName = _productNameController.text;
    if (productName.isNotEmpty) {
      // Логика сохранения названия товара
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Название товара '$productName' сохранено")),
      );
      _productNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Пожалуйста, введите название товара")),
      );
    }
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
        centerTitle: false, // Заголовок будет выровнен по левому краю
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.2),
                  //     blurRadius: 8,
                  //     offset: Offset(2, 4),
                  //   ),
                  // ],
                ),
                child: TextField(
                  controller: _productNameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Название товара',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: CustomButton(
                  text: 'Применить',
                  onPressed: () {
                    final productName = _productNameController.text;
                    if (productName.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddProductPage(productName: productName),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Пожалуйста, введите название товара")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
