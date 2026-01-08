import 'dart:convert';

class User {
  String? uuid;
  String? name;
  String? username;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? role;

  User({
    this.uuid,
    this.name,
    this.username,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
    uuid: json["uuid"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "username": username,
    "email": email,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "role": role,
  };
}
