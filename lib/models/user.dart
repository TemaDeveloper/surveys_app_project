import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? first_name;
  final String? last_name;
  final String? email;
  final Timestamp? date;
  final String? phone;
  final String? id;
  final String? zip;
  final bool? survey_completed;

  UserModel({this.id, this.first_name, this.last_name, this.email, this.date, this.phone, this.survey_completed, this.zip});

  static UserModel fromSnaphot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
        id: snapshot['id'],
        first_name: snapshot['first_name'],
        last_name: snapshot['last_name'],
        zip: snapshot['zip'],
        email: snapshot['email'],
        date: snapshot['last_entered'],
        phone: snapshot['phone'], 
        survey_completed: snapshot['survey_completed']
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": first_name,
      "last_name": last_name,
      "zip": zip,
      "email": email,
      "last_entered": date,
      "phone": phone,
      "survey_completed": survey_completed
    };
  }
}
