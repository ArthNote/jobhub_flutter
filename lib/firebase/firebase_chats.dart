

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorial2/firebase/firebase_messages.dart';
import 'package:tutorial2/global/toast.dart';
import 'package:tutorial2/models/chatModel.dart';

class ChatStuff {

  Future<bool> startChat(Chat newChat) async {
    try {
      final docChat = FirebaseFirestore.instance.collection("Chats").doc();
      String cid = docChat.id;
      newChat.id = cid;
      await docChat.set(newChat.toJson());
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  //check if chat exists
  Future<bool> checkChat(String cid, String rid) async {
    try {
      final docChat = await FirebaseFirestore.instance.collection("Chats").where("Candidate_id", isEqualTo: cid).where("Recruiter_id", isEqualTo: rid).get();
      if (docChat.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }


  Stream<QuerySnapshot> getChats(String id, String name) {
    try {
      return FirebaseFirestore.instance.collection("Chats").where(name, isEqualTo: id).orderBy("Ts", descending: true).snapshots();
    } catch (e) {
      showToast(message: e.toString());
      return Stream.empty(); // Return an empty stream in case of an error
    }
  }


  Future<bool> updateChat(String id, String msg, String time, Timestamp ts) async {
    try {
      final docChat = FirebaseFirestore.instance.collection("Chats").doc(id);
      await docChat.update({"Last_msg": msg, "Time_sent": time, "Ts": ts});
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<void> updateUnSeen(String did, int count,String where) async {
    try {
      final docChat = FirebaseFirestore.instance.collection("Chats").doc(did);
      await docChat.update({where: count});
    } catch(e) { 
      showToast(message: e.toString());
    }
  }


  //update the RUnseen field in doc


  //get the candidate id where doc id
  Future<String> getCid(String id) async {
    try {
      final docChat = await FirebaseFirestore.instance.collection("Chats").doc(id).get();
      return docChat.data()!["Candidate_id"];
    } catch(e) { 
      showToast(message: e.toString());
      return "";
    }
  }

  //sum all CUnread_msg
  Future<int> sumCUnread(String cid) async {
    try {
      final docChat = await FirebaseFirestore.instance.collection("Chats").where("Candidate_id", isEqualTo: cid).get();
      return docChat.docs.map((e) => e.data()["CUnread_msg"]).reduce((value, element) => value + element);
    } catch(e) { 
      showToast(message: e.toString());
      return 0;
    }
  }

  
  



}