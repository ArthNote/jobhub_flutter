import 'package:cloud_firestore/cloud_firestore.dart';

class UserM {
  String id;
  String fname;
  String lname;
  String gender;
  String email;
  String phone;
  String password;
  String about;
  String type;
  int grad;
  int pgrad;
  int exp;
  String specs;
  String skills;
  int views;

  //create a constructor that doesnt need any parameters
  UserM(this.id, this.fname, this.lname, this.gender, this.email, this.phone,
      this.password, this.about, this.type, this.grad, this.pgrad, this.exp, this.specs, this.skills, this.views);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FirstName': fname,
      'LastName': lname,
      'Gender': gender,
      'Email': email,
      'Phone': phone,
      'Password': password,
      'About': about,
      'Type': type,
      'Graduation_Percentage': grad,
      'Post_Graduation_Percentage': pgrad,
      'Experience': exp,
      'Specialization': specs,
      'Skills': skills,
      'Views': views
    };
  }
  
  static UserM fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserM(
        data['id'],
        data['FirstName'],
        data['LastName'],
        data['Gender'],
        data['Email'],
        data['Phone'],
        data['Password'],
        data['About'],
        data['Type'],
        data['Graduation_Percentage'],
        data['Post_Graduation_Percentage'],
        data['Experience'],
        data['Specialization'],
        data['Skills'],
        data['Views']);
    //return something
  }
}
