import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:note_app/services/firestoreservices.dart';

class AddNotePage extends StatefulWidget {
  AddNotePage({required this.appuser, super.key});
  User appuser;

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController titlecontroller = TextEditingController();

  TextEditingController descriptioncontroller = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: titlecontroller,
                decoration: InputDecoration(border: InputBorder.none),
              ),
              SizedBox(height: 40),
              Text(
                'Description',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descriptioncontroller,
                minLines: 4,
                maxLines: 7,
                decoration: InputDecoration(border: InputBorder.none),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        backgroundColor: Colors.yellow[700]),
                    onPressed: () async {
                      final title = titlecontroller.text.trim();
                      final description = descriptioncontroller.text.trim();
                      setState(() {
                        loading = true;
                      });
                      if (title == '' || description == '') {
                        setState(() {
                          loading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            title.isEmpty
                                ? 'Please enter a title'
                                : 'please enter a description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.red,
                        ));
                        return null;
                      }
                      await FireStoreServices().addnote(titlecontroller.text,
                          descriptioncontroller.text, widget.appuser.uid);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Note added',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.green,
                      ));
                    },
                    child: loading
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : Text(
                            'Add Note',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
