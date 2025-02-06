import 'dart:convert';

class OrderItemsResponse {
  final List<OrderItem> items;
  final int total;

  OrderItemsResponse({required this.items, required this.total});

  factory OrderItemsResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemsResponse(
      items: (json['items'] as List).map((e) => OrderItem.fromJson(e)).toList(),
      total: json['total'],
    );
  }
}

class OrderItem {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String type;
  final String status;
  final String reason;
  final String comment;
  final String? sellerRejectComment;
  final String customerId;
  final String? orderId;
  final String orderItemId;
  final OrderItemDetails orderItem;

  OrderItem({
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

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
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
      orderItem: OrderItemDetails.fromJson(json['orderItem']),
    );
  }
}

class OrderItemDetails {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final String orderId;
  final String productId;
  final String productVariantId;
  final Price price;
  final Price totalPrice;
  final Product product;

  OrderItemDetails({
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

  factory OrderItemDetails.fromJson(Map<String, dynamic> json) {
    return OrderItemDetails(
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
}

class Price {
  final int amount;
  final int precision;
  final String currency;

  Price(
      {required this.amount, required this.precision, required this.currency});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: json['amount'],
      precision: json['precision'],
      currency: json['currency'],
    );
  }
}

class Product {
  final String id;
  final String name;
  final String slug;
  final String vendorCode;
  final String deliveryType;
  final List<ImagesReturn> images;

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
          .map((e) => ImagesReturn.fromJson(e))
          .toList(),
    );
  }
}

class ImagesReturn {
  final String url;
  final int size;
  final List<ImageSize> sizes;

  ImagesReturn({required this.url, required this.size, required this.sizes});

  factory ImagesReturn.fromJson(Map<String, dynamic> json) {
    return ImagesReturn(
      url: json['url'],
      size: json['size'],
      sizes: (json['sizes'] as List).map((e) => ImageSize.fromJson(e)).toList(),
    );
  }
}

class ImageSize {
  final int width;
  final int height;
  final String url;

  ImageSize({required this.width, required this.height, required this.url});

  factory ImageSize.fromJson(Map<String, dynamic> json) {
    return ImageSize(
      width: json['width'],
      height: json['height'],
      url: json['url'],
    );
  }
}
