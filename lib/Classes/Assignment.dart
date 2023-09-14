class Assignment {
  final String comment;
  final String date;
  final String type;
  final int id;
  final String status;


  Assignment({
    required this.comment,
    required this.date,
    required this.type,
    required this.id,
    required this.status,

  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      comment: json['comment'],
      date: json['date'],
      type: json['visitType']['name'],
      id:json['id'],
      status:json['status'],

    );
  }
}