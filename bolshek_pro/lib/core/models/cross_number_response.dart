class CrossNumberResponse {
  List<Items>? items;
  int? total;

  CrossNumberResponse({this.items, this.total});

  CrossNumberResponse.fromJson(Map<String, dynamic> json) {
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
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  String? crossNumber;
  String? vehicleGenerationId;
  VehicleGeneration? vehicleGeneration;

  Items(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.crossNumber,
      this.vehicleGenerationId,
      this.vehicleGeneration});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    crossNumber = json['crossNumber'];
    vehicleGenerationId = json['vehicleGenerationId'];
    vehicleGeneration = json['vehicleGeneration'] != null
        ? new VehicleGeneration.fromJson(json['vehicleGeneration'])
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
    data['crossNumber'] = this.crossNumber;
    data['vehicleGenerationId'] = this.vehicleGenerationId;
    if (this.vehicleGeneration != null) {
      data['vehicleGeneration'] = this.vehicleGeneration!.toJson();
    }
    return data;
  }
}

class VehicleGeneration {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  String? name;
  // Icon? icon;
  String? modelId;
  int? startYear;
  int? endYear;
  Model? model;

  VehicleGeneration(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.name,
      // this.icon,
      this.modelId,
      this.startYear,
      this.endYear,
      this.model});

  VehicleGeneration.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    name = json['name'];
    // icon = json['icon'] != null ? new Icon.fromJson(json['icon']) : null;
    modelId = json['modelId'];
    startYear = json['startYear'];
    endYear = json['endYear'];
    model = json['model'] != null ? new Model.fromJson(json['model']) : null;
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
    // if (this.icon != null) {
    //   data['icon'] = this.icon!.toJson();
    // }
    data['modelId'] = this.modelId;
    data['startYear'] = this.startYear;
    data['endYear'] = this.endYear;
    if (this.model != null) {
      data['model'] = this.model!.toJson();
    }
    return data;
  }
}

// class Icon {
//   String? url;
//   String? hash;
//   int? size;
//   List<Null>? sizes;
//   int? width;
//   String? format;
//   int? height;
//   String? blurhash;

//   Icon(
//       {this.url,
//       this.hash,
//       this.size,
//       this.sizes,
//       this.width,
//       this.format,
//       this.height,
//       this.blurhash});

//   Icon.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     hash = json['hash'];
//     size = json['size'];
//     if (json['sizes'] != null) {
//       sizes = <Null>[];
//       json['sizes'].forEach((v) {
//         sizes!.add(new Null.fromJson(v));
//       });
//     }
//     width = json['width'];
//     format = json['format'];
//     height = json['height'];
//     blurhash = json['blurhash'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['url'] = this.url;
//     data['hash'] = this.hash;
//     data['size'] = this.size;
//     if (this.sizes != null) {
//       data['sizes'] = this.sizes!.map((v) => v.toJson()).toList();
//     }
//     data['width'] = this.width;
//     data['format'] = this.format;
//     data['height'] = this.height;
//     data['blurhash'] = this.blurhash;
//     return data;
//   }
// }

class Model {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  String? type;
  String? name;
  List<String>? aliases;
  String? slug;
  String? brandId;
  Null? pcId;
  Brand? brand;

  Model(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.type,
      this.name,
      this.aliases,
      this.slug,
      this.brandId,
      this.pcId,
      this.brand});

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    type = json['type'];
    name = json['name'];
    aliases = json['aliases'].cast<String>();
    slug = json['slug'];
    brandId = json['brandId'];
    pcId = json['pcId'];
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
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
    data['type'] = this.type;
    data['name'] = this.name;
    data['aliases'] = this.aliases;
    data['slug'] = this.slug;
    data['brandId'] = this.brandId;
    data['pcId'] = this.pcId;
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    return data;
  }
}

class Brand {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  String? name;
  List<String>? aliases;
  String? slug;
  // Icon? icon;

  Brand({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.name,
    this.aliases,
    this.slug,
    // this.icon
  });

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    name = json['name'];
    aliases = json['aliases'].cast<String>();
    slug = json['slug'];
    // icon = json['icon'] != null ? new Icon.fromJson(json['icon']) : null;
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
    data['aliases'] = this.aliases;
    data['slug'] = this.slug;
    // if (this.icon != null) {
    //   data['icon'] = this.icon!.toJson();
    // }
    return data;
  }
}
