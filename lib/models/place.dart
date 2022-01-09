// To parse this JSON data, do
//
//     final place = placeFromMap(jsonString);

import 'dart:convert';

import 'package:lawebdepoza_mobile/models/models.dart';

class Place {
  Place({
    required this.name,
    required this.description,
    this.img,
    required this.address,
    required this.coordinates,
    this.facebook = '',
    this.web = '',
    this.createdAt,
    this.updatedAt,
    this.rating = 0.01,
    this.totalRating = 0.01,
    this.quantityVoting = 0,
    this.category,
    this.user,
    this.id,
  });

  String name;
  String description;
  String? img;
  String address;
  Coordinates coordinates;
  String facebook;
  String web;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? rating;
  double? totalRating;
  int? quantityVoting;
  Category? category;
  String? user;
  String? id;

  factory Place.fromJson(String str) => Place.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Place.fromMap(Map<String, dynamic> json) => Place(
        name: json["name"],
        description: json["description"],
        img: json["img"],
        address: json["address"],
        coordinates: Coordinates.fromMap(json["coordinates"]),
        facebook: json["facebook"],
        web: json["web"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        rating: json["rating"].toDouble(),
        totalRating: json["totalRating"].toDouble(),
        quantityVoting: json["quantityVoting"],
        category: Category.fromMap(json["category"]),
        user: json["user"],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
        "img": img,
        "address": address,
        "coordinates": coordinates.toMap(),
        "facebook": facebook,
        "web": web,
        "updated_at": updatedAt!.toIso8601String(),
        "rating": rating,
        "totalRating": totalRating,
        "quantityVoting": quantityVoting,
        "category": category!.toMap(),
      };
  Place copy() => Place(
        name: this.name,
        description: this.description,
        img: this.img,
        address: this.address,
        coordinates: this.coordinates,
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
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
      };
}
