class AddressResponse {
  List<Items>? items;
  int? total;

  AddressResponse({this.items, this.total});

  AddressResponse.fromJson(Map<String, dynamic> json) {
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
  String? type;
  double? latitude;
  double? longitude;
  String? address;
  Null? zipCode;
  Null? entrance;
  Null? apartment;
  Null? floor;
  Null? intercom;
  String? additionalInfo;
  String? cityId;
  Null? customerId;
  Null? partnerId;
  String? relatedOrganizationId;
  City? city;

  Items(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.type,
      this.latitude,
      this.longitude,
      this.address,
      this.zipCode,
      this.entrance,
      this.apartment,
      this.floor,
      this.intercom,
      this.additionalInfo,
      this.cityId,
      this.customerId,
      this.partnerId,
      this.relatedOrganizationId,
      this.city});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    zipCode = json['zipCode'];
    entrance = json['entrance'];
    apartment = json['apartment'];
    floor = json['floor'];
    intercom = json['intercom'];
    additionalInfo = json['additionalInfo'];
    cityId = json['cityId'];
    customerId = json['customerId'];
    partnerId = json['partnerId'];
    relatedOrganizationId = json['relatedOrganizationId'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
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
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['zipCode'] = this.zipCode;
    data['entrance'] = this.entrance;
    data['apartment'] = this.apartment;
    data['floor'] = this.floor;
    data['intercom'] = this.intercom;
    data['additionalInfo'] = this.additionalInfo;
    data['cityId'] = this.cityId;
    data['customerId'] = this.customerId;
    data['partnerId'] = this.partnerId;
    data['relatedOrganizationId'] = this.relatedOrganizationId;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    return data;
  }
}

class City {
  String? id;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? createdById;
  Null? deletedById;
  String? organizationId;
  bool? isActive;
  String? name;
  String? slug;

  City(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdById,
      this.deletedById,
      this.organizationId,
      this.isActive,
      this.name,
      this.slug});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    isActive = json['isActive'];
    name = json['name'];
    slug = json['slug'];
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
    data['isActive'] = this.isActive;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}
