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
  List<OrderProduct> items;
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
      items: List<OrderProduct>.from(
          json['items'].map((x) => OrderProduct.fromJson(x))),
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
  String? address;

  Address({this.id, this.address});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
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
    product = json['product'] != null
        ? new OrderProduct.fromJson(json['product'])
        : null;
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
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
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

  OrderProduct(
      {this.id,
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
      this.categoryId});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    status = json['status'];
    name = json['name'];
    slug = json['slug'];
    vendorCode = json['vendorCode'];
    deliveryType = json['deliveryType'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['compatibleVehicleIds'] != null) {
      compatibleVehicleIds = List<String>.from(json['compatibleVehicleIds']);
    }
    brandId = json['brandId'];
    categoryId = json['categoryId'];
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
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['vendorCode'] = this.vendorCode;
    data['deliveryType'] = this.deliveryType;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.compatibleVehicleIds != null) {
      data['compatibleVehicleIds'] = this.compatibleVehicleIds;
    }
    data['brandId'] = this.brandId;
    data['categoryId'] = this.categoryId;
    return data;
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
    data['hash'] = this.hash;
    data['size'] = this.size;
    if (this.sizes != null) {
      data['sizes'] = this.sizes!.map((v) => v.toJson()).toList();
    }
    data['width'] = this.width;
    data['format'] = this.format;
    data['height'] = this.height;
    data['blurhash'] = this.blurhash;
    return data;
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
