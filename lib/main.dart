import 'package:flutter/material.dart';
import 'package:note_app/pages/homepage.dart';
import 'package:note_app/pages/loginpage.dart';
import 'package:note_app/pages/registerpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/services/authservices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyAHrwIVYsmC7Xxw_NaDUdHaxOWbAHtPDSQ',
          appId: '1:323490809321:android:8874940aed76e12cb4f778',
          messagingSenderId: '323490809321',
          projectId: 'noteapp-b5305'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme:
            InputDecorationTheme(fillColor: Colors.white, filled: true),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: Authservices().firebaseAuth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return HomePage(
              member: snapshot.data,
            );
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
