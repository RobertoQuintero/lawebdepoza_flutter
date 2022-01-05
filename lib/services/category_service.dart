import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lawebdepoza_mobile/models/models.dart';

class CategoryService extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  GlobalKey<FormState> categoryKey = new GlobalKey<FormState>();
  List<Category> categories = [];
  late String category;
  bool _isLoading = false;
  String _baseUrl = 'lawebdepoza.herokuapp.com';

  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return categoryKey.currentState?.validate() ?? false;
  }

  Future createCategory() async {
    print(category);
    final Map<String, dynamic> categoryData = {
      'name': category,
    };

    try {
      final url = Uri.https(_baseUrl, '/api/categories');
      final resp =
          await http.post(url, body: json.encode(categoryData), headers: {
        'Content-Type': 'application/json',
        'x-token': await storage.read(key: 'token') ?? ''
      });
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('category')) {
        print(decodedData['category']);
      } else {
        print(decodedData['msg']);
      }
    } catch (e) {
      print(e);
    }
  }
}
