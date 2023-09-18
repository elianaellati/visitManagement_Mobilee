import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Classes/Assignment.dart';
import '../Classes/User.dart';
import '../Classes/StorageManager.dart';

class TaskController extends GetxController {
  final RxList<Assignment> assignmentList = <Assignment>[].obs;

  Future<List<Assignment>> getTasks() async {
    final storageManager = StorageManager();
    final storedUserJson = await storageManager.getObject('user');
     print('storedUserJson $storedUserJson');
    if (storedUserJson == null) {
      throw Exception('Failed to load user');
    }
    final storedUser = User.fromJson(jsonDecode(storedUserJson));
    String username = storedUser.username;
print(username);
    final response = await http.get(
      Uri.parse('http://10.10.33.91:8080/users/$username/visit_assignments'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      assignmentList.assignAll(jsonData
          .map((assignmentJsonList) => Assignment.fromJson(assignmentJsonList))
          .toList());
      return assignmentList;
    } else {
      throw Exception('Failed to load assignments');
    }
  }
}