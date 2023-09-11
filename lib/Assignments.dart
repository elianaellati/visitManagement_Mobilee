import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visitManagement_Mobilee/taskTitle.dart';
import 'package:visitManagement_Mobilee/ui/size_config.dart';
import 'package:visitManagement_Mobilee/ui/theme.dart';
import 'Classes/Assignment.dart';
import 'AssignmentDetails.dart';
import 'HomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'controllers/_taskController.dart';
import 'main.dart';

class Assignments extends StatefulWidget {
  const Assignments({Key? key}) : super(key: key);

  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  List<DateTime> datesWithTasks = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  void didUpdateWidget(covariant Assignments oldWidget) {
    super.didUpdateWidget(oldWidget);
    refresh();
  }

  void refresh() {
    _taskController.getTasks().then((tasks) {
      datesWithTasks.clear();
      for (var task in tasks) {
        var outputFormat = DateFormat('dd-MM-yyyy');
        try {
          var parsedDate = outputFormat.parse(task.date);
          var date = parsedDate.toLocal();
          if (!datesWithTasks.contains(date)) {
            datesWithTasks.add(date);
          }
        } catch (e) {
          print('Error parsing time: $e');
        }
      }
      setState(() {});
    });
  }

  Color _dateColor(DateTime date) {
    return datesWithTasks.contains(date) ? Colors.green : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigatorDrawer(),
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: Color(0xFF3F51B5),
      ),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 6,
          ),
          showTasks(),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 100,
        initialSelectedDate: _selectedDate,
        selectedTextColor: Colors.white,
        selectionColor: Colors.green, // استخدم هنا اللون الأخضر كلون افتراضي
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            )),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today',
                style: subHeadingStyle,
              ),
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget showTasks() {
    return Expanded(
      child: Obx(() {
        final hasTasksForSelectedDate = _taskController.assignmentList.any((task) {
          var outputFormat = DateFormat('dd-MM-yyyy');
          try {
            var parsedDate = outputFormat.parse(task.date);
            return outputFormat.format(parsedDate) ==
                outputFormat.format(_selectedDate);
          } catch (e) {
            print('Error parsing time: $e');
            return false;
          }
        });

        if (_taskController.assignmentList.isEmpty || !hasTasksForSelectedDate) {
          return _noTaskMsg();
        } else {
          return ListView.builder(
            scrollDirection: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            itemCount: _taskController.assignmentList.length,
            itemBuilder: (BuildContext context, int index) {
              var task = _taskController.assignmentList[index];
              var outputFormat = DateFormat('dd-MM-yyyy');
              try {
                var parsedDate = outputFormat.parse(task.date);
                if (outputFormat.format(parsedDate) ==
                    outputFormat.format(_selectedDate)) {
                  print(
                      'Assignment with matching date: ${task.comment} - ${task.date}');
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AssignmentDetails(task),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 5),
                          child: TaskTitle(task),
                        ),
                      ),
                    ),
                  );
                }
              } catch (e) {
                print('Error parsing time: $e');
              }
              return Container();
            },
          );
        }
      }),
    );
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
                  color: primaryClr.withOpacity(0.5),
                  height: 90,
                  semanticsLabel: 'Task',
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'You do not have any tasks yet!',
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
}
