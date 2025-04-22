// warehouse_response.dart
import 'dart:convert';

class WarehouseResponse {
  final List<WarehouseItem> items;
  final int total;

  WarehouseResponse({
    required this.items,
    required this.total,
  });

  factory WarehouseResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => WarehouseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }
}

class WarehouseItem {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? createdById;
  final String? deletedById;
  final String organizationId;
  final String name;
  final String addressId;
  final String relatedOrganizationId;
  final bool isMain;
  final String managerId;
  final Address address;
  final Manager manager;

  WarehouseItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    required this.organizationId,
    required this.name,
    required this.addressId,
    required this.relatedOrganizationId,
    required this.isMain,
    required this.managerId,
    required this.address,
    required this.manager,
  });

  WarehouseItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? createdById,
    String? deletedById,
    String? organizationId,
    String? name,
    String? addressId,
    String? relatedOrganizationId,
    bool? isMain,
    String? managerId,
    Address? address,
    Manager? manager,
  }) {
    return WarehouseItem(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdById: createdById ?? this.createdById,
      deletedById: deletedById ?? this.deletedById,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      addressId: addressId ?? this.addressId,
      relatedOrganizationId:
          relatedOrganizationId ?? this.relatedOrganizationId,
      isMain: isMain ?? this.isMain,
      managerId: managerId ?? this.managerId,
      address: address ?? this.address,
      manager: manager ?? this.manager,
    );
  }

  factory WarehouseItem.fromJson(Map<String, dynamic> json) {
    return WarehouseItem(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      createdById: json['createdById'] as String?,
      deletedById: json['deletedById'] as String?,
      organizationId: json['organizationId'] as String,
      name: json['name'] as String,
      addressId: json['addressId'] as String,
      relatedOrganizationId: json['relatedOrganizationId'] as String,
      isMain: json['isMain'] as bool,
      managerId: json['managerId'] as String,
      address: Address.fromJson(json['address']),
      manager: Manager.fromJson(json['manager']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'createdById': createdById,
      'deletedById': deletedById,
      'organizationId': organizationId,
      'name': name,
      'addressId': addressId,
      'relatedOrganizationId': relatedOrganizationId,
      'isMain': isMain,
      'managerId': managerId,
      'address': address.toJson(),
      'manager': manager.toJson(),
    };
  }
}

class Address {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? createdById;
  final String? deletedById;
  final String organizationId;
  final String type;
  final double latitude;
  final double longitude;
  final String address;
  final String? zipCode;
  final String? entrance;
  final int? apartment;
  final int? floor;
  final String? intercom;
  final String? additionalInfo;
  final String cityId;
  final String? customerId;
  final String? partnerId;
  final String? relatedOrganizationId;

  Address({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    required this.organizationId,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.zipCode,
    this.entrance,
    this.apartment,
    this.floor,
    this.intercom,
    this.additionalInfo,
    required this.cityId,
    this.customerId,
    this.partnerId,
    this.relatedOrganizationId,
  });

  Address copyWith({
    String? address,
  }) {
    return Address(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      createdById: createdById,
      deletedById: deletedById,
      organizationId: organizationId,
      type: type,
      latitude: latitude,
      longitude: longitude,
      address: address ?? this.address,
      zipCode: zipCode,
      entrance: entrance,
      apartment: apartment,
      floor: floor,
      intercom: intercom,
      additionalInfo: additionalInfo,
      cityId: cityId,
      customerId: customerId,
      partnerId: partnerId,
      relatedOrganizationId: relatedOrganizationId,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      createdById: json['createdById'],
      deletedById: json['deletedById'],
      organizationId: json['organizationId'],
      type: json['type'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'],
      zipCode: json['zipCode'],
      entrance: json['entrance'],
      apartment: json['apartment'],
      floor: json['floor'],
      intercom: json['intercom'],
      additionalInfo: json['additionalInfo'],
      cityId: json['cityId'],
      customerId: json['customerId'],
      partnerId: json['partnerId'],
      relatedOrganizationId: json['relatedOrganizationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'createdById': createdById,
      'deletedById': deletedById,
      'organizationId': organizationId,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'zipCode': zipCode,
      'entrance': entrance,
      'apartment': apartment,
      'floor': floor,
      'intercom': intercom,
      'additionalInfo': additionalInfo,
      'cityId': cityId,
      'customerId': customerId,
      'partnerId': partnerId,
      'relatedOrganizationId': relatedOrganizationId,
    };
  }
}

class Manager {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? createdById;
  final String? deletedById;
  final String organizationId;
  final String firstName;
  final String lastName;
  final String? email;
  final String phoneNumber;
  final String fcmTopic;
  final bool isActive;
  final String? avatar;

  Manager({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    required this.organizationId,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phoneNumber,
    required this.fcmTopic,
    required this.isActive,
    this.avatar,
  });

  Manager copyWith({
    String? firstName,
    String? lastName,
  }) {
    return Manager(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      createdById: createdById,
      deletedById: deletedById,
      organizationId: organizationId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email,
      phoneNumber: phoneNumber,
      fcmTopic: fcmTopic,
      isActive: isActive,
      avatar: avatar,
    );
  }

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      createdById: json['createdById'],
      deletedById: json['deletedById'],
      organizationId: json['organizationId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      fcmTopic: json['fcmTopic'],
      isActive: json['isActive'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'createdById': createdById,
      'deletedById': deletedById,
      'organizationId': organizationId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'fcmTopic': fcmTopic,
      'isActive': isActive,
      'avatar': avatar,
    };
  }
}
