import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_usingfirebase/DialogBox/errorDialog.dart';
import 'package:todo_app_usingfirebase/DialogBox/loading_dialogbox.dart';
import 'package:todo_app_usingfirebase/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app_usingfirebase/variables.dart';
import 'package:uuid/uuid.dart';

class DetailsPage extends StatefulWidget {




  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  

  TextEditingController titleEditingController=TextEditingController();
  TextEditingController descriptionEditingController=TextEditingController();
  TextEditingController dateEditingController=TextEditingController();

  DateTime _date=DateTime.now();
  DateFormat dateFormatter=DateFormat("MMM dd,yyyy");


  final jobId=Uuid().v4();

  void showDateDialog()async{

    _date=await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2100),
    );
    if(_date!=null){
      setState(() {
          dateEditingController.text=dateFormatter.format(_date);
      });
    }
  }

  

  FirebaseAuth auth=FirebaseAuth.instance;

  addDataToFirebase()async{

    showDialog(context: context,
        builder: (context){
              return LoadingDialogBox();
        }
    );

    Map<String,dynamic>noteData={
      
      "name":userName,
      "title":titleEditingController.text,
      "uid":auth.currentUser.uid,
      "jobId":jobId,
      "currentDate":DateTime.now().toString(),
      "description":descriptionEditingController.text,
      "requiredDate":dateEditingController.text
    };

    FirebaseFirestore.instance.collection("Notes").doc(jobId).set(noteData).then((results) {

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      Fluttertoast.showToast(msg: "Data Added Successfully. . . ",timeInSecForIosWeb: 2);

    }).catchError((error){

      showDialog(context: context,
          builder: (context){

              return ErrorDialog(message: "Failed..   "+error,);
          });
    });
  }

  getUserData(){
     FirebaseFirestore.instance.collection("GoogleUsers").doc(auth.currentUser.uid).get()
        .then((results) {

      setState(() {
        userName=results.data()["username"];
        imageUrl=results.data()["photo"];
      });
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                  child: TextField(
                    controller: titleEditingController,
                    style: TextStyle(
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      labelText: "Title",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                        ),

                    ),
                  ),


                ),
                SizedBox(height: 10,),


                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextField(
                       maxLines: 5,
                      controller: descriptionEditingController,
                      style: TextStyle(
                          color: Colors.black
                      ),
                      decoration: InputDecoration(
                        labelText: "Description",
                       border: OutlineInputBorder(
                         borderSide: BorderSide(color: Colors.blue)
                       )


                  ),


                ),),
                SizedBox(height: 20,),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onTap: showDateDialog,
                    readOnly: true,
                    controller: dateEditingController,
                    style: TextStyle(
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                        labelText: "Date",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                        )


                    ),


                  ),),

                SizedBox(height: 20,),

                RaisedButton(
                  color: Colors.blue,
                    onPressed: (){
                      addDataToFirebase();
                    },
                  child: Text("Add Note",style: TextStyle(color: Colors.white),),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
