
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorial2/models/jobModel.dart';

import '../global/toast.dart';

class JobStuff{

  Future<bool> createJob(Job newJob) async {
    try {
      final docJob = FirebaseFirestore.instance.collection("Jobs").doc();
      String jid = docJob.id;
      newJob.id = jid;
      await docJob.set(newJob.toJson());
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<bool> updateJob(Job newJob, String id) async {
    try {
      final docJob = FirebaseFirestore.instance.collection("Jobs").doc(newJob.id);
      await docJob.update(newJob.toJson());
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<Job> displayJob(String jid) async {
    try {
      final docJob = await FirebaseFirestore.instance.collection("Jobs").doc(jid);
      final snapshot = await docJob.get();
      return Job.fromSnapshot(snapshot);
    } catch(e) { 
      showToast(message: e.toString());
      return Job("","", "","", "", 0, 0, 0, 0,0, "", "", "", "", 0, 0, "", "","");
    }
  }

  Future<bool> deleteJob(String uid, String jid) async {
    try {
      final docJob = await FirebaseFirestore.instance.collection("Jobs").doc(jid);
      await docJob.delete();
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<List<Job>> displayJobs(String id) async {
    try {
      final docJob = await FirebaseFirestore.instance.collection("Jobs").where("Recruiter_id", isEqualTo: id).get();
      final jobData = docJob.docs.map((e) => Job.fromSnapshot(e)).toList();
      return jobData;
    } catch(e) { 
      showToast(message: e.toString());
      return [];
    }
  }

  Future<List<Job>> displayAllJobs() async {
    try {
      final docJob = await FirebaseFirestore.instance.collection("Jobs").get();
      final jobData = docJob.docs.map((e) => Job.fromSnapshot(e)).toList();
      return jobData;
    } catch(e) { 
      showToast(message: e.toString());
      return [];
    }
  }

  Future<int> countJobs(String rid) async {
    try {
      final docJob = await FirebaseFirestore.instance.collection("Jobs").where("Recruiter_id", isEqualTo: rid).get();
      return docJob.docs.length;
    } catch(e) { 
      showToast(message: e.toString());
      return 0;
    }
  }

  
  
}