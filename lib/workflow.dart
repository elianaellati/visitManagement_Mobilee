import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomePage.dart';
import 'package:visitManagement_Mobilee/Classes/StorageManager.dart';

class workflow extends StatefulWidget {
  @override
  State<workflow> createState() => _workflowState();
}

class _workflowState extends State<workflow> {
  late String name;


  final StorageManager storageManager = StorageManager();
  late Map<String, dynamic> storedUserJson;
  List<dynamic> pieChartData = [];
  List<dynamic> barChartData = [];
  List<Color> pieChartColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    String? storedUserString = await storageManager.getObject('user');

    try {
      storedUserJson = jsonDecode(storedUserString!);
      if (storedUserJson.containsKey('username')) {
        name = storedUserJson['username'];
        fetchData(name);
      } else {
        print('The key "username" does not exist in the JSON data.');
      }
    } catch (e) {
      print('Error decoding JSON: $e');
    }
  }

  Future<void> fetchData(String username) async {
    final response = await http.get(
      Uri.parse('http://10.10.33.91:8080/reports/users/$username'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      if (data.containsKey('count') &&
          data['count'] is List &&
          data.containsKey('percentages') &&
          data['percentages'] is List) {
        setState(() {
          barChartData = data['count'];
          pieChartData = data['percentages'];
        });
      } else {
        print('Invalid JSON structure: Missing "count" or "percentages" fields.');
      }
    } else {
      print('HTTP request failed with status ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: const NavigatorDrawer(),
          appBar: AppBar(
            title: Text('Chart Examples'),
            backgroundColor: Color(0xFF3F51B5),
            bottom: const TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(icon: Icon(Icons.pie_chart)),
                Tab(icon: Icon(Icons.bar_chart)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2, // Use more space for the pie chart
                          child: Center(
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  for (var i = 0; i < pieChartData.length; i++)
                                    PieChartSectionData(
                                      color: pieChartColors[i],
                                      value: pieChartData[i]['y'].toDouble(),
                                      title: '${(pieChartData[i]['y'] as double).toStringAsFixed(2)}',
                                      radius: 60,
                                      titleStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                ],
                                sectionsSpace: 0,
                                centerSpaceRadius: 70,
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 0), // Add spacing between pie chart and color-text section
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(

                            mainAxisAlignment:MainAxisAlignment.center,

                            children: [
                              for (var i = 0; i < pieChartData.length; i++)
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: pieChartColors[i],
                                    ),
                                    SizedBox(width: 10),
                                    Text(pieChartData[i]['name']),
                                    SizedBox(width: 16),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: 100, // Adjust this value as needed
                  height: 100, // Adjust this value as needed
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 20,
                      titlesData: FlTitlesData(
                        // Customize the left y-axis label
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) {
                            return value.toString();
                          },
                        ),
                        topTitles: SideTitles(
                          showTitles: false,
                        ),
                        rightTitles: SideTitles(
                          showTitles: false,
                        ),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitles: (double value) {
                            if (value.floor() >= 0 && value.floor() < barChartData.length) {
                              return barChartData[value.floor()]['label'].toString();
                            }
                            return '';
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: const Color(0xff37434d),
                          width: 1,
                        ),
                      ),
                      barGroups: [
                        for (var i = 0; i < barChartData.length; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                y: barChartData[i]['y'] != null && barChartData[i]['y'] is num
                                    ? barChartData[i]['y'].toDouble()
                                    : 0.0,
                                colors: [Colors.blue],
                                width: 8, // Reduce the bar width
                              ),
                            ],
                            showingTooltipIndicators: [0],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}