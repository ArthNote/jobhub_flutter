import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String company;
  String title;
  String start_date;
  String description;
  int num_vacancy;
  int min_exp;
  int max_exp;
  int grad;
  int pgrad;
  String skills;
  String location;
  String type;
  String time;
  int min_pay;
  int max_pay;
  String resp;
  String pub_date;
  String id;
  String rid;

  Job(this.id,this.company, this.title, this.start_date, this.description, this.num_vacancy,
      this.min_exp, this.max_exp, this.grad, this.pgrad, this.skills, this.location,
      this.type,this.time, this.min_pay, this.max_pay, this.resp, this.pub_date, this.rid);

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'Company': company,
      'Title': title,
      'Start_date': start_date,
      'Description': description,
      'Num_vacancy': num_vacancy,
      'Min_exp': min_exp,
      'Max_exp': max_exp,
      'Grad': grad,
      'Pgrad': pgrad,
      'Skills': skills,
      'Location': location,
      'Type': type,
      'Time': time,
      'Min_pay': min_pay,
      'Max_pay': max_pay,
      'Resp': resp,
      'Pub_date': pub_date,
      'Recruiter_id': rid
    };
  }

  static Job fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Job(
      data['id'],
      data['Company'],
      data['Title'],
      data['Start_date'],
      data['Description'],
      data['Num_vacancy'],
      data['Min_exp'],
      data['Max_exp'],
      data['Grad'],
      data['Pgrad'],
      data['Skills'],
      data['Location'],
      data['Type'],
      data['Time'],
      data['Min_pay'],
      data['Max_pay'],
      data['Resp'],
      data['Pub_date'],
      data['Recruiter_id']
    );
  }

}