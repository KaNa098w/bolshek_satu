class VehicleResponse {
  List<Items>? items;
  int? total;

  VehicleResponse({this.items, this.total});

  VehicleResponse.fromJson(Map<String, dynamic> json) {
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
  String? name;
  List<String>? aliases;
  String? slug;
  VehicleIcons? icon;

  Items(
      {this.id, this.createdAt, this.name, this.aliases, this.slug, this.icon});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    aliases = json['aliases'].cast<String>();
    slug = json['slug'];
    icon =
        json['icon'] != null ? new VehicleIcons.fromJson(json['icon']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['name'] = this.name;
    data['aliases'] = this.aliases;
    data['slug'] = this.slug;
    if (this.icon != null) {
      data['icon'] = this.icon!.toJson();
    }
    return data;
  }
}

class VehicleIcons {
  String? url;
  List<Sizes>? sizes;
  int? width;
  String? format;
  int? height;
  String? blurhash;

  VehicleIcons(
      {this.url,
      this.sizes,
      this.width,
      this.format,
      this.height,
      this.blurhash});

  VehicleIcons.fromJson(Map<String, dynamic> json) {
    url = json['url'];
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
