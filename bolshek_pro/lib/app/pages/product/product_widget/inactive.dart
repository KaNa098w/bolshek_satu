// import 'package:bolshek_pro/app/pages/product/product_detail_screen.dart';
// import 'package:bolshek_pro/app/widgets/loading_widget.dart';
// import 'package:bolshek_pro/core/models/product_response.dart';
// import 'package:bolshek_pro/core/service/product_service.dart';
// import 'package:bolshek_pro/app/widgets/home_widgets/add_name_product_page.dart';
// import 'package:bolshek_pro/app/widgets/custom_button.dart';
// import 'package:bolshek_pro/core/utils/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Inactive extends StatefulWidget {
//   const Inactive({Key? key}) : super(key: key);

//   @override
//   State<Inactive> createState() => _Inactive();
// }

// class _Inactive extends State<Inactive> {
//   final ProductService _productService = ProductService();
//   final List<ProductItems> _products = [];
//   final ScrollController _scrollController = ScrollController();
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _skip = 0;
//   final int _take = 25;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProducts();

//     // Добавляем обработчик для прокрутки
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         _fetchProducts();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose(); // Очищаем контроллер
//     super.dispose();
//   }

//   Future<void> _fetchProducts() async {
//     if (_isLoading || !_hasMore) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await _productService.fetchProductsPaginated(
//           context: context, take: _take, skip: _skip, status: 'inactive');

//       setState(() {
//         _products.addAll(response.items ?? []);
//         _skip += _take;
//         _hasMore = (response.items?.length ?? 0) == _take;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ошибка загрузки: $e')),
//       );
//     }
//   }

//   Future<void> _refreshProducts() async {
//     setState(() {
//       _products.clear(); // Очищаем текущий список
//       _skip = 0; // Сбрасываем позицию для пагинации
//       _hasMore = true; // Сбрасываем индикатор наличия данных
//     });
//     await _fetchProducts(); // Загружаем данные заново
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ThemeColors.greyF,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 5.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   // Оборачиваем ListView в RefreshIndicator
//                   RefreshIndicator(
//                     color: ThemeColors.orange,
//                     onRefresh: _refreshProducts, // Метод обновления данных
//                     child: ListView.builder(
//                       controller: _scrollController, // Привязываем контроллер
//                       itemCount: _products.length + (_hasMore ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index == _products.length) {
//                           // Загрузчик внизу списка
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 16.0, horizontal: 10),
//                             child: Center(
//                               child: Column(
//                                 children: List.generate(
//                                   4, // Количество повторений
//                                   (index) => Padding(
//                                     padding: const EdgeInsets.only(
//                                         bottom: 10), // Отступ между строками
//                                     child: Row(
//                                       children: [
//                                         // Левая часть загрузочного индикатора
//                                         LoadingWidget(
//                                           width: 80, // Меньшая ширина
//                                           height: 70, // Высота строки товара
//                                         ),
//                                         const SizedBox(
//                                             width: 10), // Отступ между частями
//                                         // Правая часть загрузочного индикатора
//                                         LoadingWidget(
//                                           width: 280, // Большая ширина
//                                           height: 70, // Высота строки товара
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }

//                         final product = _products[index];
//                         return _buildProductItem(
//                           name: product.name ?? 'Без названия',
//                           price: product.variants != null &&
//                                   product.variants!.isNotEmpty
//                               ? '${_formatPriceWithSpaces((product.variants!.first.price?.amount ?? 0) / 100)} ₸'
//                               : 'Цена не указана',
//                           imageUrl: product.images?.isNotEmpty == true
//                               ? product.images!.first.getBestFitImage() ?? ''
//                               : '',
//                           productId: product.id ?? '',
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0, top: 5),
//               child: CustomButton(
//                 text: 'Добавить новый товар',
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ProductNameInputPage(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatPriceWithSpaces(double price) {
//     final formatter = NumberFormat("#,###", "ru_RU"); // Формат с пробелами
//     return formatter
//         .format(price)
//         .replaceAll(',', ' '); // Заменяем запятые на пробелы
//   }

//   Widget _buildProductItem({
//     required String name,
//     required String price,
//     required String imageUrl,
//     required String productId,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ShopProductDetailScreen(productId: productId),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Блок изображения (80x80)
//               ConstrainedBox(
//                 constraints: const BoxConstraints(
//                   minWidth: 80,
//                   minHeight: 80,
//                   maxWidth: 80,
//                   maxHeight: 80,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: imageUrl.isEmpty
//                       ? const Icon(
//                           Icons.image,
//                           size: 50,
//                           color: Colors.grey,
//                         )
//                       : Image.network(
//                           imageUrl,
//                           fit: BoxFit.contain,
//                         ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               // Блок с названием и ценой
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                         height: 1.3,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       price,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Иконка "троеточие"
//               IconButton(
//                 icon: const Icon(Icons.more_vert),
//                 onPressed: () {
//                   // Обработка нажатия на троеточие
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
