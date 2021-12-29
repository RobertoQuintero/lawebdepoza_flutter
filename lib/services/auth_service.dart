import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'lawebdepoza.herokuapp.com';

  final storage = new FlutterSecureStorage();

  Future<String?> createUser(String email, String password, String name) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'name': name
    };

    final url = Uri.https(_baseUrl, '/api/users');

    final resp = await http.post(url,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('token')) {
      await storage.write(key: 'token', value: decodedResp['token']);
      return null;
    } else {
      return decodedResp['errors'][0]['msg'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseUrl, '/api/auth/login');

    final resp = await http.post(url,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('token')) {
      await storage.write(key: 'token', value: decodedResp['token']);
      return null;
    } else {
      return decodedResp['msg'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
