import 'dart:convert';

class User {
  final int? id;
  final String? uuid;
  final int? purchasingAppId;
  final String? name;
  final String? username;
  final String? email;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final String? role;
  final List<Section>? sections;

  User({
    this.id,
    this.uuid,
    this.purchasingAppId,
    this.name,
    this.username,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.role,
    this.sections,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    uuid: json["uuid"],
    purchasingAppId: json["purchasing_app_id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    lastLoginAt: json["last_login_at"] == null
        ? null
        : DateTime.parse(json["last_login_at"]),
    role: json["role"],
    sections: json["section"] == null
        ? []
        : List<Section>.from(json["section"]!.map((x) => Section.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "purchasing_app_id": purchasingAppId,
    "name": name,
    "username": username,
    "email": email,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "last_login_at": lastLoginAt?.toIso8601String(),
    "role": role,
    "section": sections == null
        ? []
        : List<dynamic>.from(sections!.map((x) => x.toJson())),
  };
}

class Section {
  String? id;
  String? code;
  String? name;
  String? alias;
  int? idSectionPurchasing;

  Section({
    this.id,
    this.code,
    this.name,
    this.alias,
    this.idSectionPurchasing,
  });

  Section copyWith({
    String? id,
    String? code,
    String? name,
    String? alias,
    int? idSectionPurchasing,
  }) => Section(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    alias: alias ?? this.alias,
    idSectionPurchasing: idSectionPurchasing ?? this.idSectionPurchasing,
  );

  factory Section.fromRawJson(String str) => Section.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    alias: json["alias"],
    idSectionPurchasing: json["id_section_purchasing"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "alias": alias,
    "id_section_purchasing": idSectionPurchasing,
  };
}
