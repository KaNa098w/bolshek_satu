// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class ShopProductDetailPage extends StatelessWidget {
//   final String name;
//   final double price;
//   final String description;
//   final List<dynamic> images; // Список изображений
//   final Map<String, String> properties; // Характеристики товара

//   const ShopProductDetailPage({
//     Key? key,
//     required this.name,
//     required this.price,
//     required this.description,
//     required this.images,
//     required this.properties,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 16),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             Center(
//               child: Container(
//                 width: 355,
//                 height: 355,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.grey.shade200,
//                 ),
//                 child: Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: [
//                     CarouselSlider.builder(
//                       itemCount: images.length,
//                       itemBuilder: (context, index, realIndex) {
//                         final image = images[index];
//                         return Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 5),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             image: DecorationImage(
//                               image: MemoryImage(image['data']),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         );
//                       },
//                       options: CarouselOptions(
//                         aspectRatio: 1,
//                         viewportFraction: 1,
//                         enableInfiniteScroll: false,
//                         enlargeCenterPage: true,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Text(
//               name,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               name,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Цена: $price ₸',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Divider(color: Colors.grey),
//             const SizedBox(height: 10),
//             const Text(
//               'Описание',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               description,
//               style: const TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Характеристики',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: properties.length,
//               itemBuilder: (context, index) {
//                 final key = properties.keys.elementAt(index);
//                 final value = properties[key];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '$key:',
//                         style:
//                             const TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                       Text(
//                         value!,
//                         style:
//                             const TextStyle(fontSize: 14, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 80),
//           ],
//         ),
//       ),
//     );
//   }
// }
