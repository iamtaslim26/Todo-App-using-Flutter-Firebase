import 'package:flutter/material.dart';
import 'package:todo_app_usingfirebase/register_page.dart';


class ErrorDialog extends StatelessWidget {

  final String message;

  const ErrorDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      key: key,
      actions: [

        ElevatedButton(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage())),
            child: Center(child: Text("Ok")),
        )
      ],

    );
  }
}
