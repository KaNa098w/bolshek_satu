class AlternativeCrossResponse {
  List<AlternativesItems>? items;
  int? total;

  AlternativeCrossResponse({this.items, this.total});

  AlternativeCrossResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <AlternativesItems>[];
      json['items'].forEach((v) {
        items!.add(new AlternativesItems.fromJson(v));
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

class AlternativesItems {
  String? id;
  String? createdAt;
  String? updatedAt;
  // Null? deletedAt;
  String? createdById;
  // Null? deletedById;
  String? organizationId;
  String? crossNumber;
  String? vehicleGenerationId;

  AlternativesItems(
      {this.id,
      this.createdAt,
      this.updatedAt,
      // this.deletedAt,
      this.createdById,
      // this.deletedById,
      this.organizationId,
      this.crossNumber,
      this.vehicleGenerationId});

  AlternativesItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    // deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    crossNumber = json['crossNumber'];
    vehicleGenerationId = json['vehicleGenerationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    // data['deletedAt'] = this.deletedAt;
    data['createdById'] = this.createdById;
    // data['deletedById'] = this.deletedById;
    data['organizationId'] = this.organizationId;
    data['crossNumber'] = this.crossNumber;
    data['vehicleGenerationId'] = this.vehicleGenerationId;
    return data;
  }
}
