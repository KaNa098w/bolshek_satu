class BrandsResponse {
  List<Items>? items;
  int? total;

  BrandsResponse({this.items, this.total});

  BrandsResponse.fromJson(Map<String, dynamic> json) {
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
  Null? icon;

  Items(
      {this.id,
      this.createdAt,
      this.type,
      this.name,
      this.aliases,
      this.slug,
      this.icon});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    type = json['type'];
    name = json['name'];
    aliases = json['aliases'].cast<String>();
    slug = json['slug'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['type'] = this.type;
    data['name'] = this.name;
    data['aliases'] = this.aliases;
    data['slug'] = this.slug;
    data['icon'] = this.icon;
    return data;
  }
}
