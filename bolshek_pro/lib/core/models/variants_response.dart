class VariantsResponse {
  List<VariantsItems>? items;
  int? total;

  VariantsResponse({this.items, this.total});

  VariantsResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <VariantsItems>[];
      json['items'].forEach((v) {
        items!.add(new VariantsItems.fromJson(v));
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

class VariantsItems {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  String? kind;
  int? quantity;
  String? sku;
  String? productId;
  String? manufacturerId;
  BasePrice? basePrice;
  BasePrice? price;

  VariantsItems(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.kind,
      this.quantity,
      this.sku,
      this.productId,
      this.manufacturerId,
      this.basePrice,
      this.price});

  VariantsItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    kind = json['kind'];
    quantity = json['quantity'];
    sku = json['sku'];
    productId = json['productId'];
    manufacturerId = json['manufacturerId'];
    basePrice = json['basePrice'] != null
        ? new BasePrice.fromJson(json['basePrice'])
        : null;
    price =
        json['price'] != null ? new BasePrice.fromJson(json['price']) : null;
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

class BasePrice {
  int? amount;
  int? precision;
  String? currency;

  BasePrice({this.amount, this.precision, this.currency});

  BasePrice.fromJson(Map<String, dynamic> json) {
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
