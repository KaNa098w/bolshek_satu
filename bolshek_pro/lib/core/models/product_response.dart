// import 'package:bolshek_pro/core/models/fetch_product_response.dart';

// class ProductResponse {
//   List<ProductItems>? items;
//   int? total;

//   ProductResponse({this.items, this.total});

//   ProductResponse.fromJson(Map<String, dynamic> json) {
//     if (json['items'] != null) {
//       items = <ProductItems>[];
//       json['items'].forEach((v) {
//         items!.add(ProductItems.fromJson(v));
//       });
//     }
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (items != null) {
//       data['items'] = items!.map((v) => v.toJson()).toList();
//     }
//     data['total'] = total;
//     return data;
//   }
// }

// class ProductItems {
//   String? id;
//   String? createdAt;
//   String? updatedAt;
//   String? deletedAt;
//   String? createdById;
//   String? deletedById;
//   String? organizationId;
//   String? status;
//   String? name;
//   String? slug;
//   Description? description;
//   String? vendorCode;
//   String? deliveryType;
//   List<Images>? images;
//   List<dynamic>? compatibleVehicleIds;
//   String? brandId;
//   String? categoryId;
//   String? crossNumber;
//   Category? category;
//   List<Variants>? variants;

//   ProductItems({
//     this.id,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     this.createdById,
//     this.deletedById,
//     this.organizationId,
//     this.status,
//     this.name,
//     this.slug,
//     this.description,
//     this.vendorCode,
//     this.deliveryType,
//     this.images,
//     this.compatibleVehicleIds,
//     this.brandId,
//     this.categoryId,
//     this.crossNumber,
//     this.category,
//     this.variants,
//   });

//   ProductItems.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     deletedAt = json['deletedAt'];
//     createdById = json['createdById'];
//     deletedById = json['deletedById'];
//     organizationId = json['organizationId'];
//     status = json['status'];
//     name = json['name'];
//     slug = json['slug'];
//     description = json['description'] != null
//         ? Description.fromJson(json['description'])
//         : null;
//     vendorCode = json['vendorCode'];
//     deliveryType = json['deliveryType'];
//     if (json['images'] != null) {
//       images = <Images>[];
//       json['images'].forEach((v) {
//         images!.add(Images.fromJson(v));
//       });
//     }
//     compatibleVehicleIds = json['compatibleVehicleIds'];
//     brandId = json['brandId'];
//     categoryId = json['categoryId'];
//     crossNumber = json['crossNumber'];
//     category =
//         json['category'] != null ? Category.fromJson(json['category']) : null;
//     if (json['variants'] != null) {
//       variants = <Variants>[];
//       json['variants'].forEach((v) {
//         variants!.add(Variants.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['deletedAt'] = deletedAt;
//     data['createdById'] = createdById;
//     data['deletedById'] = deletedById;
//     data['organizationId'] = organizationId;
//     data['status'] = status;
//     data['name'] = name;
//     data['slug'] = slug;
//     if (description != null) {
//       data['description'] = description!.toJson();
//     }
//     data['vendorCode'] = vendorCode;
//     data['deliveryType'] = deliveryType;
//     if (images != null) {
//       data['images'] = images!.map((v) => v.toJson()).toList();
//     }
//     if (compatibleVehicleIds != null) {
//       data['compatibleVehicleIds'] = compatibleVehicleIds;
//     }
//     data['brandId'] = brandId;
//     data['categoryId'] = categoryId;
//     data['crossNumber'] = crossNumber;
//     if (category != null) {
//       data['category'] = category!.toJson();
//     }
//     if (variants != null) {
//       data['variants'] = variants!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Description {
//   int? time;
//   List<Blocks>? blocks;
//   String? version;

//   Description({this.time, this.blocks, this.version});

//   Description.fromJson(Map<String, dynamic> json) {
//     time = json['time'];
//     if (json['blocks'] != null) {
//       blocks = <Blocks>[];
//       json['blocks'].forEach((v) {
//         blocks!.add(new Blocks.fromJson(v));
//       });
//     }
//     version = json['version'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['time'] = this.time;
//     if (this.blocks != null) {
//       data['blocks'] = this.blocks!.map((v) => v.toJson()).toList();
//     }
//     data['version'] = this.version;
//     return data;
//   }
// }

// class Blocks {
//   String? id;
//   Data? data;
//   String? type;

//   Blocks({this.id, this.data, this.type});

//   Blocks.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//     type = json['type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['type'] = this.type;
//     return data;
//   }
// }

// class Data {
//   String? text;

//   Data({this.text});

//   Data.fromJson(Map<String, dynamic> json) {
//     text = json['text'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['text'] = this.text;
//     return data;
//   }
// }

// class Images {
//   String? url;
//   String? hash;
//   int? size;
//   List<Sizes>? sizes;
//   int? width;
//   String? format;
//   int? height;
//   String? blurhash;

//   Images(
//       {this.url,
//       this.hash,
//       this.size,
//       this.sizes,
//       this.width,
//       this.format,
//       this.height,
//       this.blurhash});

//   Images.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     hash = json['hash'];
//     size = json['size'];
//     if (json['sizes'] != null) {
//       sizes = <Sizes>[];
//       json['sizes'].forEach((v) {
//         sizes!.add(Sizes.fromJson(v));
//       });
//     }
//     width = json['width'];
//     format = json['format'];
//     height = json['height'];
//     blurhash = json['blurhash'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['url'] = url;
//     data['hash'] = hash;
//     data['size'] = size;
//     if (sizes != null) {
//       data['sizes'] = sizes!.map((v) => v.toJson()).toList();
//     }
//     data['width'] = width;
//     data['format'] = format;
//     data['height'] = height;
//     data['blurhash'] = blurhash;
//     return data;
//   }

//   /// Метод для получения самого подходящего URL
//   String? getBestFitImage({int maxWidth = 80, int maxHeight = 80}) {
//     if (sizes != null && sizes!.isNotEmpty) {
//       final filteredSizes = sizes!
//           .where((size) => size.width != null && size.height != null)
//           .where((size) => size.width! <= maxWidth && size.height! <= maxHeight)
//           .toList();

//       if (filteredSizes.isNotEmpty) {
//         filteredSizes.sort(
//             (a, b) => (a.width! * a.height!).compareTo(b.width! * b.height!));
//         return filteredSizes.first.url; // Самый маленький подходящий размер
//       }
//     }
//     return url; // Если подходящего размера нет, возвращаем основной URL
//   }
// }

// class Sizes {
//   int? width;
//   int? height;
//   String? url;

//   Sizes({this.width, this.height, this.url});

//   Sizes.fromJson(Map<String, dynamic> json) {
//     width = json['width'];
//     height = json['height'];
//     url = json['url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['width'] = this.width;
//     data['height'] = this.height;
//     data['url'] = this.url;
//     return data;
//   }
// }

// class Category {
//   String? id;
//   String? createdAt;
//   String? updatedAt;
//   Null? deletedAt;
//   String? createdById;
//   Null? deletedById;
//   String? organizationId;
//   String? name;
//   String? slug;
//   IconsProduct? icon;
//   String? parentId;

//   Category(
//       {this.id,
//       this.createdAt,
//       this.updatedAt,
//       this.deletedAt,
//       this.createdById,
//       this.deletedById,
//       this.organizationId,
//       this.name,
//       this.slug,
//       this.icon,
//       this.parentId});

//   Category.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     deletedAt = json['deletedAt'];
//     createdById = json['createdById'];
//     deletedById = json['deletedById'];
//     organizationId = json['organizationId'];
//     name = json['name'];
//     slug = json['slug'];
//     icon =
//         json['icon'] != null ? new IconsProduct.fromJson(json['icon']) : null;
//     parentId = json['parentId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['deletedAt'] = this.deletedAt;
//     data['createdById'] = this.createdById;
//     data['deletedById'] = this.deletedById;
//     data['organizationId'] = this.organizationId;
//     data['name'] = this.name;
//     data['slug'] = this.slug;
//     if (this.icon != null) {
//       data['icon'] = this.icon!.toJson();
//     }
//     data['parentId'] = this.parentId;
//     return data;
//   }
// }

// class IconsProduct {
//   String? url;
//   String? hash;
//   int? size;
//   List<dynamic>? sizes; // Изменено на List<dynamic> для хранения любых данных
//   int? width;
//   String? format;
//   int? height;
//   String? blurhash;

//   IconsProduct({
//     this.url,
//     this.hash,
//     this.size,
//     this.sizes,
//     this.width,
//     this.format,
//     this.height,
//     this.blurhash,
//   });

//   IconsProduct.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     hash = json['hash'];
//     size = json['size'];
//     sizes = json['sizes']; // Размеры обрабатываются как динамические данные
//     width = json['width'];
//     format = json['format'];
//     height = json['height'];
//     blurhash = json['blurhash'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['url'] = url;
//     data['hash'] = hash;
//     data['size'] = size;
//     if (sizes != null) {
//       data['sizes'] = sizes; // Хранение данных без преобразования
//     }
//     data['width'] = width;
//     data['format'] = format;
//     data['height'] = height;
//     data['blurhash'] = blurhash;
//     return data;
//   }
// }

// class Variants {
//   String? id;
//   String? createdAt;
//   String? kind;
//   int? quantity;
//   String? sku;
//   String? productId;
//   String? manufacturerId;
//   Price? price;
//   DiscountedPrice? discountedPrice;
//   Manufacturer? manufacturer;
//   int? discountPercent;

//   Variants(
//       {this.id,
//       this.createdAt,
//       this.kind,
//       this.quantity,
//       this.sku,
//       this.productId,
//       this.manufacturerId,
//       this.price,
//       this.discountedPrice,
//       this.manufacturer,
//       this.discountPercent});

//   Variants.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     createdAt = json['createdAt'];
//     kind = json['kind'];
//     quantity = json['quantity'];
//     sku = json['sku'];
//     productId = json['productId'];
//     manufacturerId = json['manufacturerId'];
//     price = json['price'] != null ? new Price.fromJson(json['price']) : null;
//     discountedPrice = json['discountedPrice'] != null
//         ? new DiscountedPrice.fromJson(json['discountedPrice'])
//         : null;

//     manufacturer = json['manufacturer'] != null
//         ? new Manufacturer.fromJson(json['manufacturer'])
//         : null;
//     discountPercent = json['discountPercent'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['createdAt'] = this.createdAt;
//     data['kind'] = this.kind;
//     data['quantity'] = this.quantity;
//     data['sku'] = this.sku;
//     data['productId'] = this.productId;
//     data['manufacturerId'] = this.manufacturerId;
//     if (this.price != null) {
//       data['price'] = this.price!.toJson();
//     }
//     if (this.discountedPrice != null) {
//       data['discountedPrice'] = this.discountedPrice!.toJson();
//     }
//     if (this.manufacturer != null) {
//       data['manufacturer'] = this.manufacturer!.toJson();
//     }
//     data['discountPercent'] = this.discountPercent;
//     return data;
//   }
// }

// class Price {
//   int? amount;
//   int? precision;
//   String? currency;

//   Price({this.amount, this.precision, this.currency});

//   Price.fromJson(Map<String, dynamic> json) {
//     amount = json['amount'];
//     precision = json['precision'];
//     currency = json['currency'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['amount'] = this.amount;
//     data['precision'] = this.precision;
//     data['currency'] = this.currency;
//     return data;
//   }
// }

// class DiscountedPrice {
//   int? amount;
//   int? precision;
//   String? currency;

//   DiscountedPrice({this.amount, this.precision, this.currency});

//   DiscountedPrice.fromJson(Map<String, dynamic> json) {
//     amount = json['amount'];
//     precision = json['precision'];
//     currency = json['currency'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['amount'] = this.amount;
//     data['precision'] = this.precision;
//     data['currency'] = this.currency;
//     return data;
//   }
// }
