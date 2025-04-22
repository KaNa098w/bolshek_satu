import 'package:bolshek_pro/app/pages/home/add_name_product_page.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context); // Получаем объект локализации
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
          localizations.add_first_product,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          localizations.empty_state_description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
