import 'dart:io';
import 'dart:ui';

import 'package:attend_it/models/Users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../home.dart';

bool sent = false;
String code = "";
class verification extends StatefulWidget {
  String username, password, image;
  verification({Key? key, required String this.username, required String this.password, required String this.image}) : super(key: key);

  @override
  _verificationState createState() => _verificationState(username, password, image);
}
_ShowToast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
class _verificationState extends State<verification> {
  String username, password, image;

  _verificationState(String this.username, String this.password, String this.image);


  @override
  Widget build(BuildContext context) {

    // if(!sent)
    //   {
    //     Future<ResendSignUpCodeResult> res = Amplify.Auth.resendSignUpCode(username: username);
    //     res.then((value) {
    //         sent = true;
    //     });
    //   }

    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to G.D. College", style: TextStyle(fontSize: 30.0),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0))),
          centerTitle: true,
          toolbarHeight: 100.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Please check your email for a verification code.", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
            ),
            Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      code = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Verification Code",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    Amplify.Auth.resendSignUpCode(username: username);
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Resend", style: TextStyle(fontSize: 15.0, color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                  ),
                )
            ),
            button(username: username, password: password, image: image)
          ],
        ),
    );
  }
}

class button extends StatefulWidget {
  String username,password, image;
  button({Key? key, required String this.username, required String this.password, required String this.image}) : super(key: key);

  @override
  _buttonState createState() => _buttonState(username, password, image);
}
bool loading = false;

class _buttonState extends State<button> {

  String username, password, image;
  _buttonState(String this.username, String this.password, String this.image);


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () {

              print("Code Entered is: " + code);

              Future<SignUpResult> res = Amplify.Auth.confirmSignUp(username: username, confirmationCode: code);
              setState(() {
                loading=true;
              });

              res.then((value) {
                if(value.isSignUpComplete)
                {
                  Future<SignInResult> res = Amplify.Auth.signIn(username: username, password: password);

                  res.then((value) async {
                    if(value.isSignedIn)
                    {
                      try
                      {
                        if(image!= null && image.isNotEmpty)
                          {
                            UploadFileResult result_file = await Amplify.Storage.uploadFile(local: File(image), key: username);
                          }
                      }
                      on Exception catch(e)
                    {
                      _ShowToast("Error Uploading Image. Please Contact the developer");
                    }
                      AuthUser user = await Amplify.Auth.getCurrentUser();
                      List<Users> us = await Amplify.DataStore.query(Users.classType, where: Users.USERNAME.eq(username));
                      Users u  = us.first.copyWith(UserID: user.userId);
                      if(us!= null && us.isNotEmpty)
                        {
                          await Amplify.DataStore.save(u);
                        }
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home(user: u,)));
                    }
                  });
                }
                else
                  {
                    _ShowToast("Unable to Verify");
                    setState(() {
                      loading = false;
                    });
                  }
              },onError: (value) {
                _ShowToast("Unable to Verify. Please check your code or contact the developer");
                setState(() {
                  loading=false;
                });
              });
          },
          color: Colors.amberAccent,
          minWidth: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: loading ? CircularProgressIndicator() : Text("Verify", style: TextStyle(fontSize: 25.0),),
          ),
        )
    );
  }
}

