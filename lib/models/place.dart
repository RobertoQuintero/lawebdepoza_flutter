// To parse this JSON data, do
//
//     final place = placeFromMap(jsonString);

import 'dart:convert';

import 'package:lawebdepoza_mobile/models/models.dart';

class Place {
  Place({
    required this.name,
    required this.description,
    required this.address,
    required this.coordinates,
    this.img,
    this.facebook,
    this.web,
    required this.createdAt,
    required this.updatedAt,
    this.rating,
    this.totalRating,
    this.quantityVoting,
    required this.category,
    required this.user,
    this.id,
  });

  String name;
  String description;
  String address;
  Coordinates coordinates;
  String? img;
  String? facebook;
  String? web;
  DateTime createdAt;
  DateTime updatedAt;
  int? rating;
  int? totalRating;
  int? quantityVoting;
  Category category;
  String user;
  String? id;

  factory Place.fromJson(String str) => Place.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Place.fromMap(Map<String, dynamic> json) => Place(
        name: json["name"],
        description: json["description"],
        address: json["address"],
        coordinates: Coordinates.fromMap(json["coordinates"]),
        img: json['img'],
        facebook: json["facebook"],
        web: json["web"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        rating: json["rating"],
        totalRating: json["totalRating"],
        quantityVoting: json["quantityVoting"],
        category: Category.fromMap(json["category"]),
        user: json["user"],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
        "address": address,
        "coordinates": coordinates.toMap(),
        'img': img,
        "facebook": facebook,
        "web": web,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "rating": rating,
        "totalRating": totalRating,
        "quantityVoting": quantityVoting,
        "category": category.toMap(),
        "user": user,
        "_id": id,
      };

  Place copy() => Place(
        name: this.name,
        description: this.description,
        address: this.address,
        coordinates: this.coordinates,
        img: this.img,
        facebook: this.facebook,
        web: this.web,
        createdAt: this.createdAt,
        updatedAt: this.updatedAt,
        rating: this.rating,
        totalRating: this.totalRating,
        quantityVoting: this.quantityVoting,
        category: this.category,
        user: this.user,
        id: this.id,
      );
}

class Coordinates {
  Coordinates({
    this.lat = 0,
    this.lng = 0,
  });

  double lat;
  double lng;

  factory Coordinates.fromJson(String str) =>
      Coordinates.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Coordinates.fromMap(Map<String, dynamic> json) => Coordinates(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
      };
}
