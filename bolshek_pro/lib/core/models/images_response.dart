class ImagesResponse {
  String? id;
  String? value;
  String? propertyId;
  String? productId;
  String? createdById;
  String? organizationId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  ImagesResponse(
      {this.id,
      this.value,
      this.propertyId,
      this.productId,
      this.createdById,
      this.organizationId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ImagesResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    propertyId = json['propertyId'];
    productId = json['productId'];
    createdById = json['createdById'];
    organizationId = json['organizationId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['propertyId'] = this.propertyId;
    data['productId'] = this.productId;
    data['createdById'] = this.createdById;
    data['organizationId'] = this.organizationId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
