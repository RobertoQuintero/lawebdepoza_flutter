// To parse this JSON data, do
//
//     final category = categoryFromMap(jsonString);

import 'dart:convert';

class Category {
  Category({
    required this.id,
    required this.name,
    this.user,
  });

  String id;
  String name;
  String? user;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        user: json["user"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "user": user,
      };
}
