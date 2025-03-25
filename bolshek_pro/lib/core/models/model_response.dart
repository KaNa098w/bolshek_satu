class ModelResponse {
  List<Items>? items;
  int? total;

  ModelResponse({this.items, this.total});

  ModelResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
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

class Items {
  String? id;
  String? createdAt;
  String? type;
  String? name;
  List<String>? aliases;
  String? slug;
  String? brandId;
  Brand? brand;

  Items(
      {this.id,
      this.createdAt,
      this.type,
      this.name,
      this.aliases,
      this.slug,
      this.brandId,
      this.brand});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    type = json['type'];
    name = json['name'];
    aliases = json['aliases'].cast<String>();
    slug = json['slug'];
    brandId = json['brandId'];
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['type'] = this.type;
    data['name'] = this.name;
    data['aliases'] = this.aliases;
    data['slug'] = this.slug;
    data['brandId'] = this.brandId;
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    return data;
  }
}

class Brand {
  String? id;
  String? createdAt;
  String? name;
  List<String>? aliases;
  String? slug;
  String? icon; // остаём String? для URL

  Brand({
    this.id,
    this.createdAt,
    this.name,
    this.aliases,
    this.slug,
    this.icon,
  });

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    aliases = json['aliases']?.cast<String>();
    slug = json['slug'];
    // Если json['icon'] является объектом, извлекаем URL
    icon = json['icon'] is Map<String, dynamic>
        ? json['icon']['url'] as String?
        : json['icon'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['name'] = name;
    data['aliases'] = aliases;
    data['slug'] = slug;
    data['icon'] = icon;
    return data;
  }
}
