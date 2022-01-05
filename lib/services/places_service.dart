import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/models/models.dart';
import 'package:http/http.dart' as http;

class PlacesService extends ChangeNotifier {
  final String _baseUrl = 'lawebdepoza.herokuapp.com';
  final List<Place> places = [];
  late Place selectedPlace;
  late double total;

  bool isLoading = true;
  bool isSaving = false;
  PlacesService() {
    loadPlaces();
  }

  Future loadPlaces() async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.https(_baseUrl, '/api/places');
      final resp = await http.get(url);
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      print(decodedData);
      for (var item in decodedData['places']) {
        final place = Place.fromMap(item);
        places.add(place);
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
