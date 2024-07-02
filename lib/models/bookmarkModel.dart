
import 'package:cloud_firestore/cloud_firestore.dart';

class BookMark {
  String id;
  String cid;
  String jid;
  String title;
  String company;
  String location;
  String type;
  String time;
  int min_exp;
  int max_exp;
  String date;

  BookMark(this.id, this.cid, this.jid, this.title, this.company, this.location, this.type, this.time, this.min_exp, this.max_exp, this.date);

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'Candidate_id': cid,
      'Job_id': jid,
      'Title': title,
      'Company': company,
      'Location': location,
      'Type': type,
      'Time': time,
      'Min_exp': min_exp,
      'Max_exp': max_exp,
      'Date': date
    };
  }

  static BookMark fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BookMark(
      data['id'],
      data['Candidate_id'],
      data['Job_id'],
      data['Title'],
      data['Company'],
      data['Location'],
      data['Type'],
      data['Time'],
      data['Min_exp'],
      data['Max_exp'],
      data['Date']
    );
  }
}