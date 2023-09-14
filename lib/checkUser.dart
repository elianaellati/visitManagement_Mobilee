import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visitManagement_Mobilee/HomePage.dart';
import 'package:visitManagement_Mobilee/Classes/User.dart';
import 'package:http/http.dart' as http;
import 'Classes/StorageManager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CheckUser {
  Future<bool> fetchUser(String username) async {
    final response =
        await http.get(Uri.parse('http://10.10.33.91:8080/users/$username'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final user = User.fromJson(jsonData);
      final userJson = jsonEncode(user.toJson());
      final storageManager = StorageManager();
      await storageManager.storeObject('user',userJson);

      return true;
    } else {
      return false;
    }
  }
}
