

// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:tutorial2/global/toast.dart';

import '../models/userModel.dart';
class UserStuff {
  Future<bool> createUserDetails(UserM newUser) async {

    try {
      final docUser = FirebaseFirestore.instance.collection("Users").doc(newUser.id);
      await docUser.set(newUser.toJson());
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<UserM> getPersonalData(String id) async {

    try {
      final docUser = FirebaseFirestore.instance.collection("Users").doc(id);
      //get data
      final snapshot = await docUser.get();
      return UserM.fromSnapshot(snapshot);
    } catch(e) { 
      showToast(message: e.toString());
    }
    //return an empty user
    return UserM("", "", "", "", "", "", "", "", "", 0, 0, 0, "", "",0);
  }

  Future<bool> updatePersonalData(UserM updatedUser) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("Users").doc(updatedUser.id);
      //get data
      final snapshot = await docUser.update(updatedUser.toJson());
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<String> getType(String id) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("Users").doc(id);
      //get the Type in the data
      final snapShot = await docUser.get();
      return snapShot.get("Type");
    } catch(e) { 
      showToast(message: e.toString());
      return "null";
    }
  }

  Future<int> getViews(String id) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("Users").doc(id);
      //get the Type in the data
      final snapShot = await docUser.get();
      return snapShot.get("Views");
    } catch(e) { 
      showToast(message: e.toString());
      return 0;
    }
  }

  //get first name and last name
  Future<String> getName(String id) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("Users").doc(id);
      //get the Type in the data
      final snapShot = await docUser.get();
      return snapShot.get("FirstName") + " " + snapShot.get("LastName");
    } catch(e) { 
      showToast(message: e.toString());
      return "";
    }
  }


  Future<bool> viewProfile(String id) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("Users").doc(id);
      await docUser.update({"Views": FieldValue.increment(1)});
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<List<UserM>> displayUsers() async {
    try {
      final docUser = await FirebaseFirestore.instance.collection("Users").where("Type", isEqualTo: "Candidate").get();
      final userData = docUser.docs.map((e) => UserM.fromSnapshot(e)).toList();
      return userData;
    } catch(e) { 
      showToast(message: e.toString());
      return [];
    }
  }

  Future<UserM> displayUser(String uid) async {
    try {
      final docUser = await FirebaseFirestore.instance.collection("Users").doc(uid);
      final snapshot = await docUser.get();
      return UserM.fromSnapshot(snapshot);
    } catch(e) { 
      showToast(message: e.toString());
      return UserM("", "", "", "", "", "", "", "", "", 0, 0, 0, "", "",0);
    }
  }


}


