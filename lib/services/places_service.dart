import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lawebdepoza_mobile/models/models.dart';
import 'package:http/http.dart' as http;

class PlacesService extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final String _baseUrl = 'lawebdepoza.herokuapp.com';
  List<Place> places = [];
  late Place selectedPlace;
  late Place place;
  late double total;
  File? newPictureFile;

  final storage = new FlutterSecureStorage();

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  bool isLoading = true;
  bool isSaving = false;
  PlacesService() {
    loadPlaces();
  }

  set coordinates(Coordinates value) {
    selectedPlace.coordinates = value;
    notifyListeners();
  }

  Future loadPlaces() async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.https(_baseUrl, '/api/places');
      final resp = await http.get(url);
      final Map<String, dynamic> decodedData = json.decode(resp.body);
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

  void updateSelectedPlaceImage(String path) {
    this.selectedPlace.img = path;
    this.newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage(Uri url, String verb) async {
    if (this.newPictureFile == null) return null;
    this.isSaving = true;
    notifyListeners();
    final Map<String, String> headers = {
      'x-token': await storage.read(key: 'token') ?? ''
    };

    final imageUploadRequest = http.MultipartRequest(
      verb,
      url,
    );
    imageUploadRequest.headers.addAll(headers);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salió mal!');
      return null;
    }
    this.newPictureFile = null;
    final decodedData = json.decode(resp.body);

    selectedPlace.img = decodedData['url'];
    return decodedData['url'];
  }

  Future postPlace() async {
    isSaving = true;
    notifyListeners();
    try {
      final url = Uri.https(_baseUrl, '/api/places');
      selectedPlace.updatedAt = DateTime.now();
      final resp = await http.post(url, body: selectedPlace.toJson(), headers: {
        'Content-Type': 'application/json',
        'x-token': await storage.read(key: 'token') ?? ''
      });
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      selectedPlace.id = decodedData['_id'];
      selectedPlace.user = decodedData['user'];
      selectedPlace.createdAt = DateTime.parse(decodedData['created_at']);
      this.places.add(selectedPlace);
    } catch (e) {
      print(e);
    }
    isSaving = false;
    notifyListeners();
  }

  Future updatePlace() async {
    isSaving = true;
    notifyListeners();

    try {
      final url = Uri.https(_baseUrl, '/api/places/${selectedPlace.id}');
      await http.put(url, body: selectedPlace.toJson(), headers: {
        'Content-Type': 'application/json',
        'x-token': await storage.read(key: 'token') ?? ''
      });

      final index =
          this.places.indexWhere((element) => element.id == selectedPlace.id);
      this.place = selectedPlace;
      this.places[index] = selectedPlace;
    } catch (e) {
      print('fail');
      print(e);
    }
    isSaving = false;
    notifyListeners();
  }

  Future createOrUpdate() async {
    if (selectedPlace.id == null) {
      final url = Uri.parse('https://$_baseUrl/api/uploads');
      await uploadImage(url, 'POST');
      await postPlace();
    } else {
      if (!selectedPlace.img!.startsWith('https')) {
        final imageArr = this
            .places
            .firstWhere((element) => element.id == selectedPlace.id)
            .img!
            .split('/');
        final image = imageArr[imageArr.length - 1];
        final nameArr = image.split('.');
        final name = nameArr[0];

        final url = Uri.parse('https://$_baseUrl/api/uploads/$name');
        await uploadImage(url, 'PUT');
      }
      await updatePlace();
    }
  }

  Future deletePlace() async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.https(_baseUrl, '/api/places/${selectedPlace.id}');
      final resp = await http.delete(url,
          headers: {'x-token': await storage.read(key: 'token') ?? ''});

      if (resp.body.isNotEmpty) {
        final Map<String, dynamic> decodedData = json.decode(resp.body);

        if (decodedData.isNotEmpty) {
          isLoading = false;
          notifyListeners();
          return decodedData['msg'];
        }
      }
      this.places.remove(place);
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
