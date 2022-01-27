import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UsersService extends ChangeNotifier {
  List<User> users = [];
  late User selectedUser;
  int total = 0;
  bool _isLoading = false;
  bool _isLoadingScroll = false;
  final String _baseUrl = 'lawebdepoza.herokuapp.com';

  final storage = new FlutterSecureStorage();

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

  isAdmin(String uid) {
    if (uid == 'ADMIN_ROLE' || uid == 'SUPER_ADMIN_ROLE') {
      return true;
    }
    return false;
  }

  UsersService() {
    this.getUsers();
  }

  Future getUsers() async {
    isLoading = true;
    final url = Uri.https(_baseUrl, '/api/users');
    try {
      final resp = await http.get(url);
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('users')) {
        total = decodedData['total'];
        decodedData['users'].forEach((item) {
          final tempUser = User.fromMap(item);
          this.users.add(tempUser);
        });
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
  }

  Future getUsersByScrolling() async {
    if (isLoadingScroll) return;
    if (this.users.length >= total) {
      print('limite alcanzado');
      return;
    }
    isLoadingScroll = true;
    try {
      final url = Uri.https(_baseUrl, '/api/users',
          {'from': '${this.users.length}', 'limit': '5'});
      final resp = await http.get(url);
      final Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('msg')) {
        isLoadingScroll = false;
        return decodedData['msg'];
      }
      if (decodedData.containsKey('users')) {
        decodedData['users'].forEach((item) {
          final tempUser = User.fromMap(item);
          this.users.add(tempUser);
        });
      }
      isLoadingScroll = false;
    } catch (e) {
      print(e);
      isLoadingScroll = false;
      return 'Error al cargar usuarios';
    }
  }

  Future updateUser() async {
    if (selectedUser.role == 'SUPER_ADMIN_ROLE') return;
    isLoading = true;
    try {
      final role =
          selectedUser.role == 'USER_ROLE' ? 'ADMIN_ROLE' : 'USER_ROLE';
      selectedUser.role = role;
      final url = Uri.https(_baseUrl, '/api/users/${selectedUser.uid}');
      final resp = await http.put(url, body: selectedUser.toJson(), headers: {
        'Content-Type': 'application/json',
        'x-token': await storage.read(key: 'token') ?? ''
      });
      if (resp.body.isNotEmpty) {
        final Map<String, dynamic> decodedData = json.decode(resp.body);

        if (decodedData.isNotEmpty) {
          isLoading = false;
          return decodedData['msg'];
        }
      }

      final index =
          this.users.indexWhere((element) => element.uid == selectedUser.uid);
      this.users[index] = selectedUser;
    } catch (e) {
      print(e);
      isLoading = false;
      return 'Error al actualizar';
    }
    isLoading = false;
  }

  Future deleteUser() async {
    isLoading = true;
    try {
      final url = Uri.https(_baseUrl, '/api/users/${selectedUser.uid}');
      final resp = await http.delete(url,
          headers: {'x-token': await storage.read(key: 'token') ?? ''});

      if (resp.body.isNotEmpty) {
        final Map<String, dynamic> decodedData = json.decode(resp.body);

        if (decodedData.isNotEmpty) {
          isLoading = false;
          return decodedData['msg'];
        }
      }
      this.users.remove(selectedUser);
    } catch (e) {
      print(e);
      return 'Error al borrar';
    }
    isLoading = false;
  }
}
