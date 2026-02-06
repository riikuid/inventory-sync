import 'dart:convert';

import 'user.dart';

class AuthResponse {
  User? user;
  String? message;
  String? token;

  AuthResponse({this.user, this.token, this.message});

  factory AuthResponse.fromRawJson(String str) =>
      AuthResponse.fromJson(json.decode(str));

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    user: json["data"]["user"] == null
        ? null
        : User.fromJson(json["data"]["user"]),
    token: json["data"]["token"],
    message: json["message"],
  );
}
