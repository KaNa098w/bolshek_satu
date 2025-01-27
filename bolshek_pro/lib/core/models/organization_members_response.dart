class OrganizationMembersResponse {
  final List<MemberItem> items;
  final int total;

  OrganizationMembersResponse({
    required this.items,
    required this.total,
  });

  factory OrganizationMembersResponse.fromJson(Map<String, dynamic> json) {
    return OrganizationMembersResponse(
      items: (json['items'] as List<dynamic>)
          .map((item) => MemberItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}

class MemberItem {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String createdById;
  final String? deletedById;
  final String organizationId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String fcmTopic;
  final bool isActive;

  MemberItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.createdById,
    this.deletedById,
    required this.organizationId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.fcmTopic,
    required this.isActive,
  });

  factory MemberItem.fromJson(Map<String, dynamic> json) {
    return MemberItem(
      id: json['id'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
      createdById: json['createdById'] as String,
      deletedById: json['deletedById'] as String?,
      organizationId: json['organizationId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      fcmTopic: json['fcmTopic'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'createdById': createdById,
      'deletedById': deletedById,
      'organizationId': organizationId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'fcmTopic': fcmTopic,
      'isActive': isActive,
    };
  }
}

// class RoleItem {
//   final String id;
//   final String createdAt;
//   final String updatedAt;
//   final String? deletedAt;
//   final String createdById;
//   final String? deletedById;
//   final String organizationId;
//   final String userId;
//   final String roleId;
//   final Role role;

//   RoleItem({
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//     this.deletedAt,
//     required this.createdById,
//     this.deletedById,
//     required this.organizationId,
//     required this.userId,
//     required this.roleId,
//     required this.role,
//   });

//   factory RoleItem.fromJson(Map<String, dynamic> json) {
//     return RoleItem(
//       id: json['id'] as String,
//       createdAt: json['createdAt'] as String,
//       updatedAt: json['updatedAt'] as String,
//       deletedAt: json['deletedAt'] as String?,
//       createdById: json['createdById'] as String,
//       deletedById: json['deletedById'] as String?,
//       organizationId: json['organizationId'] as String,
//       userId: json['userId'] as String,
//       roleId: json['roleId'] as String,
//       role: Role.fromJson(json['role'] as Map<String, dynamic>),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'deletedAt': deletedAt,
//       'createdById': createdById,
//       'deletedById': deletedById,
//       'organizationId': organizationId,
//       'userId': userId,
//       'roleId': roleId,
//       'role': role.toJson(),
//     };
//   }
// }

// class Role {
//   final String id;
//   final String createdAt;
//   final String updatedAt;
//   final String? deletedAt;
//   final String createdById;
//   final String? deletedById;
//   final String organizationId;
//   final String name;
//   final int position;
//   final List<String> granted;
//   final List<String> revoked;

//   Role({
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//     this.deletedAt,
//     required this.createdById,
//     this.deletedById,
//     required this.organizationId,
//     required this.name,
//     required this.position,
//     required this.granted,
//     required this.revoked,
//   });

//   factory Role.fromJson(Map<String, dynamic> json) {
//     return Role(
//       id: json['id'] as String,
//       createdAt: json['createdAt'] as String,
//       updatedAt: json['updatedAt'] as String,
//       deletedAt: json['deletedAt'] as String?,
//       createdById: json['createdById'] as String,
//       deletedById: json['deletedById'] as String?,
//       organizationId: json['organizationId'] as String,
//       name: json['name'] as String,
//       position: json['position'] as int,
//       granted: List<String>.from(json['granted'] as List),
//       revoked: List<String>.from(json['revoked'] as List),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'deletedAt': deletedAt,
//       'createdById': createdById,
//       'deletedById': deletedById,
//       'organizationId': organizationId,
//       'name': name,
//       'position': position,
//       'granted': granted,
//       'revoked': revoked,
//     };
//   }
// }
