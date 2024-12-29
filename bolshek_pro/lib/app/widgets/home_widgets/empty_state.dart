import 'package:bolshek_pro/app/pages/home/add_name_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductNameInputPage()),
            );
          },
          child: SvgPicture.asset(
            'assets/svg/add_good.svg',
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Добавьте первый товар',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'И начните продавать\nв Магазине на Bolshek.kz',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
