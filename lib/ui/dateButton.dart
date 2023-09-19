import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'theme.dart';

class DateTimeline extends StatelessWidget {
  final List<DateTime> specialDates;

  late final List<DateTime> dateList;
  final Function(DateTime) onDateSelected;

  DateTimeline({Key? key, required this.specialDates, required this.onDateSelected}) : super(key: key) {
    dateList = generateDateList();
  }


  List<DateTime> generateDateList() {
    final List<DateTime> dateList = [];
    final DateTime currentDate =
        DateTime.now().subtract(const Duration(days: 7));
    // final DateTime currentDate =
    //     DateTime.now();
    final DateTime currentDateWithoutTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    for (int i = 0; i < 37; i++) {
      // Add the current date and the next 2 months
      final DateTime date = currentDateWithoutTime.add(Duration(days: i));
      dateList.add(date);
    }

    return dateList;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Adjust the height as needed
      child: ListView.builder(

        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        itemBuilder: (context, index) {
          final currentDate = dateList[index];
          final bool specialDate = isDateSpecial(currentDate);

          return DataButton(
            date: currentDate,
            isSpecial: specialDate,
            onDateSelected: onDateSelected,
          );
        },
      ),
    );
  }

  bool isDateSpecial(DateTime date) {
    return specialDates.contains(date);
  }
}

class DataButton extends StatelessWidget {
  final DateTime date;
  final bool isSpecial;
  final Function(DateTime) onDateSelected;

  DataButton({Key? key, required this.date, this.isSpecial = false,required this.onDateSelected})
      : super(key: key);
  void _handleTap() {
    onDateSelected(date);
    // Add your logic for handling the tap here
    print("DataButton tapped for date: $date");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap, // Assign the onTap callback
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSpecial ? Colors.lightBlue[100] : Colors.transparent,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.MMM().format(date),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormat.d().format(date),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormat.E().format(date),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
