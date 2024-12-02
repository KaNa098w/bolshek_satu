class CategoryResponse {
  List<CategoryItems>? items;
  int? total;

  CategoryResponse({this.items, this.total});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <CategoryItems>[];
      json['items'].forEach((v) {
        items!.add(new CategoryItems.fromJson(v));
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

class CategoryItems {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  String? name;
  String? slug;
  CategoryIcon? icon;
  String? parentId;
  List<CategoryItems>? children;

  CategoryItems(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.name,
      this.slug,
      this.icon,
      this.parentId,
      this.children});

  CategoryItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    name = json['name'];
    slug = json['slug'];
    icon =
        json['icon'] != null ? new CategoryIcon.fromJson(json['icon']) : null;
    parentId = json['parentId'];
    children = [];
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
    data['slug'] = this.slug;
    if (this.icon != null) {
      data['icon'] = this.icon!.toJson();
    }
    data['parentId'] = this.parentId;
    return data;
  }
}

class CategoryIcon {
  String? url;
  String? hash;
  int? size;
  List<Sizes>? sizes;
  int? width;
  String? format;
  int? height;
  String? blurhash;

  CategoryIcon(
      {this.url,
      this.hash,
      this.size,
      this.sizes,
      this.width,
      this.format,
      this.height,
      this.blurhash});

  CategoryIcon.fromJson(Map<String, dynamic> json) {
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
