import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app_usingfirebase/authentication.dart';
import 'package:todo_app_usingfirebase/details_page.dart';
import 'package:todo_app_usingfirebase/home_page.dart';
import 'package:todo_app_usingfirebase/register_page.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser!=null?HomePage():RegisterPage()

    );
  }
}

