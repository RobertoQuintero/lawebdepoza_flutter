import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lawebdepoza_mobile/models/models.dart';

class CategoryService extends ChangeNotifier {
  final storage = new FlutterSecureStorage();
  GlobalKey<FormState> categoryKey = new GlobalKey<FormState>();
  List<Category> categories = [];
  late Category selectedCategory;
  late int total;
  bool _isLoading = false;
  String _baseUrl = 'lawebdepoza.herokuapp.com';

  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  CategoryService() {
    this.getCategories();
  }

  bool isValidForm() {
    return categoryKey.currentState?.validate() ?? false;
  }

  Future createCategory() async {
    final Map<String, dynamic> categoryData = {
      'name': selectedCategory.name,
    };

    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.https(_baseUrl, '/api/categories');
      final resp =
          await http.post(url, body: json.encode(categoryData), headers: {
        'Content-Type': 'application/json',
        'x-token': await storage.read(key: 'token') ?? ''
      });
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('category')) {
        final newCategory = Category.fromMap(decodedData['category']);
        this.categories.add(newCategory);
        isLoading = false;
        notifyListeners();
      } else {
        print(decodedData['msg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCategories() async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.https(_baseUrl, '/api/categories');
      final resp = await http.get(url);
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('categories')) {
        total = decodedData['total'];
        decodedData['categories'].forEach((item) {
          final tempCategory = Category.fromMap(item);
          this.categories.add(tempCategory);
        });
        print(categories);
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }

  Future deleteCategory() async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.https(_baseUrl, '/api/categories/${selectedCategory.id}');
      await http.delete(url,
          headers: {'x-token': await storage.read(key: 'token') ?? ''});
      this.categories = [
        ...this.categories.where((element) => element.id != selectedCategory.id)
      ];
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future updateCategory() async {
    final Map<String, dynamic> categoryData = {
      'name': selectedCategory.name,
    };
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.https(_baseUrl, '/api/categories/${selectedCategory.id}');
      final resp =
          await http.put(url, body: json.encode(categoryData), headers: {
        'Content-Type': 'application/json',
        'x-token': await storage.read(key: 'token') ?? ''
      });
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      print(decodedData);
      isLoading = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  createOrUpdate() {
    this.selectedCategory.id == null
        ? this.createCategory()
        : this.updateCategory();
    isLoading = false;
    notifyListeners();
  }
}
