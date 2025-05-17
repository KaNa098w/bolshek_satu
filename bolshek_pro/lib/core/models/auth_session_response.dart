class AuthSessionResponse {
  String? token;
  User? user;
  String? type;
  List<String>? permissions;

  AuthSessionResponse({
    this.token,
    this.user,
    this.type,
    this.permissions,
  });

  factory AuthSessionResponse.fromJson(Map<String, dynamic> json) {
    return AuthSessionResponse(
      token: json['token'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      type: json['type'] as String?,
      permissions:
          (json['permissions'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        if (user != null) 'user': user!.toJson(),
        'type': type,
        'permissions': permissions,
      };
}

/* ─────────────────────────  User  ───────────────────────── */

class User {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdById;
  String? deletedById;
  String? organizationId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? fcmTopic;
  bool? isActive;
  String? avatar;
  List<RoleLink>? roles;
  Organization? organization;
  List<Warehouse>? warehouses;

  User({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.fcmTopic,
    this.isActive,
    this.avatar,
    this.roles,
    this.organization,
    this.warehouses,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        deletedAt: json['deletedAt'] as String?,
        createdById: json['createdById'] as String?,
        deletedById: json['deletedById'] as String?,
        organizationId: json['organizationId'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        fcmTopic: json['fcmTopic'] as String?,
        isActive: json['isActive'] as bool?,
        avatar: json['avatar'] as String?,
        roles: (json['roles'] as List<dynamic>?)
            ?.map((e) => RoleLink.fromJson(e))
            .toList(),
        organization: json['organization'] != null
            ? Organization.fromJson(json['organization'])
            : null,
        warehouses: (json['warehouses'] as List<dynamic>?)
            ?.map((e) => Warehouse.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
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
        if (roles != null) 'roles': roles!.map((e) => e.toJson()).toList(),
        if (organization != null) 'organization': organization!.toJson(),
        if (warehouses != null) 'warehouses': warehouses!.map((e) => e.toJson()).toList(),
      };
}

/* ─────────────────────────  RoleLink  ───────────────────────── */

class RoleLink {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdById;
  String? deletedById;
  String? organizationId;
  String? userId;
  String? roleId;
  Role? role;

  RoleLink({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.userId,
    this.roleId,
    this.role,
  });

  factory RoleLink.fromJson(Map<String, dynamic> json) => RoleLink(
        id: json['id'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        deletedAt: json['deletedAt'] as String?,
        createdById: json['createdById'] as String?,
        deletedById: json['deletedById'] as String?,
        organizationId: json['organizationId'] as String?,
        userId: json['userId'] as String?,
        roleId: json['roleId'] as String?,
        role: json['role'] != null ? Role.fromJson(json['role']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'createdById': createdById,
        'deletedById': deletedById,
        'organizationId': organizationId,
        'userId': userId,
        'roleId': roleId,
        if (role != null) 'role': role!.toJson(),
      };
}

/* ─────────────────────────  Role  ───────────────────────── */

class Role {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdById;
  String? deletedById;
  String? organizationId;
  String? name;
  int? position;
  List<String>? granted;
  List<String>? revoked; // ← заменили Null на String

  Role({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.name,
    this.position,
    this.granted,
    this.revoked,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        deletedAt: json['deletedAt'] as String?,
        createdById: json['createdById'] as String?,
        deletedById: json['deletedById'] as String?,
        organizationId: json['organizationId'] as String?,
        name: json['name'] as String?,
        position: json['position'] as int?,
        granted: (json['granted'] as List<dynamic>?)?.cast<String>(),
        revoked: (json['revoked'] as List<dynamic>?)?.cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'createdById': createdById,
        'deletedById': deletedById,
        'organizationId': organizationId,
        'name': name,
        'position': position,
        'granted': granted,
        'revoked': revoked,
      };
}

/* ─────────────────────────  Organization  ───────────────────────── */

class Organization {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdById;
  String? deletedById;
  String? organizationId;
  String? name;
  bool? isActive;
  bool? isMaster;

  Organization({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.name,
    this.isActive,
    this.isMaster,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json['id'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        deletedAt: json['deletedAt'] as String?,
        createdById: json['createdById'] as String?,
        deletedById: json['deletedById'] as String?,
        organizationId: json['organizationId'] as String?,
        name: json['name'] as String?,
        isActive: json['isActive'] as bool?,
        isMaster: json['isMaster'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'createdById': createdById,
        'deletedById': deletedById,
        'organizationId': organizationId,
        'name': name,
        'isActive': isActive,
        'isMaster': isMaster,
      };
}

/* ─────────────────────────  Warehouse  ───────────────────────── */

class Warehouse {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdById;
  String? deletedById;
  String? organizationId;
  String? name;
  String? addressId;
  String? relatedOrganizationId;
  bool? isMain;
  String? managerId;

  Warehouse({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.name,
    this.addressId,
    this.relatedOrganizationId,
    this.isMain,
    this.managerId,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        id: json['id'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        deletedAt: json['deletedAt'] as String?,
        createdById: json['createdById'] as String?,
        deletedById: json['deletedById'] as String?,
        organizationId: json['organizationId'] as String?,
        name: json['name'] as String?,
        addressId: json['addressId'] as String?,
        relatedOrganizationId: json['relatedOrganizationId'] as String?,
        isMain: json['isMain'] as bool?,
        managerId: json['managerId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'createdById': createdById,
        'deletedById': deletedById,
        'organizationId': organizationId,
        'name': name,
        'addressId': addressId,
        'relatedOrganizationId': relatedOrganizationId,
        'isMain': isMain,
        'managerId': managerId,
      };
}
