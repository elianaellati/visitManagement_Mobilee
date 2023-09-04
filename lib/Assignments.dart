import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Classes/Assignment.dart';
import 'AssignmentDetails.dart';
import 'HomePage.dart';
import 'main.dart';

/*void main() {
  runApp(const MaterialApp(
    home: Assignments(),
  ));
}*/

class Assignments extends StatefulWidget {
  const Assignments({Key? key}) : super(key: key);

  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  late Future<List<Assignment>> futureAssignment;

  @override
  void initState() {
    super.initState();
    futureAssignment = fetchAssignments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigatorDrawer(),
      appBar: AppBar(
        title: const Text('Assignments'),
      ),
      body: Center(
        child: FutureBuilder<List<Assignment>>(
          future: futureAssignment,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No Assignments available.');
            } else {
              final assignments = snapshot.data!;

              // Create a list of widgets to display assignment details
              final assignmentWidgets = assignments.map((assignment) {
                return GestureDetector(
                  onTap: () {
                    // When a list item is clicked, navigate to a new widget
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AssignmentDetails(
                                assignment.id), // Pass the assignment ID
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(assignment.comment),
                    subtitle: Text(assignment.type),
                    trailing: _buildStatusIcon(assignment.status),
                   // trailing: Text(assignment.date),
                  ),
                );
              }).toList();

              return ListView(
                children: assignmentWidgets,
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Assignment>> fetchAssignments() async {
    final response = await http.get(
      Uri.parse('http://10.10.33.91:8080/users/halamon/visit_assignments'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) => Assignment.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
  Widget _buildStatusIcon(String status) {
    Icon icon;
    Color iconColor;

    // Define icons and colors based on status
    if (status == "Completed") {
      icon = Icon(Icons.check_circle, color: Colors.green);
    } else if (status == "In Progress") {
      icon = Icon(Icons.access_time, color: Colors.orange);
    } else if (status == "Not Started") {
      icon = Icon(Icons.error, color: Colors.red);
    } else {
      // Handle other statuses or default case here
      icon = Icon(Icons.error, color: Colors.grey);
    }

    return icon;
  }

}