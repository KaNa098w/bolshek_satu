class OrdersResponse {
  List<OrderItem>? items;
  int? total;

  OrdersResponse({this.items, this.total});

  OrdersResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <OrderItem>[];
      json['items'].forEach((v) {
        items!.add(new OrderItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class OrderItem {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdById;
  String? deletedById;
  String? organizationId;
  int number;
  String? status;
  String recipientName;
  String recipientNumber;
  String customerId;
  String addressId;
  DeliveryFee deliveryFee;
  DeliveryFee price;
  DeliveryFee totalPrice;
  Address address;
  List<OrderPayments> payments;
  List<Items> items;
  // List<Items> item;
  String? reservedTill;
  bool hasPayment;

  OrderItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    required this.number,
    required this.status,
    required this.recipientName,
    required this.recipientNumber,
    required this.customerId,
    required this.addressId,
    required this.deliveryFee,
    required this.price,
    required this.totalPrice,
    required this.address,
    required this.payments,
    required this.items,
    this.reservedTill,
    required this.hasPayment,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      createdById: json['createdById'],
      deletedById: json['deletedById'],
      organizationId: json['organizationId'],
      number: json['number'],
      status: json['status'],
      recipientName: json['recipientName'],
      recipientNumber: json['recipientNumber'],
      customerId: json['customerId'],
      addressId: json['addressId'],
      deliveryFee: DeliveryFee.fromJson(json['deliveryFee']),
      price: DeliveryFee.fromJson(json['price']),
      totalPrice: DeliveryFee.fromJson(json['totalPrice']),
      address: Address.fromJson(json['address']),
      payments: List<OrderPayments>.from(
          json['payments'].map((x) => OrderPayments.fromJson(x))),
      items: List<Items>.from(json['items'].map((x) => Items.fromJson(x))),
      reservedTill: json['reservedTill'],
      hasPayment: json['hasPayment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'createdById': createdById,
      'deletedById': deletedById,
      'organizationId': organizationId,
      'number': number,
      'status': status,
      'recipientName': recipientName,
      'recipientNumber': recipientNumber,
      'customerId': customerId,
      'addressId': addressId,
      'deliveryFee': deliveryFee.toJson(),
      'price': price.toJson(),
      'totalPrice': totalPrice.toJson(),
      'address': address.toJson(),
      'payments': payments.map((x) => x.toJson()).toList(),
      'items': items.map((x) => x.toJson()).toList(),
      'reservedTill': reservedTill,
      'hasPayment': hasPayment,
    };
  }
}

class DeliveryFee {
  int? amount;
  int? precision;
  String? currency;

  DeliveryFee({this.amount, this.precision, this.currency});

  DeliveryFee.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    precision = json['precision'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'precision': precision,
      'currency': currency,
    };
  }
}

class Address {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdById;
  String? deletedById;
  String? organizationId;
  String? type;
  double? latitude;
  double? longitude;
  String? address;
  String? zipCode;
  String? entrance;
  int? apartment;
  int? floor;
  String? intercom;
  String? additionalInfo;
  String? cityId;
  String? customerId;
  String? partnerId;
  String? relatedOrganizationId;

  Address({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.type,
    this.latitude,
    this.longitude,
    this.address,
    this.zipCode,
    this.entrance,
    this.apartment,
    this.floor,
    this.intercom,
    this.additionalInfo,
    this.cityId,
    this.customerId,
    this.partnerId,
    this.relatedOrganizationId,
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    type = json['type'];

    // latitude / longitude могут прийти как double, int или null:
    latitude = json['latitude'] == null ? null : json['latitude'].toDouble();
    longitude = json['longitude'] == null ? null : json['longitude'].toDouble();

    address = json['address'];
    zipCode = json['zipCode'];
    entrance = json['entrance'];

    // Если "apartment" может быть и int, и null:
    apartment = json['apartment'] as int?; // Прямое приведение к int?
    // Если "floor" может быть null:
    floor = json['floor'] as int?;

    intercom = json['intercom'];
    additionalInfo = json['additionalInfo'];
    cityId = json['cityId'];
    customerId = json['customerId'];
    partnerId = json['partnerId'];
    relatedOrganizationId = json['relatedOrganizationId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'createdById': createdById,
      'deletedById': deletedById,
      'organizationId': organizationId,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'zipCode': zipCode,
      'entrance': entrance,
      'apartment': apartment,
      'floor': floor,
      'intercom': intercom,
      'additionalInfo': additionalInfo,
      'cityId': cityId,
      'customerId': customerId,
      'partnerId': partnerId,
      'relatedOrganizationId': relatedOrganizationId,
    };
  }
}

class OrderPayments {
  String? id;
  String? status;
  String? system;
  DeliveryFee? price;

  OrderPayments({this.id, this.status, this.system, this.price});

  OrderPayments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    system = json['system'];
    price = json['price'] != null ? DeliveryFee.fromJson(json['price']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'system': system,
      'price': price?.toJson(),
    };
  }
}

class Items {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  String? status;
  String? orderId;
  String? productId;
  String? productVariantId;
  DeliveryFee? price;
  DeliveryFee? totalPrice;
  // List<OrderProduct> products;

  OrderProduct? product;
  ProductVariant? productVariant;

  Items(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.status,
      this.orderId,
      this.productId,
      this.productVariantId,
      this.price,
      this.totalPrice,
      //  required this.products,
      this.product,
      this.productVariant});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    status = json['status'];
    orderId = json['orderId'];
    productId = json['productId'];
    productVariantId = json['productVariantId'];
    price =
        json['price'] != null ? new DeliveryFee.fromJson(json['price']) : null;
    totalPrice = json['totalPrice'] != null
        ? new DeliveryFee.fromJson(json['totalPrice'])
        : null;
    product =
        json['product'] != null ? OrderProduct.fromJson(json['product']) : null;
    productVariant = json['productVariant'] != null
        ? new ProductVariant.fromJson(json['productVariant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['createdById'] = this.createdById;
    data['deletedById'] = this.deletedById;
    data['organizationId'] = this.organizationId;
    data['status'] = this.status;
    data['orderId'] = this.orderId;
    data['productId'] = this.productId;
    data['productVariantId'] = this.productVariantId;
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.totalPrice != null) {
      data['totalPrice'] = this.totalPrice!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.productVariant != null) {
      data['productVariant'] = this.productVariant!.toJson();
    }
    return data;
  }
}

class OrderProduct {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt; // Null заменён на String?, так как Null устарело
  String? createdById;
  String? deletedById;
  String? organizationId;
  String? status;
  String? name;
  String? slug;
  String? vendorCode;
  String? deliveryType;
  List<Images>? images;
  List<String>? compatibleVehicleIds;
  String? brandId;
  String? categoryId;

  OrderProduct({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.status,
    this.name,
    this.slug,
    this.vendorCode,
    this.deliveryType,
    this.images,
    this.compatibleVehicleIds,
    this.brandId,
    this.categoryId,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      createdById: json['createdById'] as String?,
      deletedById: json['deletedById'] as String?,
      organizationId: json['organizationId'] as String?,
      status: json['status'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      vendorCode: json['vendorCode'] as String?,
      deliveryType: json['deliveryType'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((item) => Images.fromJson(item as Map<String, dynamic>))
          .toList(),
      compatibleVehicleIds:
          (json['compatibleVehicleIds'] as List<dynamic>?)?.cast<String>(),
      brandId: json['brandId'] as String?,
      categoryId: json['categoryId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'createdById': createdById,
      'deletedById': deletedById,
      'organizationId': organizationId,
      'status': status,
      'name': name,
      'slug': slug,
      'vendorCode': vendorCode,
      'deliveryType': deliveryType,
      'images': images?.map((e) => e.toJson()).toList(),
      'compatibleVehicleIds': compatibleVehicleIds,
      'brandId': brandId,
      'categoryId': categoryId,
    };
  }
}

class Images {
  String? url;
  String? hash;
  int? size;
  List<Sizes>? sizes;
  int? width;
  String? format;
  int? height;
  String? blurhash;

  Images(
      {this.url,
      this.hash,
      this.size,
      this.sizes,
      this.width,
      this.format,
      this.height,
      this.blurhash});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    hash = json['hash'];
    size = json['size'];
    if (json['sizes'] != null) {
      sizes = <Sizes>[];
      json['sizes'].forEach((v) {
        sizes!.add(Sizes.fromJson(v));
      });
    }
    width = json['width'];
    format = json['format'];
    height = json['height'];
    blurhash = json['blurhash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['hash'] = hash;
    data['size'] = size;
    if (sizes != null) {
      data['sizes'] = sizes!.map((v) => v.toJson()).toList();
    }
    data['width'] = width;
    data['format'] = format;
    data['height'] = height;
    data['blurhash'] = blurhash;
    return data;
  }

  /// Метод для получения самого подходящего URL
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

class ProductVariant {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  Null? discoutPercentage;
  String? kind;
  int? quantity;
  String? sku;
  String? productId;
  String? manufacturerId;
  DeliveryFee? basePrice;
  DeliveryFee? price;

  ProductVariant(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.discoutPercentage,
      this.kind,
      this.quantity,
      this.sku,
      this.productId,
      this.manufacturerId,
      this.basePrice,
      this.price});

  ProductVariant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    discoutPercentage = json['discoutPercentage'];
    kind = json['kind'];
    quantity = json['quantity'];
    sku = json['sku'];
    productId = json['productId'];
    manufacturerId = json['manufacturerId'];
    basePrice = json['basePrice'] != null
        ? new DeliveryFee.fromJson(json['basePrice'])
        : null;
    price =
        json['price'] != null ? new DeliveryFee.fromJson(json['price']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['createdById'] = this.createdById;
    data['deletedById'] = this.deletedById;
    data['organizationId'] = this.organizationId;
    data['discoutPercentage'] = this.discoutPercentage;
    data['kind'] = this.kind;
    data['quantity'] = this.quantity;
    data['sku'] = this.sku;
    data['productId'] = this.productId;
    data['manufacturerId'] = this.manufacturerId;
    if (this.basePrice != null) {
      data['basePrice'] = this.basePrice!.toJson();
    }
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    return data;
  }
}
