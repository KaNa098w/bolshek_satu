import 'package:bolshek_pro/core/models/tags_response.dart';

class ProductResponse {
  List<ProductItems>? items;
  int? total;

  ProductResponse({this.items, this.total});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ProductItems>[];
      json['items'].forEach((v) {
        items!.add(ProductItems.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    return data;
  }
}

class ProductItems {
  String? id;
  String? createdAt;
  String? status;
  String? name;
  String? slug;
  Description? description;
  String? vendorCode;
  String? deliveryType;
  List<Images>? images;
  List<String>? compatibleVehicleIds; // Изменено на List<String>
  String? brandId;
  String? categoryId;
  String? crossNumber;
  String? kind;
  int? quantity;
  String? sku;
  String? manufacturerId;
  Price? basePrice;
  Price? price;
  Price? discountedPrice;
  Manufacturer? manufacturer;
  int? discountPercent;
  // List<Variants>? variants;
  List<Properties>? properties;
  List<ItemsTags>? tags;

  ProductItems(
      {this.id,
      this.createdAt,
      this.status,
      this.name,
      this.slug,
      this.description,
      this.vendorCode,
      this.deliveryType,
      this.images,
      this.compatibleVehicleIds,
      this.brandId,
      this.categoryId,
      this.crossNumber,
      this.kind,
      this.quantity,
      this.sku,
      this.manufacturerId,
      this.basePrice,
      this.price,
      this.discountedPrice,
      this.manufacturer,
      this.discountPercent,
      // this.variants,

      this.properties,
      this.tags});

  factory ProductItems.fromJson(Map<String, dynamic> json) {
    // --- парсим картинки сразу, чтобы не плодить null-проверок
    final images = (json['images'] as List<dynamic>? ?? [])
        .map((v) => Images.fromJson(v))
        .toList();

    return ProductItems(
      id: json['id'],
      createdAt: json['createdAt'],
      // updatedAt: json['updatedAt'],
      status: json['status'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'] != null
          ? Description.fromJson(json['description'])
          : null,
      vendorCode: json['vendorCode'],
      deliveryType: json['deliveryType'],
      images: images,
      compatibleVehicleIds:
          (json['compatibleVehicleIds'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      brandId: json['brandId'],
      categoryId: json['categoryId'],
      crossNumber: json['crossNumber'],
      // «вариант»
      kind: json['kind'],
      quantity: json['quantity'],
      sku: json['sku'],
      manufacturerId: json['manufacturerId'],
      basePrice:
          json['basePrice'] != null ? Price.fromJson(json['basePrice']) : null,
      price: json['price'] != null ? Price.fromJson(json['price']) : null,
      discountedPrice: json['discountedPrice'] != null
          ? Price.fromJson(json['discountedPrice'])
          : null,
      manufacturer: json['manufacturer'] != null
          ? Manufacturer.fromJson(json['manufacturer'])
          : null,
      discountPercent: json['discountPercent'],
      // коллекции
      // variants: (json['variants'] as List<dynamic>? ?? [])
      //     .map((v) => VariantLegacy.fromJson(v))
      //     .toList(),
      properties: (json['properties'] as List<dynamic>? ?? [])
          .map((v) => Properties.fromJson(v))
          .toList(),
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((v) => ItemsTags.fromJson(v))
          .toList(),
    );
  }

  get isNotEmpty => null;

  Map<String, dynamic> toJson() => {
        // продукт
        'id': id,
        'createdAt': createdAt,
        // if (updatedAt != null) 'updatedAt': updatedAt,
        'status': status,
        'name': name,
        'slug': slug,
        if (description != null) 'description': description!.toJson(),
        if (vendorCode != null) 'vendorCode': vendorCode,
        if (deliveryType != null) 'deliveryType': deliveryType,
        'images': images!.map((e) => e.toJson()).toList(),
        'compatibleVehicleIds': compatibleVehicleIds,
        if (brandId != null) 'brandId': brandId,
        if (categoryId != null) 'categoryId': categoryId,
        if (crossNumber != null) 'crossNumber': crossNumber,
        // «вариант»
        if (kind != null) 'kind': kind,
        if (quantity != null) 'quantity': quantity,
        if (sku != null) 'sku': sku,
        if (manufacturerId != null) 'manufacturerId': manufacturerId,
        if (basePrice != null) 'basePrice': basePrice!.toJson(),
        if (price != null) 'price': price!.toJson(),
        if (discountedPrice != null)
          'discountedPrice': discountedPrice!.toJson(),
        if (manufacturer != null) 'manufacturer': manufacturer!.toJson(),
        if (discountPercent != null) 'discountPercent': discountPercent,
        // коллекции
        // if (variants.isNotEmpty)
        //   'variants': variants.map((e) => e.toJson()).toList(),
        if (properties!.isNotEmpty)
          'properties': properties!.map((e) => e.toJson()).toList(),
        if (tags!.isNotEmpty) 'tags': tags!.map((e) => e.toJson()).toList(),
      };
}

/// --- Производитель ---------------------------------------------------------
class Manufacturer {
  final String id;
  final String createdAt;
  final String name;

  Manufacturer({
    required this.id,
    required this.createdAt,
    required this.name,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) => Manufacturer(
        id: json['id'],
        createdAt: json['createdAt'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'name': name,
      };
}

class Description {
  int? time;
  List<Blocks>? blocks;
  String? version;

  Description({this.time, this.blocks, this.version});

  Description.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    if (json['blocks'] != null) {
      blocks = <Blocks>[];
      json['blocks'].forEach((v) {
        blocks!.add(new Blocks.fromJson(v));
      });
    }
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    if (this.blocks != null) {
      data['blocks'] = this.blocks!.map((v) => v.toJson()).toList();
    }
    data['version'] = this.version;
    return data;
  }
}

class Blocks {
  String? id;
  Data? data;
  String? type;

  Blocks({this.id, this.data, this.type});

  Blocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Data {
  String? text;

  Data({this.text});

  Data.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class Images {
  String? url;
  List<Sizes>? sizes;
  int? width;
  String? format;
  int? height;
  String? blurhash;

  Images(
      {this.url,
      this.sizes,
      this.width,
      this.format,
      this.height,
      this.blurhash});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    if (json['sizes'] != null) {
      sizes = <Sizes>[];
      json['sizes'].forEach((v) {
        sizes!.add(new Sizes.fromJson(v));
      });
    }
    width = json['width'];
    format = json['format'];
    height = json['height'];
    blurhash = json['blurhash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    if (this.sizes != null) {
      data['sizes'] = this.sizes!.map((v) => v.toJson()).toList();
    }
    data['width'] = this.width;
    data['format'] = this.format;
    data['height'] = this.height;
    data['blurhash'] = this.blurhash;
    return data;
  }

  String? getBestFitImage({int maxWidth = 80, int maxHeight = 80}) {
    if (sizes != null && sizes!.isNotEmpty) {
      final filteredSizes = sizes!
          .where((size) => size.width != null && size.height != null)
          .where((size) => size.width! <= maxWidth && size.height! <= maxHeight)
          .toList();

      if (filteredSizes.isNotEmpty) {
        filteredSizes.sort(
            (a, b) => (a.width! * a.height!).compareTo(b.width! * b.height!));
        return filteredSizes.first.url; // Самый маленький подходящий размер
      }
    }
    return url; // Если подходящего размера нет, возвращаем основной URL
  }
}

class Sizes {
  int? width;
  int? height;
  String? url;

  Sizes({this.width, this.height, this.url});

  Sizes.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['url'] = this.url;
    return data;
  }
}

class Variants {
  String? id;
  String? createdAt;
  String? kind;
  int? quantity;
  String? sku;
  String? productId;
  String? manufacturerId;
  Price? price;
  DiscountedPrice? discountedPrice;
  Manufacturer? manufacturer;
  int? discountPercent;

  Variants(
      {this.id,
      this.createdAt,
      this.kind,
      this.quantity,
      this.sku,
      this.productId,
      this.manufacturerId,
      this.price,
      this.discountedPrice,
      this.manufacturer,
      this.discountPercent});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    kind = json['kind'];
    quantity = json['quantity'];
    sku = json['sku'];
    productId = json['productId'];
    manufacturerId = json['manufacturerId'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    discountedPrice = json['discountedPrice'] != null
        ? new DiscountedPrice.fromJson(json['discountedPrice'])
        : null;

    manufacturer = json['manufacturer'] != null
        ? new Manufacturer.fromJson(json['manufacturer'])
        : null;
    discountPercent = json['discountPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['kind'] = this.kind;
    data['quantity'] = this.quantity;
    data['sku'] = this.sku;
    data['productId'] = this.productId;
    data['manufacturerId'] = this.manufacturerId;
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.discountedPrice != null) {
      data['discountedPrice'] = this.discountedPrice!.toJson();
    }
    if (this.manufacturer != null) {
      data['manufacturer'] = this.manufacturer!.toJson();
    }
    data['discountPercent'] = this.discountPercent;
    return data;
  }
}

class Price {
  int? amount;
  int? precision;
  String? currency;

  Price({this.amount, this.precision, this.currency});

  Price.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    precision = json['precision'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['precision'] = this.precision;
    data['currency'] = this.currency;
    return data;
  }
}

class DiscountedPrice {
  int? amount;
  int? precision;
  String? currency;

  DiscountedPrice({this.amount, this.precision, this.currency});

  DiscountedPrice.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    precision = json['precision'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['precision'] = this.precision;
    data['currency'] = this.currency;
    return data;
  }
}

class Properties {
  String? id;
  String? createdAt;
  String? value;
  String? propertyId;
  String? productId;
  Property? property;

  Properties(
      {this.id,
      this.createdAt,
      this.value,
      this.propertyId,
      this.productId,
      this.property});

  Properties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    value = json['value'];
    propertyId = json['propertyId'];
    productId = json['productId'];
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['value'] = this.value;
    data['propertyId'] = this.propertyId;
    data['productId'] = this.productId;
    if (this.property != null) {
      data['property'] = this.property!.toJson();
    }
    return data;
  }
}

class Property {
  String? id;
  String? createdAt;
  String? name;
  String? type;
  String? unit; // Изменено с Null? на String?
  String? categoryId;

  Property({
    this.id,
    this.createdAt,
    this.name,
    this.type,
    this.unit,
    this.categoryId,
  });

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    type = json['type'];
    unit = json['unit']; // Парсинг строки
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['name'] = name;
    data['type'] = type;
    data['unit'] = unit;
    data['categoryId'] = categoryId;
    return data;
  }
}
