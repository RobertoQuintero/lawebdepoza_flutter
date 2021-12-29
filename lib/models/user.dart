// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

class User {
  User({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.google,
    required this.createdAt,
    required this.uid,
  });

  String name;
  String email;
  String role;
  bool status;
  bool google;
  DateTime createdAt;
  String uid;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        role: json["role"],
        status: json["status"],
        google: json["google"],
        createdAt: DateTime.parse(json["created_at"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "role": role,
        "status": status,
        "google": google,
        "created_at": createdAt.toIso8601String(),
        "uid": uid,
      };
}
