import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? name;
  final String? email;
  final Timestamp? date;
  final String? phone;
  final String? id;
  final bool? survey_completed;

  UserModel({this.id, this.name, this.email, this.date, this.phone, this.survey_completed});

  static UserModel fromSnaphot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
        id: snapshot['id'],
        name: snapshot['name'],
        email: snapshot['email'],
        date: snapshot['last_entered'],
        phone: snapshot['phone'], 
        survey_completed: snapshot['survey_completed']
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "last_entered": date,
      "phone": phone,
      "survey_completed": survey_completed
    };
  }
}
