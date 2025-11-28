import 'dart:convert';

import 'user.dart';

AuthResponse authResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

class AuthResponse {
  User? user;
  String? message;
  String? token;

  AuthResponse({this.user, this.message, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    user: json["data"]['user'] == null
        ? null
        : User.fromJson(json["data"]['user']),
    message: json["message"],
    token: json["token"],
  );
}
