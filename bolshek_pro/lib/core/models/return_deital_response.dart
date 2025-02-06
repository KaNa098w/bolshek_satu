import 'dart:convert';

class ReturnDetailRespnse {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String type;
  String status;
  String reason;
  String comment;
  String? sellerRejectComment;
  String customerId;
  String? orderId;
  String orderItemId;
  OrderItem orderItem;

  ReturnDetailRespnse({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.status,
    required this.reason,
    required this.comment,
    this.sellerRejectComment,
    required this.customerId,
    this.orderId,
    required this.orderItemId,
    required this.orderItem,
  });

  factory ReturnDetailRespnse.fromJson(Map<String, dynamic> json) {
    return ReturnDetailRespnse(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      type: json['type'],
      status: json['status'],
      reason: json['reason'],
      comment: json['comment'],
      sellerRejectComment: json['sellerRejectComment'],
      customerId: json['customerId'],
      orderId: json['orderId'],
      orderItemId: json['orderItemId'],
      orderItem: OrderItem.fromJson(json['orderItem']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'type': type,
      'status': status,
      'reason': reason,
      'comment': comment,
      'sellerRejectComment': sellerRejectComment,
      'customerId': customerId,
      'orderId': orderId,
      'orderItemId': orderItemId,
      'orderItem': orderItem.toJson(),
    };
  }
}

class OrderItem {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String status;
  String orderId;
  String productId;
  String productVariantId;
  Price price;
  Price totalPrice;
  Product product;

  OrderItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.orderId,
    required this.productId,
    required this.productVariantId,
    required this.price,
    required this.totalPrice,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status'],
      orderId: json['orderId'],
      productId: json['productId'],
      productVariantId: json['productVariantId'],
      price: Price.fromJson(json['price']),
      totalPrice: Price.fromJson(json['totalPrice']),
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status,
      'orderId': orderId,
      'productId': productId,
      'productVariantId': productVariantId,
      'price': price.toJson(),
      'totalPrice': totalPrice.toJson(),
      'product': product.toJson(),
    };
  }
}

class Price {
  int amount;
  int precision;
  String currency;

  Price(
      {required this.amount, required this.precision, required this.currency});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: json['amount'],
      precision: json['precision'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'precision': precision,
      'currency': currency,
    };
  }
}

class Product {
  String id;
  String name;
  String slug;
  String vendorCode;
  String deliveryType;
  List<ProductImage> images;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.vendorCode,
    required this.deliveryType,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      vendorCode: json['vendorCode'],
      deliveryType: json['deliveryType'],
      images: (json['images'] as List)
          .map((i) => ProductImage.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'vendorCode': vendorCode,
      'deliveryType': deliveryType,
      'images': images.map((i) => i.toJson()).toList(),
    };
  }
}

class ProductImage {
  String url;
  int width;
  int height;

  ProductImage({required this.url, required this.width, required this.height});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'width': width,
      'height': height,
    };
  }
}
