import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'checkUser.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

void main() {
  DefaultCacheManager().emptyCache();
  runApp(const MaterialApp(

    home: LoginPage(),
  ));
}
