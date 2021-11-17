

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app_usingfirebase/home_page.dart';
import 'package:todo_app_usingfirebase/register_page.dart';

FirebaseAuth auth=FirebaseAuth.instance;
final GoogleSignIn googleSignIn=GoogleSignIn();

Future gSignIn()async{

  User currentUser;

  GoogleSignInAccount googleSignInAccount=await googleSignIn.signIn();

  if(googleSignInAccount!=null){

    GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;

    AuthCredential authCredential=GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );

    auth.signInWithCredential(authCredential).then((value) {

       currentUser=value.user;
       var uid=currentUser.uid;
       var email=currentUser.email;
       var photo=currentUser.photoURL;
       var name=currentUser.displayName;

       FirebaseFirestore.instance.collection("GoogleUsers").doc(uid).set({

         "uid":uid,
         "email":email,
         "photo":photo,
         "username":name
       });
    });


    return Future.value(true);

  }

}

void sendToHome(context) {

}

Future<bool>signUp(String email,String password,String userName){


  auth.createUserWithEmailAndPassword(email: email, password: password);

}

Future<bool>signOut()async {
  User currentUser=  auth.currentUser;

  if (currentUser.providerData[0].providerId == "google.com") {
    await googleSignIn.disconnect();
  }
  await auth.signOut();

  }
