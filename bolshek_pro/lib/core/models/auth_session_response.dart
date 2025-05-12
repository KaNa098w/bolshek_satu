class AuthSessionResponse {
  String? token;
  User? user;
  String? type;
  List<String>? permissions;

  AuthSessionResponse({this.token, this.user, this.type, this.permissions});

  AuthSessionResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    type = json['type'];
    permissions = (json['permissions'] as List<dynamic>?)
        ?.map((item) => item as String)
        .toList();
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? fcmTopic;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? createdById;
  String? deletedAt;
  String? deletedById;
  String? organizationId;
  Organization? organization;
  List<UserRole>? roles;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.fcmTopic,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.createdById,
    this.deletedAt,
    this.deletedById,
    this.organizationId,
    this.organization,
    this.roles,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    fcmTopic = json['fcmTopic'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdById = json['createdById'];
    deletedAt = json['deletedAt'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    organization = json['organization'] != null
        ? Organization.fromJson(json['organization'])
        : null;
    roles = (json['roles'] as List<dynamic>?)
        ?.map((item) => UserRole.fromJson(item))
        .toList();
  }
}

class UserRole {
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

  UserRole({
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

  UserRole.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    userId = json['userId'];
    roleId = json['roleId'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }
}

class Role {
  String? id;
  String? name;
  int? position;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdById;
  String? deletedById;
  String? organizationId;
  List<String>? granted;
  List<String>? revoked;

  Role({
    this.id,
    this.name,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
    this.granted,
    this.revoked,
  });

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
    granted = (json['granted'] as List<dynamic>?)
        ?.map((item) => item as String)
        .toList();
    revoked = (json['revoked'] as List<dynamic>?)
        ?.map((item) => item as String)
        .toList();
  }
}

class Organization {
  String? id;
  String? name;
  bool? isActive;
  bool? isMaster;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdById;
  String? deletedById;
  String? organizationId;

  Organization({
    this.id,
    this.name,
    this.isActive,
    this.isMaster,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
    this.organizationId,
  });

  Organization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    isMaster = json['isMaster'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    createdById = json['createdById'];
    deletedById = json['deletedById'];
    organizationId = json['organizationId'];
  }
}
