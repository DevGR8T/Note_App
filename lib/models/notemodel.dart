import 'package:cloud_firestore/cloud_firestore.dart';

class Notemodel {
  String id;
  String title;
  String description;
  Timestamp date;
  String userid;

  Notemodel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.userid,
  });

  factory Notemodel.fromJson(DocumentSnapshot snapshot) {
    return Notemodel(
        id: snapshot.id,
        title: snapshot['title'],
        description: snapshot['description'],
        date: snapshot['date'],
        userid: snapshot['userid']);
  }
}
