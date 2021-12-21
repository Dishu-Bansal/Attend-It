
import 'package:attend_it/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// Amplify Flutter Packages

import '../home.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {
              try{
                Amplify.DataStore.clear();
                Navigator.pop(context);
              }
              on Exception catch(e)
              {
                print(e.toString());
              }

            },
            minWidth: MediaQuery.of(context).size.width,
            child: Text("Clear Data"),
            color: Colors.blue,
            padding: EdgeInsets.all(10.0),
          ),
          MaterialButton(
            onPressed: () {
              try{
                Amplify.Auth.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
              }
              on AuthException catch(e)
              {
                print(e.message);
              }

            },
            minWidth: MediaQuery.of(context).size.width,
            child: Text("Sign Out"),
            color: Colors.blue,
            padding: EdgeInsets.all(10.0),
          ),
        ],
      ),
    );
  }
}
