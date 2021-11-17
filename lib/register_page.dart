import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app_usingfirebase/authentication.dart';
import 'package:todo_app_usingfirebase/home_page.dart';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final GlobalKey _formKey=new GlobalKey<FormState>();

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController userNameController=TextEditingController();

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      });


      return Future.value(true);

    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 110),
                       child: Container(
                        width: 60,
                        height: 60,
                        child: Image.asset("images/logo.png"),
                    ),
                     ),


                  Form(
                    key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: emailController,
                              validator: (val){
                                if(val.isEmpty){
                                  return "PLease fill";
                                }
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),

                                )
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: passwordController,
                              validator: (val){
                                if(val.isEmpty){
                                  return "PLease fill";
                                }
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),

                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: userNameController,
                              validator: (val){
                                if(val.isEmpty){
                                  return "PLease fill";
                                }
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: "UserName",
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),

                                  )
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width/2,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ElevatedButton(
                              onPressed: (){
                                signUp(emailController.text, passwordController.text, userNameController.text)
                                    .then((value) {

                                  FirebaseFirestore.instance.collection("GoogleUsers").doc(auth.currentUser.uid).set({

                                    "uid":auth.currentUser.uid,
                                    "email":emailController,
                                    "photo":"null",
                                    "username":userNameController
                                  });
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(

                                  )));
                                });

                              },
                              child: Text(
                                "Register",
                                style: TextStyle(color: Colors.white,fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),

                          Container(

                            height: 60,
                            width: MediaQuery.of(context).size.width/2,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.login,color: Colors.white,),
                                SizedBox(width: 10,),
                                InkWell(

                                  onTap: ()async{
                                    await gSignIn();
                                  },
                                  child: Text(
                                    "SignIn with Google",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),


                        ],
                      )
                  )

                ],
              ),
            ),
          ),
    );
  }
}
