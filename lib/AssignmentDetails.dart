import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Dialogue.dart';
import 'Classes/forms.dart';
import 'package:http/http.dart' as http;

class AssignmentDetails extends StatefulWidget {
  final int assignmentId;

  AssignmentDetails(this.assignmentId);

  @override
  State<StatefulWidget> createState() {
    return AssignmentDetailsState();
  }
}

class AssignmentDetailsState extends State<AssignmentDetails> {
  late Future<List<forms>> futureAssignment;

  @override
  void initState() {
    super.initState();
    futureAssignment = fetchAssignments(widget.assignmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
      ),
      body: FutureBuilder<List<forms>>(
        future: futureAssignment,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No Assignment Details available.');
          } else {
            final assignmentDetails = snapshot.data!;

            // Create a list of widgets to display assignment details
            final assignmentWidgets = assignmentDetails.map((assignment) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Dialogue(assignment),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(assignment.customerName), // Adjust the property you want to display
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( '${assignment.customerCity},${assignment.customerAddress}')
                      // Add more widgets to display other details
                    ],
                  ),
              ),
              );

            }).toList();

            return ListView(
              children: assignmentWidgets,
            );
          }
        },
      ),
    );
  }
}

Future<List<forms>> fetchAssignments(int assignmentId) async {
  final response = await http.get(
    Uri.parse('http://10.10.33.91:8080/visit_assignments/$assignmentId/forms'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((userJson) {
      final customerName = userJson['customer']['name'] ?? 'Unknown Customer';
      final customerAddress = userJson['customer']['location']['address'] ?? 'Unknown Address';
      final customerCity = userJson['customer']['location']['cityName'] ?? 'Unknown city';
      final customerId = userJson['customer']['id'] ?? 'Unknown customer id';
      final endTime = userJson['endTime'] ??'Unknown endTime';
      final startTime = userJson['startTime']?? 'Unknown startTime';
      final status=userJson['status']?? 'Unknown status';
      final id=userJson['id']?? 'Unknown id';


      return forms(
        customerName: customerName,
        customerAddress: customerAddress, status: status, startTime: startTime, endTime: endTime, id: id, customerId:customerId, customerCity: customerCity,
      );

    }).toList();
  } else {
    print('API Request Failed: ${response.statusCode}');
    throw Exception('Failed to load assignment details');
  }
}
