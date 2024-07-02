

// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tutorial2/firebase/firebase_chats.dart';
import 'package:tutorial2/global/toast.dart';
import 'package:tutorial2/models/messageModel.dart';

class MessageStuff {

  Future<bool> sendMessage(Message newMsg, String chat_id) async {
    try {
      final docMsg = FirebaseFirestore.instance.collection("Chats").doc(chat_id).collection("Messages").doc();
      String mid = docMsg.id;
      newMsg.id = mid;
      await docMsg.set(newMsg.toJson());
      int count = await countUnseen(newMsg.sender_id, chat_id);
      String cid = await ChatStuff().getCid(chat_id);
      if (newMsg.sender_id == cid) {
        await ChatStuff().updateUnSeen(chat_id, count, "RUnread_msg");
      }else{
        await ChatStuff().updateUnSeen(chat_id, count, "CUnread_msg");
      }
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<Stream<List<Message>>> displayMessages(String chat_id) async {
    try {
      final docMsg = await FirebaseFirestore.instance.collection("Chats").doc(chat_id).collection("Messages").orderBy("Ts", descending: true).get();
      final msgData = docMsg.docs.map((e) => Message.fromSnapshot(e)).toList();
      // Create a Stream from the list of messages
      final messageStream = Stream.value(msgData);
      return messageStream;
    } catch (e) {
      showToast(message: e.toString());
      return Stream.empty(); // Return an empty stream in case of an error
    }
  }

  Stream<QuerySnapshot> getMessages(String chat_id, String receiver_id) {
    try {
      markAllAsSeen(receiver_id, chat_id);
      return FirebaseFirestore.instance.collection("Chats").doc(chat_id).collection("Messages").orderBy("Ts", descending: true).snapshots();
    } catch (e) {
      showToast(message: e.toString());
      return Stream.empty(); // Return an empty stream in case of an error
    }
  }

  //set all docs where reciever id is current id to isSeen to true
  Future<void> markAllAsSeen(String id, String did) async {
    try {
      final docMsg = await FirebaseFirestore.instance.collection("Chats").doc(did).collection("Messages").where("Receiver_id", isEqualTo: id).get();
      for (var doc in docMsg.docs) {
        await doc.reference.update({'IsSeen': true});
        String cid = await ChatStuff().getCid(did);
        if (id == cid) {
          await ChatStuff().updateUnSeen(did, 0, "CUnread_msg");
        }else{
          await ChatStuff().updateUnSeen(did, 0, "RUnread_msg");
        }
      }
    } catch(e) { 
      showToast(message: e.toString());
    }
  }


  //count number of docs where isSeen is false and the receiver id is the current user
  Future<int> countUnseen(String id, String did) async {
    try {
      final docMsg = await FirebaseFirestore.instance.collection("Chats").doc(did).collection("Messages").where("Sender_id", isEqualTo: id).where("IsSeen", isEqualTo: false).get();
      
      return docMsg.docs.length;
    } catch(e) { 
      showToast(message: e.toString());
      return 0;
    }
  }

  //check if last message by timestamp is seen
  

  //count number of docs inside the messages collection inside the where isSeen is false and the receiver id is the current user
  
  
  
}
