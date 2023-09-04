import 'dart:core';
import 'dart:core';

class forms {
  final String status;
  final String startTime;
  final String endTime;
  final int id;
  final String customerName;
  final String customerAddress;
  final int customerId;
  final String customerCity;

  forms({
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.customerId,
    required this.customerCity,

  });

  factory forms.fromJson(Map<String, dynamic> json) {
    return forms(
      status: json['status'],
      id:json['id'],
      customerName: json['customer']['name'],
      customerId: json['customer']['id'],
      customerAddress: json['customer']['location']['address'],
      customerCity: json['customer']['location']['cityName'],
      endTime:json['endTime'],
      startTime:json['startTime'],
    );
  }
}
