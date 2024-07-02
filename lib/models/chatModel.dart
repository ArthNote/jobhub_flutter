
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  String cid;
  String rid;
  String cname;
  String rname;
  String last_msg;
  String time_sent;
  int cunread_msg;
  int runread_msg;
  //create a null FieldValue
  DateTime? timestamp;

  Chat(this.id, this.cid, this.rid, this.cname, this.rname, this.last_msg, this.time_sent, this.cunread_msg, this.runread_msg, this.timestamp);
  
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'Candidate_id': cid,
      'Recruiter_id': rid,
      'Candidate_name': cname,
      'Recruiter_name': rname,
      'Last_msg': last_msg,
      'Time_sent': time_sent,
      'CUnread_msg': cunread_msg,
      'RUnread_msg': runread_msg,
      'Ts': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
    };
  }

  static Chat fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Chat(
      data['id'],
      data['Candidate_id'],
      data['Recruiter_id'],
      data['Candidate_name'],
      data['Recruiter_name'],
      data['Last_msg'],
      data['Time_sent'],
      data['CUnread_msg'],
      data['RUnread_msg'],
      data['Ts'] != null ? (data['Ts'] as Timestamp).toDate() : null,
    );
  }
}