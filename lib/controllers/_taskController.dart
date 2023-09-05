import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Classes/Assignment.dart';

class TaskController extends GetxController {
  final RxList<Assignment> taskList = <Assignment>[].obs;

  Future<List<Assignment>> getTasks() async {
    final response = await http.get(
      Uri.parse('http://10.10.33.91:8080/users/halamon/visit_assignments'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      print('Received Data: $jsonData');
      taskList.assignAll(jsonData.map((userJson) => Assignment.fromJson(userJson)).toList());
      return taskList;
    } else {
      throw Exception('Failed to load assignments');
    }
  }
}
