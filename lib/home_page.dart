import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app_usingfirebase/DialogBox/errorDialog.dart';
import 'package:todo_app_usingfirebase/authentication.dart';
import 'package:todo_app_usingfirebase/details_page.dart';
import 'package:todo_app_usingfirebase/register_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  Timestamp currentDate;
  String postedDate;
 // String uid=FirebaseAuth.instance.currentUser.uid;

  QuerySnapshot notes;
/*
  getCurrentTimeDetails()async{

    FirebaseFirestore.instance.collection("Notes").doc(widget.jobId).get().then((value) {

      setState(() {
        currentDate=value.data()["currentDate"];

        var postDate=currentDate.toDate();
        postedDate="${postDate.year}-${postDate.month}-${postDate.day}";

      });
    });
  }

 */


  FirebaseAuth auth=FirebaseAuth.instance;


  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getCurrentTimeDetails();
  // }

   deleteNote(documentId) async{

     showDialog(context: context,
         builder: (context){
            return AlertDialog(
              title: Text("Do you want to delete this Note?",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: ()async{
                      await FirebaseFirestore.instance.collection("Notes").doc(documentId).delete().then((value) {

                        Fluttertoast.showToast(msg: "Deleted Successfully. . . ",timeInSecForIosWeb: 2);
                        Navigator.pop(context);

                      }).catchError((error){
                        return showDialog(context: context,
                            builder: (context){
                                return ErrorDialog(message: "Failed...   "+error.toString(),);
                            }
                        );
                      });
                    },
                    child: Text("Yes")
                ),

                ElevatedButton(
                    onPressed: (){
                          Navigator.pop(context);
                    },
                    child: Text("No")
                ),
              ],
            );
         }
     );

  }

   editNote(documentId, oldTitle, oldDescription) {

     showDialog(context: context,
         builder: (context){

          return AlertDialog(
              title: Text("Edit Note: ",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
              ),),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextFormField(
                  initialValue: oldTitle,
                  style: TextStyle(
                    color: Colors.black
                  ),
                  onChanged: (value){
                    setState(() {
                        oldTitle=value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Title",

                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  maxLines: 3,
                  initialValue: oldDescription,
                  style: TextStyle(
                      color: Colors.black
                  ),
                  onChanged: (value){
                    setState(() {
                      oldDescription=value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Description",

                  ),
                ),
              ],

            ),
            actions: [
              ElevatedButton(
                  onPressed: (){

                      Map<String,dynamic>map={
                        "title":oldTitle,
                        "description":oldDescription
                      };

                      FirebaseFirestore.instance.collection("Notes").doc(documentId).update(map).then((value) {

                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Updated Successfully. . .",timeInSecForIosWeb: 2);

                      }).catchError((error){
                        Fluttertoast.showToast(msg: "Failed.....    "+error.toString(),timeInSecForIosWeb: 2);
                      });
                  },
                  child: Text("Update")
              ),

              ElevatedButton(
                  onPressed: (){
                      Navigator.pop(context);
                  },
                  child: Text("Cancel")
              ),
            ],
            );
         }
     );

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      automaticallyImplyLeading: false,
        title: Text("Home Page"),
        
        actions: [
          IconButton(
              onPressed: (){
                signOut().then((value) {
                  Navigator.push( context,MaterialPageRoute(builder: (context)=>RegisterPage()));
                });
               // print("Here is the problem "+widget.uid);
              },
              icon: Icon(Icons.logout,color: Colors.white,),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push( context,MaterialPageRoute(builder: (context)=>DetailsPage()));
        },
        child: Icon(Icons.add,color: Colors.deepPurple,),
      ),


      
      body: Container(
        // child:showNotesList(),
        child:

        StreamBuilder(

            stream:FirebaseFirestore.instance.collection("Notes").where("uid",isEqualTo: auth.currentUser.uid).snapshots(),

            builder: (context,snapshot){
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }
              else if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              else if(snapshot.connectionState==ConnectionState.active){
                return ListView.builder(

                   shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder:(context,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple,width: 1),
                            ),
                            width: MediaQuery.of(context).size.width/2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title:Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data.docs[index]["name"],
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),),
                                  ) ,
                                  subtitle:Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(snapshot.data.docs[index]["description"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  )  ,

                                 trailing: Row(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     IconButton(
                                         onPressed: (){
                                              //Edit Code

                                           editNote(
                                             snapshot.data.docs[index]["jobId"],
                                             snapshot.data.docs[index]["title"],
                                             snapshot.data.docs[index]["description"],
                                           );
                                         },
                                         icon: Icon(Icons.edit,color: Colors.deepPurple,)
                                     ),
                                     SizedBox(width: 10,),

                                     IconButton(
                                         onPressed: (){
                                              // Delete Code
                                           deleteNote(snapshot.data.docs[index]["jobId"]);
                                         },
                                         icon: Icon(Icons.delete,color: Colors.deepPurple,)
                                     ),
                                   ],
                                 ),
                                ),

                                // Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //
                                //     Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Text("Upload Date:- "),
                                //     ),
                                //
                                //     Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Text(postedDate==null?"":postedDate),
                                //     )
                                //   ],
                                //
                                // ),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Deadline Date:- "),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snapshot.data.docs[index]["requiredDate"]),
                                    )
                                  ],

                                )


                              ],


                            ),

                          ),
                        );
                    }
                );
              }
            }
        ),
      ),

    );




   }
 /* showNotesList() {

     if(notes!=null){
        return ListView.builder(
          itemCount: notes.docs.length,
            padding: EdgeInsets.all(8.0),
            itemBuilder:(context,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(notes.docs[index].get("title")),
              ),
            );
            }
        );
     }
     else{
       return Center(child: CircularProgressIndicator(),);
     }

  */
 }







