class FetchProductResponse {
  String? id;
  String? createdAt;
  String? status;
  String? name;
  String? slug;
  Description? description;
  String? vendorCode;
  String? deliveryType;
  List<Images>? images;
  List<String>? compatibleVehicleIds; // Изменено на List<String>
  String? brandId;
  String? categoryId;
  String? crossNumber;
  List<Variants>? variants;
  List<Properties>? properties;

  FetchProductResponse({
    this.id,
    this.createdAt,
    this.status,
    this.name,
    this.slug,
    this.description,
    this.vendorCode,
    this.deliveryType,
    this.images,
    this.compatibleVehicleIds,
    this.brandId,
    this.categoryId,
    this.crossNumber,
    this.variants,
    this.properties,
  });

  FetchProductResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    status = json['status'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    vendorCode = json['vendorCode'];
    deliveryType = json['deliveryType'];
    images = (json['images'] as List<dynamic>?)
        ?.map((v) => Images.fromJson(v))
        .toList();
    compatibleVehicleIds = (json['compatibleVehicleIds'] as List<dynamic>?)
        ?.map((v) => v.toString())
        .toList(); // Конвертация в List<String>
    brandId = json['brandId'];
    categoryId = json['categoryId'];
    crossNumber = json['crossNumber'];
    variants = (json['variants'] as List<dynamic>?)
        ?.map((v) => Variants.fromJson(v))
        .toList();
    properties = (json['properties'] as List<dynamic>?)
        ?.map((v) => Properties.fromJson(v))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['status'] = status;
    data['name'] = name;
    data['slug'] = slug;
    if (description != null) {
      data['description'] = description!.toJson();
    }
    data['vendorCode'] = vendorCode;
    data['deliveryType'] = deliveryType;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (compatibleVehicleIds != null) {
      data['compatibleVehicleIds'] = compatibleVehicleIds; // Список строк
    }
    data['brandId'] = brandId;
    data['categoryId'] = categoryId;
    data['crossNumber'] = crossNumber;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (properties != null) {
      data['properties'] = properties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Description {
  int? time;
  List<Blocks>? blocks;
  String? version;

  Description({this.time, this.blocks, this.version});

  Description.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    if (json['blocks'] != null) {
      blocks = <Blocks>[];
      json['blocks'].forEach((v) {
        blocks!.add(new Blocks.fromJson(v));
      });
    }
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    if (this.blocks != null) {
      data['blocks'] = this.blocks!.map((v) => v.toJson()).toList();
    }
    data['version'] = this.version;
    return data;
  }
}

class Blocks {
  String? id;
  Data? data;
  String? type;

  Blocks({this.id, this.data, this.type});

  Blocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Data {
  String? text;

  Data({this.text});

  Data.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class Images {
  String? url;
  List<Sizes>? sizes;
  int? width;
  String? format;
  int? height;
  String? blurhash;

  Images(
      {this.url,
      this.sizes,
      this.width,
      this.format,
      this.height,
      this.blurhash});

  Images.fromJson(Map<String, dynamic> json) {
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

class Variants {
  String? id;
  String? createdAt;
  String? kind;
  int? quantity;
  String? sku;
  String? productId;
  String? manufacturerId;
  Price? price;
  Manufacturer? manufacturer;

  Variants(
      {this.id,
      this.createdAt,
      this.kind,
      this.quantity,
      this.sku,
      this.productId,
      this.manufacturerId,
      this.price,
      this.manufacturer});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    kind = json['kind'];
    quantity = json['quantity'];
    sku = json['sku'];
    productId = json['productId'];
    manufacturerId = json['manufacturerId'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    manufacturer = json['manufacturer'] != null
        ? new Manufacturer.fromJson(json['manufacturer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['kind'] = this.kind;
    data['quantity'] = this.quantity;
    data['sku'] = this.sku;
    data['productId'] = this.productId;
    data['manufacturerId'] = this.manufacturerId;
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.manufacturer != null) {
      data['manufacturer'] = this.manufacturer!.toJson();
    }
    return data;
  }
}

class Price {
  int? amount;
  int? precision;
  String? currency;

  Price({this.amount, this.precision, this.currency});

  Price.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    precision = json['precision'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['precision'] = this.precision;
    data['currency'] = this.currency;
    return data;
  }
}

class Manufacturer {
  String? id;
  String? createdAt;
  String? name;

  Manufacturer({this.id, this.createdAt, this.name});

  Manufacturer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['name'] = this.name;
    return data;
  }
}

class Properties {
  String? id;
  String? createdAt;
  String? value;
  String? propertyId;
  String? productId;
  Property? property;

  Properties(
      {this.id,
      this.createdAt,
      this.value,
      this.propertyId,
      this.productId,
      this.property});

  Properties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    value = json['value'];
    propertyId = json['propertyId'];
    productId = json['productId'];
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['value'] = this.value;
    data['propertyId'] = this.propertyId;
    data['productId'] = this.productId;
    if (this.property != null) {
      data['property'] = this.property!.toJson();
    }
    return data;
  }
}

class Property {
  String? id;
  String? createdAt;
  String? name;
  String? type;
  String? unit; // Изменено с Null? на String?
  String? categoryId;

  Property({
    this.id,
    this.createdAt,
    this.name,
    this.type,
    this.unit,
    this.categoryId,
  });

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    type = json['type'];
    unit = json['unit']; // Парсинг строки
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['name'] = name;
    data['type'] = type;
    data['unit'] = unit;
    data['categoryId'] = categoryId;
    return data;
  }
}
