
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String sender_id;
  String receiver_id;
  String message;
  String time_sent;
  bool isSeen = false;
  DateTime? timestamp;

  Message(this.id, this.sender_id, this.receiver_id, this.message, this.time_sent, this.isSeen, this.timestamp);
  
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'Sender_id': sender_id,
      'Receiver_id': receiver_id,
      'Message': message,
      'Time_sent': time_sent,
      'IsSeen': isSeen,
      'Ts': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
    };
  }

  static Message fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Message(
      data['id'],
      data['Sender_id'],
      data['Receiver_id'],
      data['Message'],
      data['Time_sent'],
      data['IsSeen'],
      data['Ts'] != null ? (data['Ts'] as Timestamp).toDate() : null,
    );
  }
}