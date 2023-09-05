class User{
   final String username;
   final  String firstname;
   final String lastName;

   const User ({
     required this.username,
     required this.firstname,
     required this.lastName,
   });
   factory User.fromJson( Map<String, dynamic> json) {
     return User(
       username: json['username'],
       firstname: json['firstName'],
       lastName:json['lastName'],
     );
   }
   Map<String, dynamic> toJson() {
     return {
       'username': username,
       'firstName': firstname,
       'lastName': lastName,
     };
   }
}