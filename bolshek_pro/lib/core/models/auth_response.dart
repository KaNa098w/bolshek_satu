class AuthResponse {
  String? token;
  User? user;
  List<String>? permissions;

  AuthResponse({this.token, this.user, this.permissions});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    permissions = json['permissions'] != null
        ? List<String>.from(json['permissions'])
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['permissions'] = permissions;
    return data;
  }
}

class User {
  String? id;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  dynamic avatar; // Убрали Null и заменили на dynamic
  List<Roles>? roles;

  User({
    this.id,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.avatar,
    this.roles,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    avatar = json['avatar']; // Динамическое поле
    roles = json['roles'] != null
        ? List<Roles>.from(json['roles'].map((v) => Roles.fromJson(v)))
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['avatar'] = avatar;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  String? id;
  String? createdAt;
  String? userId;
  String? roleId;
  Role? role;

  Roles({this.id, this.createdAt, this.userId, this.roleId, this.role});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    userId = json['userId'];
    roleId = json['roleId'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['userId'] = userId;
    data['roleId'] = roleId;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    return data;
  }
}

class Role {
  String? id;
  String? createdAt;
  String? name;
  int? position;
  List<String>? granted;
  List<String>? revoked;

  Role({
    this.id,
    this.createdAt,
    this.name,
    this.position,
    this.granted,
    this.revoked,
  });

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    position = json['position'];
    granted = json['granted'] != null ? List<String>.from(json['granted']) : [];
    revoked = json['revoked'] != null ? List<String>.from(json['revoked']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['name'] = name;
    data['position'] = position;
    data['granted'] = granted;
    data['revoked'] = revoked;
    return data;
  }
}
