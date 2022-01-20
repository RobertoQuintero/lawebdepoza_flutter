import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lawebdepoza_mobile/models/models.dart';
import 'package:http/http.dart' as http;

class UsersService extends ChangeNotifier {
  List<User> users = [];
  int total = 0;
  bool _isLoading = false;
  final String _baseUrl = 'lawebdepoza.herokuapp.com';

  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
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
}
