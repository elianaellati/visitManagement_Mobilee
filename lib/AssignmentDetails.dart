import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visitManagement_Mobilee/ui/size_config.dart';
import 'package:visitManagement_Mobilee/ui/theme.dart';

import 'Classes/Assignment.dart';
import 'Dialogue.dart';
import 'Classes/forms.dart';
import 'package:http/http.dart' as http;

import 'formTitle.dart';

class AssignmentDetails extends StatefulWidget {
  final Assignment assignment;

  AssignmentDetails(this.assignment);

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
    futureAssignment = fetchAssignments(widget.assignment.id);
  }

//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forms'),
//         backgroundColor: Color(0xFF3F51B5),
//       ),
//       body: FutureBuilder<List<forms>>(
//         future: futureAssignment,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Text('No Assignment Details available.');
//           } else {
//             final assignmentDetails = snapshot.data!;
//             final assignmentWidgets = assignmentDetails.map((assignment) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           Dialogue(assignment),
//                     ),
//                   );
//                 },
//                 child: ListTile(
//                   title: Text(assignment.customerName), // Adjust the property you want to display
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text( '${assignment.customerCity},${assignment.customerAddress}')
//                       // Add more widgets to display other details
//                     ],
//                   ),
//               ),
//               );
//
//             }).toList();
//
//             return ListView(
//               children: assignmentWidgets,
//             );
//           }
//         },
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
        backgroundColor: Color(0xFF3F51B5),
      ),
      body: FutureBuilder<List<forms>>(
        future: futureAssignment,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _noTaskMsg();
          } else {
            final assignmentDetails = snapshot.data!;
            return ListView.builder(
              itemCount: assignmentDetails.length,
              itemBuilder: (context, index) {
                final assignment = assignmentDetails[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Dialogue(assignment),
                          ),
                        );
                      },
                      child: formTitle(assignment),
                      // child: ListTile(
                      //   title: Text(assignment.customerName),
                      //   subtitle: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text('${assignment.customerCity}, ${assignment
                      //           .customerAddress}'),
                      //       Add more widgets to display other details
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }


  Future<List<forms>> fetchAssignments(int assignmentId) async {
    final response = await http.get(
      Uri.parse(
          'http://10.10.33.91:8080/visit_assignments/$assignmentId/forms'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) {
        final customerName = userJson['customer']['name'] ?? 'Unknown Customer';
        final customerAddress = userJson['customer']['location']['address'] ??
            'Unknown Address';
        final customerCity = userJson['customer']['location']['cityName'] ??
            'Unknown city';
        final customerId = userJson['customer']['id'] ?? 'Unknown customer id';
        final endTime = userJson['endTime'] ?? 'Unknown endTime';
        final startTime = userJson['startTime'] ?? 'Unknown startTime';
        final status = userJson['status'] ?? 'Unknown status';
        final id = userJson['id'] ?? 'Unknown id';


        return forms(
          customerName: customerName,
          customerAddress: customerAddress,
          status: status,
          startTime: startTime,
          endTime: endTime,
          id: id,
          customerId: customerId,
          customerCity: customerCity,
        );
      }).toList();
    } else {
      print('API Request Failed: ${response.statusCode}');
      throw Exception('Failed to load assignment details');
    }
  }
}

_noTaskMsg() {
  return Stack(
    children: [
      AnimatedPositioned(
        duration: const Duration(milliseconds: 2000),
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: [
              SizeConfig.orientation == Orientation.landscape
                  ? const SizedBox(
                height: 6,
              )
                  : const SizedBox(
                height: 220,
              ),
              SvgPicture.asset(
                'images/task.svg',
                // ignore: deprecated_member_use
                color: primaryClr.withOpacity(0.5),
                height: 90,
                semanticsLabel: 'Task',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 10),
                child: Text(
                  'No Forms  available.!',
                  style: subTitleStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizeConfig.orientation == Orientation.landscape
                  ? const SizedBox(
                height: 90,
              )
                  : const SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),

    ],
  );
}
