import 'dart:convert';

import 'package:flutter/material.dart'; // Updated import to use MaterialApp
import 'package:http/http.dart' as http;

class Survey extends StatefulWidget {
  final String id;

  const Survey(this.id, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SurveyState(id: id); // Pass the id to SurveyState
  }
}

class SurveyState extends State<Survey> {
  final String id; // Declare id as an instance variable

  SurveyState({required this.id}); // Constructor to receive the id

  late Future<List<String>> questions; // Declare questions

  @override
  void initState() {
    super.initState();
    questions = fetchQuestions(int.parse(id)); // Use the passed id
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Questions'),
      ),
      body: FutureBuilder<List<String>>(
        future: questions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Display a loading indicator while fetching data.
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final questionList = snapshot.data;
            return ListView.builder(
              itemCount: questionList!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(questionList[index]),
                );
              },
            );
          } else {
            return Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
    );
  }
}

Future<List<String>> fetchQuestions(int assignmentId) async {
  print('${assignmentId}');
  final response = await http.get(
    Uri.parse('http://10.10.33.91:8080/visit_assignments/43/questions'),
  );

  if (response.statusCode == 200) {
    // Parse and return the questions from the response
    final List<dynamic> data = json.decode(response.body);
    final List<String> questions =
    data.map((item) => item['question'] as String).toList();

    return questions;
  } else {
    throw Exception('Failed to load questions ${assignmentId}');
  }
}

void main() {
  runApp(MaterialApp(
    home: Survey('1'), // Provide an example survey id
  ));
}
