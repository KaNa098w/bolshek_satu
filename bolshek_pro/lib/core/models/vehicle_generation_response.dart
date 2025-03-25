class VehicleGenerationResponse {
  List<Items>? items;
  int? total;

  VehicleGenerationResponse({this.items, this.total});

  VehicleGenerationResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
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

class Items {
  String? id;
  String? createdAt;
  String? name;
  Map<String, dynamic>? icon; // изменили с Null? на Map<String, dynamic>?
  String? modelId;
  int? startYear;
  int? endYear;
  Model? model;

  Items({
    this.id,
    this.createdAt,
    this.name,
    this.icon,
    this.modelId,
    this.startYear,
    this.endYear,
    this.model,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    icon =
        json['icon'] as Map<String, dynamic>?; // теперь icon ожидается как Map
    modelId = json['modelId'];
    startYear = json['startYear'];
    endYear = json['endYear'];
    model = json['model'] != null ? Model.fromJson(json['model']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['name'] = name;
    data['icon'] = icon;
    data['modelId'] = modelId;
    data['startYear'] = startYear;
    data['endYear'] = endYear;
    if (model != null) {
      data['model'] = model!.toJson();
    }
    return data;
  }
}

class Model {
  String? id;
  String? createdAt;
  String? type;
  String? name;
  List<String>? aliases;
  String? slug;
  String? brandId;
  Brand? brand;

  Model({
    this.id,
    this.createdAt,
    this.type,
    this.name,
    this.aliases,
    this.slug,
    this.brandId,
    this.brand,
  });

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    type = json['type'];
    name = json['name'];
    aliases = json['aliases']?.cast<String>();
    slug = json['slug'];
    brandId = json['brandId'];
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['type'] = type;
    data['name'] = name;
    data['aliases'] = aliases;
    data['slug'] = slug;
    data['brandId'] = brandId;
    if (brand != null) {
      data['brand'] = brand!.toJson();
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
  Map<String, dynamic>? icon; // изменили с Null? на Map<String, dynamic>?

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
    icon = json['icon'] as Map<String, dynamic>?;
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
