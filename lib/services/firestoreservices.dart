import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future addnote(String title, String description, String userid) async {
    try {
      await firestore.collection('notes').add({
        'title': title,
        'description': description,
        'date': DateTime.now(),
        'userid': userid,
      });
    } catch (e) {
      print(e);
    }
  }

  Future updatenote(String title, String description, String docid) async {
    try {
      await firestore
          .collection('notes')
          .doc(docid)
          .update({'title': title, 'description': description});
    } catch (e) {
      print(e);
    }
  }

  Future deletenote(String docid) async {
    try {
      await firestore.collection('notes').doc(docid).delete();
    } catch (e) {
      print(e);
    }
    ;
  }
}
