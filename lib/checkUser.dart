import 'dart:convert';
import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/HomePage.dart';
import 'package:untitled1/Classes/User.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class checkUser {
  final storage = const FlutterSecureStorage();

  Future<bool> fetchUser(String username) async {
    final response =
        await http.get(Uri.parse('http://10.10.33.91:8080/users/$username'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final user = User.fromJson(jsonData);
      await storage.write(key: 'username', value: username);
      return true;

    } else {
      return false;
    }
  }

}
