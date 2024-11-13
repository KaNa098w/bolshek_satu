import 'package:bolshek_pro/ui/pages/home/home_widgets/add_product_page.dart';
import 'package:bolshek_pro/ui/widgets/custom_button.dart';
import 'package:bolshek_pro/utils/theme.dart';
import 'package:flutter/material.dart';

class OnSale extends StatelessWidget {
  const OnSale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        'name': 'Elf Evolution 700 STI 10/40',
        'price': '4 250 ₸',
        'imageUrl':
            'https://sus.bolshek.com/mNDiks1sPNMXhkKIwVwZ4Tg3iNBiFqeNpgnAIZxM_AA/f:jpg/w:200/h:200/q:90/rs:auto/aHR0cHM6Ly9jZG4tcHJvZHVjdHMuYm9sc2hlay5jb20vOTIyY2FiNDctMDRmYy00MzcyLTllMzEtODZhMjU1YjM4Zjk0Lzg3MGE3ZGYwMWUwNzc0NDg1MDQxZjFjZWJhOTkxY2JmMWQ2YTdhMDA3YzY1MzU4MzVhM2E2MTcwODIyMmY0YjkuanBn'
      },
      {
        'name': '3РК668 Поликлиновый ремень Chevrolet Spark, Daewoo',
        'price': '5 500 ₸',
        'imageUrl':
            'https://sus.bolshek.com/c7KK_oFTYwS3j1017gTWMlm9jDPleVXQKyQIkmB3d6s/f:jpg/w:320/h:320/q:90/rs:auto/aHR0cHM6Ly9jZG4tcHJvZHVjdHMuYm9sc2hlay5jb20vMTQ0MWVlOTEtZTU5ZC00MzM4LWE2N2YtMmZmOGYyNjQyMGY5L2Y3NDE4M2NlOGE1MTY5NjRmNmMxMDA4MTA5OTgzOWQ1Yzg0MTZlYmVmODhhNTMwYjYwMTM3MWEyMTg1NjM3YTEuanBn'
      },
      {
        'name':
            'Серьги MIRSADO GOLD серьги монетка желтое золото вес 2.78 г золото, без вставок',
        'price': '1 500 ₸',
        'imageUrl':
            'https://sus.bolshek.com/wJgn-PtWsHJKe34seUSD7ywcIX99aXpx1waKJJL0UQg/f:jpg/w:320/h:320/q:90/rs:auto/aHR0cHM6Ly9jZG4tcHJvZHVjdHMuYm9sc2hlay5jb20vMjlhZTMyNGYtNzk4Ny00OTZmLWJkMTQtNjhiZTZmZWFmNWVjLzIxNWQwMjczZTNlODBlODAzYTJkODljMmM5NTYyNGNkYjY3NDdiMGRlODhjZWJkZmMxYzkwNDM1ZjFiMDEzYmQuanBn'
      },
      {
        'name': 'Elf Evolution 700 STI 10/40',
        'price': '4 250 ₸',
        'imageUrl':
            'https://sus.bolshek.com/mNDiks1sPNMXhkKIwVwZ4Tg3iNBiFqeNpgnAIZxM_AA/f:jpg/w:200/h:200/q:90/rs:auto/aHR0cHM6Ly9jZG4tcHJvZHVjdHMuYm9sc2hlay5jb20vOTIyY2FiNDctMDRmYy00MzcyLTllMzEtODZhMjU1YjM4Zjk0Lzg3MGE3ZGYwMWUwNzc0NDg1MDQxZjFjZWJhOTkxY2JmMWQ2YTdhMDA3YzY1MzU4MzVhM2E2MTcwODIyMmY0YjkuanBn'
      },
      {
        'name': '3РК668 Поликлиновый ремень Chevrolet Spark, Daewoo',
        'price': '5 500 ₸',
        'imageUrl':
            'https://sus.bolshek.com/c7KK_oFTYwS3j1017gTWMlm9jDPleVXQKyQIkmB3d6s/f:jpg/w:320/h:320/q:90/rs:auto/aHR0cHM6Ly9jZG4tcHJvZHVjdHMuYm9sc2hlay5jb20vMTQ0MWVlOTEtZTU5ZC00MzM4LWE2N2YtMmZmOGYyNjQyMGY5L2Y3NDE4M2NlOGE1MTY5NjRmNmMxMDA4MTA5OTgzOWQ1Yzg0MTZlYmVmODhhNTMwYjYwMTM3MWEyMTg1NjM3YTEuanBn'
      },
    ];

    return Scaffold(
      backgroundColor: ThemeColors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductItem(
                  name: products[index]['name']!,
                  price: products[index]['price']!,
                  imageUrl: products[index]['imageUrl']!,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Добавить новый товар',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddProductPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(
      {required String name, required String price, required String imageUrl}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leading: Container(
        width: 70,
        height: 70,
        color: Colors.grey[300],
        child: imageUrl.isEmpty
            ? const Icon(Icons.image, size: 40, color: Colors.grey)
            : Image.network(imageUrl, fit: BoxFit.cover),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(price,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
      trailing: const Icon(Icons.more_vert),
      onTap: () {
        // Логика при нажатии на товар
      },
    );
  }
}
