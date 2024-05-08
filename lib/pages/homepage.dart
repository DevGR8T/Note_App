import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/notemodel.dart';
import 'package:note_app/pages/addnote.dart';
import 'package:note_app/pages/updatenote.dart';
import 'package:note_app/pages/loginpage.dart';
import 'package:note_app/services/authservices.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.member, super.key});
  final User member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          'NOTES',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
              onPressed: () async {
                await Authservices().signout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (route) => false);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('userid', isEqualTo: member.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  Notemodel note =
                      Notemodel.fromJson(snapshot.data.docs[index]);
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(),
                    color: Colors.brown,
                    child: ListTile(
                      title: Text(
                        note.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      subtitle: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        note.description,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateNote(
                                appuser: member,
                                note: note,
                              ),
                            ));
                      },
                    ),
                  );
                },
              );
            }
            return Center(
                child: Text(
              'No Notes Available',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNotePage(
                  appuser: member,
                ),
              ));
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: Colors.yellow[700],
      ),
    );
  }
}
