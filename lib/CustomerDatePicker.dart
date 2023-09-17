import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:visitManagement_Mobilee/ui/theme.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialSelectedDate;
  final List<DateTime> assignmentDates;

  CustomDatePicker({
    required this.initialSelectedDate,
    required this.assignmentDates,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemCount: DateTime.daysPerWeek,
        itemBuilder: (context, index) {
          final currentDate = _selectedDate.subtract(
            Duration(days: _selectedDate.weekday - 1),
          );

          final isToday = DateTime.now().isAtSameMomentAs(currentDate);
          final isInAssignmentDates = widget.assignmentDates.contains(currentDate);

          final textColor = isToday ? Colors.white : Colors.grey;
          final icon = isInAssignmentDates ? Icons.assignment : null;

          return GestureDetector(
            onTap: () {
              if (!isInAssignmentDates) {
                setState(() {
                  _selectedDate = currentDate;
                });
                // Handle date selection here
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isToday ? Colors.blue : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentDate.day.toString(),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (icon != null)
                      Icon(
                        icon,
                        color: Colors.red, // Customize the icon color
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
