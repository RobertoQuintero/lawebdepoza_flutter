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
  bool _isLoadingScroll = false;
  bool _isLoading = false;
  String _baseUrl = 'lawebdepoza.herokuapp.com';
  // String _baseUrl = 'localhost:8081';

  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  bool get isLoadingScroll => this._isLoadingScroll;
  set isLoadingScroll(bool value) {
    this._isLoadingScroll = value;
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
      'name': selectedCategory.name.toUpperCase(),
    };
    isLoading = true;

    try {
      final url = Uri.https(_baseUrl, '/api/categories');
      final resp =
          await http.post(url, body: json.encode(categoryData), headers: {
        'Content-Type': 'application/json',
        'x-token': await storage.read(key: 'token') ?? ''
      });
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('msg')) {
        return decodedData['msg'];
      }
      final newCategory = Category.fromMap(decodedData['category']);
      this.categories.add(newCategory);
      isLoading = false;
      return 'Categoría creada';
    } catch (e) {
      print(e);
      isLoading = false;
      return 'Error al crear categoría';
    }
  }

  Future getCategories() async {
    isLoading = true;
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
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
  }

  Future getCategoriesByScrolling() async {
    if (isLoadingScroll) return;
    if (this.categories.length >= total) {
      print('limite alcanzado');
      return;
    }
    isLoadingScroll = true;
    try {
      final url = Uri.https(_baseUrl, '/api/categories',
          {'from': '${this.categories.length}', 'limit': '5'});
      final resp = await http.get(url);
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('categories')) {
        decodedData['categories'].forEach((item) {
          final tempCategory = Category.fromMap(item);
          this.categories.add(tempCategory);
        });
      }
      if (decodedData.containsKey('msg')) {
        print(decodedData['msg']);
      }
    } catch (e) {
      print('fail');
      print(e);
    }
    isLoadingScroll = false;
  }

  Future<String> deleteCategory() async {
    isLoading = true;
    try {
      final url = Uri.https(_baseUrl, '/api/categories/${selectedCategory.id}');
      await http.delete(url,
          headers: {'x-token': await storage.read(key: 'token') ?? ''});
      this.categories = [
        ...this.categories.where((element) => element.id != selectedCategory.id)
      ];
      isLoading = false;
      return 'Categoría Eliminada';
    } catch (e) {
      print(e);
      isLoading = false;
      return 'Error al eliminar categoría';
    }
  }

  Future<String> updateCategory() async {
    final Map<String, dynamic> categoryData = {
      'name': selectedCategory.name.toUpperCase(),
    };

    try {
      final url = Uri.https(_baseUrl, '/api/categories/${selectedCategory.id}');
      await http.put(url, body: json.encode(categoryData), headers: {
        'Content-Type': 'application/json',
        'x-token': await storage.read(key: 'token') ?? ''
      });

      final index = this
          .categories
          .indexWhere((element) => element.id == selectedCategory.id);
      this.categories[index] = selectedCategory;
      return 'Categoría actualizada';
    } catch (e) {
      print(e);
      return 'Error al actualizar categoría';
    }
  }

  createOrUpdate() async {
    this.selectedCategory.id == null
        ? await this.createCategory()
        : await this.updateCategory();
  }
}
