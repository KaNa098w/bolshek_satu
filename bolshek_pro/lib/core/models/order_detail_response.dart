// Пример использования:
// final order = orderFromJson(jsonString);
// print(order.address?.address); // => "улица Кахарман, 158"

import 'dart:convert';

// Функции для парсинга из/в JSON
Order orderFromJson(String str) => Order.fromJson(json.decode(str));
String orderToJson(Order data) => json.encode(data.toJson());

// Главный класс заказа
class Order {
  Order({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.number,
    this.status,
    this.recipientName,
    this.recipientNumber,
    this.customerId,
    this.addressId,
    this.deliveryFee,
    this.price,
    this.totalPrice,
    this.address,
    this.payments,
    this.items,
    this.reservedTill,
    this.hasPayment,
  });

  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final dynamic createdById;
  final dynamic deletedById;
  final dynamic organizationId;
  final int? number;
  final String? status;
  final String? recipientName;
  final String? recipientNumber;
  final String? customerId;
  final String? addressId;
  final Price? deliveryFee;
  final Price? price;
  final Price? totalPrice;
  final Address? address;
  final List<Payment>? payments;
  final List<Item>? items;
  final DateTime? reservedTill;
  final bool? hasPayment;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        createdById: json["createdById"],
        deletedById: json["deletedById"],
        organizationId: json["organizationId"],
        number: json["number"],
        status: json["status"],
        recipientName: json["recipientName"],
        recipientNumber: json["recipientNumber"],
        customerId: json["customerId"],
        addressId: json["addressId"],
        deliveryFee: json["deliveryFee"] == null
            ? null
            : Price.fromJson(json["deliveryFee"]),
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        totalPrice: json["totalPrice"] == null
            ? null
            : Price.fromJson(json["totalPrice"]),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        payments: json["payments"] == null
            ? []
            : List<Payment>.from(
                json["payments"].map((x) => Payment.fromJson(x))),
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        reservedTill: json["reservedTill"] == null
            ? null
            : DateTime.parse(json["reservedTill"]),
        hasPayment: json["hasPayment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
        "createdById": createdById,
        "deletedById": deletedById,
        "organizationId": organizationId,
        "number": number,
        "status": status,
        "recipientName": recipientName,
        "recipientNumber": recipientNumber,
        "customerId": customerId,
        "addressId": addressId,
        "deliveryFee": deliveryFee?.toJson(),
        "price": price?.toJson(),
        "totalPrice": totalPrice?.toJson(),
        "address": address?.toJson(),
        "payments": payments == null
            ? []
            : List<dynamic>.from(payments!.map((x) => x.toJson())),
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "reservedTill": reservedTill?.toIso8601String(),
        "hasPayment": hasPayment,
      };
}

// Класс для поля "price", "deliveryFee", "totalPrice" и т.д.
class Price {
  Price({
    this.amount,
    this.precision,
    this.currency,
  });

  final int? amount;
  final int? precision;
  final String? currency;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        amount: json["amount"],
        precision: json["precision"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "precision": precision,
        "currency": currency,
      };
}

// Адрес
class Address {
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

  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? createdById;
  final dynamic deletedById;
  final String? organizationId;
  final String? type;
  final double? latitude;
  final double? longitude;
  final String? address;
  final dynamic zipCode;
  final String? entrance;
  final int? apartment;
  final dynamic floor;
  final String? intercom;
  final String? additionalInfo;
  final String? cityId;
  final String? customerId;
  final dynamic partnerId;
  final dynamic relatedOrganizationId;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        createdById: json["createdById"],
        deletedById: json["deletedById"],
        organizationId: json["organizationId"],
        type: json["type"],
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
        address: json["address"],
        zipCode: json["zipCode"],
        entrance: json["entrance"],
        apartment: json["apartment"],
        floor: json["floor"],
        intercom: json["intercom"],
        additionalInfo: json["additionalInfo"],
        cityId: json["cityId"],
        customerId: json["customerId"],
        partnerId: json["partnerId"],
        relatedOrganizationId: json["relatedOrganizationId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
        "createdById": createdById,
        "deletedById": deletedById,
        "organizationId": organizationId,
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "zipCode": zipCode,
        "entrance": entrance,
        "apartment": apartment,
        "floor": floor,
        "intercom": intercom,
        "additionalInfo": additionalInfo,
        "cityId": cityId,
        "customerId": customerId,
        "partnerId": partnerId,
        "relatedOrganizationId": relatedOrganizationId,
      };
}

// Платёж (пустой массив в примере, но модель на будущее)
class Payment {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String status;
  final String system;
  final String? method;
  final String customerId;
  final String orderId;
  final String? transactionId;
  final Price price;

  Payment({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.status,
    required this.system,
    this.method,
    required this.customerId,
    required this.orderId,
    this.transactionId,
    required this.price,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      status: json['status'],
      system: json['system'],
      method: json['method'],
      customerId: json['customerId'],
      orderId: json['orderId'],
      transactionId: json['transactionId'],
      price: Price.fromJson(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'status': status,
      'system': system,
      'method': method,
      'customerId': customerId,
      'orderId': orderId,
      'transactionId': transactionId,
      'price': price.toJson(),
    };
  }
}

class Item {
  Item({
    this.id,
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
    this.productVariant,
  });

  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? createdById;
  final dynamic deletedById;
  final String? organizationId;
  final String? status;
  final String? orderId;
  final String? productId;
  final String? productVariantId;
  final Price? price;
  final Price? totalPrice;
  final Product? product;
  final ProductVariant? productVariant;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        createdById: json["createdById"],
        deletedById: json["deletedById"],
        organizationId: json["organizationId"],
        status: json["status"],
        orderId: json["orderId"],
        productId: json["productId"],
        productVariantId: json["productVariantId"],
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        totalPrice: json["totalPrice"] == null
            ? null
            : Price.fromJson(json["totalPrice"]),
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        productVariant: json["productVariant"] == null
            ? null
            : ProductVariant.fromJson(json["productVariant"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
        "createdById": createdById,
        "deletedById": deletedById,
        "organizationId": organizationId,
        "status": status,
        "orderId": orderId,
        "productId": productId,
        "productVariantId": productVariantId,
        "price": price?.toJson(),
        "totalPrice": totalPrice?.toJson(),
        "product": product?.toJson(),
        "productVariant": productVariant?.toJson(),
      };

  // Добавляем метод copyWith
  Item copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    String? createdById,
    dynamic deletedById,
    String? organizationId,
    String? status,
    String? orderId,
    String? productId,
    String? productVariantId,
    Price? price,
    Price? totalPrice,
    Product? product,
    ProductVariant? productVariant,
  }) {
    return Item(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdById: createdById ?? this.createdById,
      deletedById: deletedById ?? this.deletedById,
      organizationId: organizationId ?? this.organizationId,
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productVariantId: productVariantId ?? this.productVariantId,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
      product: product ?? this.product,
      productVariant: productVariant ?? this.productVariant,
    );
  }
}

// Модель продукта
class Product {
  Product({
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

  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? createdById;
  final dynamic deletedById;
  final String? organizationId;
  final String? status;
  final String? name;
  final String? slug;
  final String? vendorCode;
  final String? deliveryType;
  final List<ProdImage>? images;
  final List<dynamic>? compatibleVehicleIds;
  final String? brandId;
  final String? categoryId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        createdById: json["createdById"],
        deletedById: json["deletedById"],
        organizationId: json["organizationId"],
        status: json["status"],
        name: json["name"],
        slug: json["slug"],
        vendorCode: json["vendorCode"],
        deliveryType: json["deliveryType"],
        images: json["images"] == null
            ? []
            : List<ProdImage>.from(
                json["images"].map((x) => ProdImage.fromJson(x))),
        compatibleVehicleIds: json["compatibleVehicleIds"] == null
            ? []
            : List<dynamic>.from(json["compatibleVehicleIds"].map((x) => x)),
        brandId: json["brandId"],
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
        "createdById": createdById,
        "deletedById": deletedById,
        "organizationId": organizationId,
        "status": status,
        "name": name,
        "slug": slug,
        "vendorCode": vendorCode,
        "deliveryType": deliveryType,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "compatibleVehicleIds": compatibleVehicleIds == null
            ? []
            : List<dynamic>.from(compatibleVehicleIds!.map((x) => x)),
        "brandId": brandId,
        "categoryId": categoryId,
      };
}

// Класс для описания изображений в Product
class ProdImage {
  ProdImage({
    this.url,
    this.hash,
    this.size,
    this.sizes,
    this.width,
    this.format,
    this.height,
    this.blurhash,
  });

  final String? url;
  final String? hash;
  final int? size;
  final List<SizeData>? sizes;
  final int? width;
  final String? format;
  final int? height;
  final String? blurhash;

  factory ProdImage.fromJson(Map<String, dynamic> json) => ProdImage(
        url: json["url"],
        hash: json["hash"],
        size: json["size"],
        sizes: json["sizes"] == null
            ? []
            : List<SizeData>.from(
                json["sizes"].map((x) => SizeData.fromJson(x))),
        width: json["width"],
        format: json["format"],
        height: json["height"],
        blurhash: json["blurhash"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "hash": hash,
        "size": size,
        "sizes": sizes == null
            ? []
            : List<dynamic>.from(sizes!.map((x) => x.toJson())),
        "width": width,
        "format": format,
        "height": height,
        "blurhash": blurhash,
      };
}

// Класс для описания размеров изображений (sizes)
class SizeData {
  SizeData({
    this.width,
    this.height,
    this.url,
  });

  final int? width;
  final int? height;
  final String? url;

  factory SizeData.fromJson(Map<String, dynamic> json) => SizeData(
        width: json["width"],
        height: json["height"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "url": url,
      };
}

// Модель варианта продукта (ProductVariant)
class ProductVariant {
  ProductVariant({
    this.id,
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
    this.price,
  });

  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? createdById;
  final dynamic deletedById;
  final String? organizationId;
  final dynamic discoutPercentage;
  final String? kind;
  final int? quantity;
  final String? sku;
  final String? productId;
  final String? manufacturerId;
  final Price? basePrice;
  final Price? price;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        createdById: json["createdById"],
        deletedById: json["deletedById"],
        organizationId: json["organizationId"],
        discoutPercentage: json["discoutPercentage"],
        kind: json["kind"],
        quantity: json["quantity"],
        sku: json["sku"],
        productId: json["productId"],
        manufacturerId: json["manufacturerId"],
        basePrice: json["basePrice"] == null
            ? null
            : Price.fromJson(json["basePrice"]),
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
        "createdById": createdById,
        "deletedById": deletedById,
        "organizationId": organizationId,
        "discoutPercentage": discoutPercentage,
        "kind": kind,
        "quantity": quantity,
        "sku": sku,
        "productId": productId,
        "manufacturerId": manufacturerId,
        "basePrice": basePrice?.toJson(),
        "price": price?.toJson(),
      };
}
