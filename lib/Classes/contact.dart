import 'dart:core';
import 'dart:core';

class contact {
  final String phoneNumber;
  final int id;
  final String firstName;
  final String lastName;
  final String email;


  contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,

  });

  factory contact.fromJson(Map<String, dynamic> json) {
    return contact(
      id:json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber:json['phone'],
      email:json['email'],
    );
  }
}