import 'package:bolshek_pro/core/models/product_responses.dart';

class WarehouseProduct {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  int? quantity;
  String? warehouseId;
  String? productId;
  Warehouse? warehouse;
  ProductItems? productItems;

  WarehouseProduct(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.quantity,
      this.warehouseId,
      this.productId,
      this.warehouse,
      this.productItems});

  WarehouseProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    quantity = json['quantity'];
    warehouseId = json['warehouseId'];
    productId = json['productId'];
    warehouse = json['warehouse'] != null
        ? new Warehouse.fromJson(json['warehouse'])
        : null;
       productItems = json['product'] != null
        ? new ProductItems.fromJson(json['warehouse'])
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
    data['quantity'] = this.quantity;
    data['warehouseId'] = this.warehouseId;
    data['productId'] = this.productId;
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
        if (this.productItems != null) {
      data['product'] = this.productItems!.toJson();
    }
    return data;
  }
}

class Warehouse {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  String? name;
  String? addressId;
  String? relatedOrganizationId;
  bool? isMain;
  String? managerId;

  Warehouse(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.name,
      this.addressId,
      this.relatedOrganizationId,
      this.isMain,
      this.managerId});

  Warehouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    name = json['name'];
    addressId = json['addressId'];
    relatedOrganizationId = json['relatedOrganizationId'];
    isMain = json['isMain'];
    managerId = json['managerId'];
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
    data['name'] = this.name;
    data['addressId'] = this.addressId;
    data['relatedOrganizationId'] = this.relatedOrganizationId;
    data['isMain'] = this.isMain;
    data['managerId'] = this.managerId;
    return data;
  }
}