class CategoryByIdResponse {
  String? id;
  String? createdAt;
  String? name;
  String? slug;
  String? parentId;
  Parent? parent;

  CategoryByIdResponse(
      {this.id,
      this.createdAt,
      this.name,
      this.slug,
      this.parentId,
      this.parent});

  CategoryByIdResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    slug = json['slug'];
    parentId = json['parentId'];
    parent =
        json['parent'] != null ? new Parent.fromJson(json['parent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['name'] = this.name;
    data['slug'] = this.slug;

    data['parentId'] = this.parentId;
    if (this.parent != null) {
      data['parent'] = this.parent!.toJson();
    }
    return data;
  }
}

class Parent {
  String? id;
  String? createdAt;
  String? name;
  String? slug;
  String? parentId;

  Parent({this.id, this.createdAt, this.name, this.slug, this.parentId});

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    slug = json['slug'];
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['name'] = this.name;
    data['slug'] = this.slug;

    data['parentId'] = this.parentId;
    return data;
  }
}
