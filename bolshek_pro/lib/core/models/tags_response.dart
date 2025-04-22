class TagsResponse {
  List<ItemsTags>? items;
  int? total;

  TagsResponse({this.items, this.total});

  TagsResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ItemsTags>[];
      json['items'].forEach((v) {
        items!.add(new ItemsTags.fromJson(v));
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

class ItemsTags {
  String? id;
  String? createdAt;
  String? text;
  String? backgroundColor;
  String? textColor;
  int? priority;
  bool? isActive;
  bool? onCard;

  ItemsTags(
      {this.id,
      this.createdAt,
      this.text,
      this.backgroundColor,
      this.textColor,
      this.priority,
      this.isActive,
      this.onCard});

  ItemsTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    text = json['text'];
    backgroundColor = json['backgroundColor'];
    textColor = json['textColor'];
    priority = json['priority'];
    isActive = json['isActive'];
    onCard = json['onCard'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['text'] = this.text;
    data['backgroundColor'] = this.backgroundColor;
    data['textColor'] = this.textColor;
    data['priority'] = this.priority;
    data['isActive'] = this.isActive;
    data['onCard'] = this.onCard;
    return data;
  }
}
