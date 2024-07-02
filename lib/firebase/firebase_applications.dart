
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tutorial2/models/applicationModel.dart';

import '../global/toast.dart';

class AppStuff {

  Future<bool> applyToJob(Application newApp) async {
    try {
      final docApp = FirebaseFirestore.instance.collection("Applications").doc();
      String aid = docApp.id;
      newApp.id = aid;
      await docApp.set(newApp.toJson());
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  //check if document exist with the candidate id and job id
  Future<bool> checkApp(String cid, String jid) async {
    try {
      final docApp = await FirebaseFirestore.instance.collection("Applications").where("Candidate_id", isEqualTo: cid).where("Job_id", isEqualTo: jid).get();
      if (docApp.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  //return a list of apps where the candidate id and status
  Future<List<Application>> displayUserApps(String cid, String status) async {
    try {
      final docApp = await FirebaseFirestore.instance.collection("Applications").where("Candidate_id", isEqualTo: cid).where("Status", isEqualTo: status).get();
      final appData = docApp.docs.map((e) => Application.fromSnapshot(e)).toList();
      return appData;
    } catch(e) { 
      showToast(message: e.toString());
      return [];
    }
  }
  
  Future<int> countApps(String cid) async {
    try {
      final docApp = await FirebaseFirestore.instance.collection("Applications").where("Candidate_id", isEqualTo: cid).get();
      return docApp.docs.length;
    } catch(e) { 
      showToast(message: e.toString());
      return 0;
    }
  }

  Future<List<Application>> displayRecApps(String rid, String status) async {
    try {
      final docApp = await FirebaseFirestore.instance.collection("Applications").where("Recruiter_id", isEqualTo: rid).where("Status", isEqualTo: status).get();
      final appData = docApp.docs.map((e) => Application.fromSnapshot(e)).toList();
      return appData;
    } catch(e) { 
      showToast(message: e.toString());
      return [];
    }
  }

  Future<bool> removeApplication(String id) async {
    try {
      final docApp = await FirebaseFirestore.instance.collection("Applications").doc(id);
      await docApp.delete();
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  //update the status of application
  Future<bool> updateStatus(String id, String status) async {
    try {
      final docApp = await FirebaseFirestore.instance.collection("Applications").doc(id);
      await docApp.update({"Status": status});
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<int> countRApps(String rid) async {
    try {
      final docApp = await FirebaseFirestore.instance.collection("Applications").where("Recruiter_id", isEqualTo: rid).get();
      return docApp.docs.length;
    } catch(e) { 
      showToast(message: e.toString());
      return 0;
    }
  }

}