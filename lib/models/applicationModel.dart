
import 'package:cloud_firestore/cloud_firestore.dart';

class Application {
  String id;
  String candidate_id;
  String job_id;
  String recruiter_id;
  String status;
  String date;
  String title;
  String company;

  Application(this.id, this.candidate_id, this.job_id, this.recruiter_id, this.status, this.date, this.title, this.company);

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'Company': company,
      'Title': title,
      'Candidate_id': candidate_id,
      'Job_id': job_id,
      'Recruiter_id': recruiter_id,
      'Status': status,
      'Date': date
    };
  }

  static Application fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Application(
      data['id'],
      data['Candidate_id'],
      data['Job_id'],
      data['Recruiter_id'],
      data['Status'],
      data['Date'],
      data['Title'],
      data['Company']
    );
  }

}