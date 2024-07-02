
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorial2/global/toast.dart';
import 'package:tutorial2/models/bookmarkModel.dart';

class BookmarkStuff {
  Future<bool> checkBookmark(String cid, String jid) async {
    try {
      final docApp = await FirebaseFirestore.instance.collection("Bookmarks").where("Candidate_id", isEqualTo: cid).where("Job_id", isEqualTo: jid).get();
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

  Future<bool> bookmarkJob(BookMark newB) async {
    try {
      final docB = FirebaseFirestore.instance.collection("Bookmarks").doc();
      String bid = docB.id;
      newB.id = bid;
      await docB.set(newB.toJson());
      return true;
    } catch(e) { 
      showToast(message: e.toString());
      return false;
    }
  }

  Future<bool> removeBookmark(String cid, String jid) async {
    try {
      final docB = await FirebaseFirestore.instance.collection("Bookmarks").where("Candidate_id", isEqualTo: cid).where("Job_id", isEqualTo: jid).get();
      if (docB.docs.isEmpty) {
        return false;
      } else {
        await docB.docs[0].reference.delete();
        return true;
      }
    } catch(e) {
      showToast(message: e.toString());
      return false;
    }
  }

  Future<bool> removeBo(String id) async {
    try {
      final docB = await FirebaseFirestore.instance.collection("Bookmarks").doc(id);
      await docB.delete();
      return true;
    } catch(e) {
      showToast(message: e.toString());
      return false;
    }
  }

  Future<List<BookMark>> displayBookmarks(String cid) async {
    try {
      final docB = await FirebaseFirestore.instance.collection("Bookmarks").where("Candidate_id", isEqualTo: cid).get();
      final appB = docB.docs.map((e) => BookMark.fromSnapshot(e)).toList();
      return appB;
    } catch(e) { 
      showToast(message: e.toString());
      return [];
    }
  }
  
}