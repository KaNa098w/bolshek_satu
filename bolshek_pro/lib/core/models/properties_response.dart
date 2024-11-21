class PropertiesResponse {
  List<PropertyItems>? items;
  int? total;

  PropertiesResponse({this.items, this.total});

  PropertiesResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <PropertyItems>[];
      json['items'].forEach((v) {
        items!.add(new PropertyItems.fromJson(v));
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

class PropertyItems {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  String? name;
  String? type;
  String? unit;
  String? categoryId;

  PropertyItems(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.name,
      this.type,
      this.unit,
      this.categoryId});

  PropertyItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    name = json['name'];
    type = json['type'];
    unit = json['unit'];
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
    data['name'] = this.name;
    data['type'] = this.type;
    data['unit'] = this.unit;
    data['categoryId'] = this.categoryId;
    return data;
  }
}
