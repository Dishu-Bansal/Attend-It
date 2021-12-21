import 'dart:ui';

import 'package:attend_it/screens/verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'admin_home.dart';
import 'screens/register.dart';
import 'models/ModelProvider.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// Amplify Flutter Packages
import 'package:amplify_datastore/amplify_datastore.dart';
import 'home.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
// Generated in previous step
import 'amplifyconfiguration.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MaterialApp(
    home:MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}


String username = "", password = "";
bool _amplifyConfigured = Amplify.isConfigured, loading=false, got_user= false;

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!_amplifyConfigured)
    {
      _configureAmplify();
    }
  }


  void _configureAmplify() async {

    // await Amplify.addPlugin(AmplifyAPI()); // UNCOMMENT this line after backend is deployed
    await Amplify.addPlugin(AmplifyDataStore(modelProvider: ModelProvider.instance));
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.addPlugin(AmplifyAPI());
    await Amplify.addPlugin(AmplifyStorageS3());

    // Once Plugins are added, configure Amplify
    await Amplify.configure(amplifyconfig);
    try {
      setState(() {
        _amplifyConfigured = true;
        print("Successful Plugin Integration");
      });
    } catch (e) {
      print(e);
    }
  }

  _getCurrentUser ()
  async {
    AuthSession user = await Amplify.Auth.fetchAuthSession(options: CognitoSessionOptions(getAWSCredentials: false));
    if(user.isSignedIn)
      {
        AuthUser u = await Amplify.Auth.getCurrentUser();
        String userid = u.userId;
        List<Users> l = await Amplify.DataStore.query(Users.classType, where: Users.USERID.eq(userid));
        if(l != null && l.isNotEmpty)
          {
            Users us = l.first;
            if(us.Access == AccessLevel.ADMIN)
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => admin_home(admin: us,)));
              }
            else
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home(user: us,)));
              }
          }
        else
          {
            _ShowToast("Error Retrieving User");
            setState(() {
              got_user = true;
            });
          }
      }
    else
      {
        setState(() {
          got_user = true;
        });
      }
    // user.then((value) {
    //   if(value.isSignedIn)
    //   {
    //     Future<AuthUser> user = Amplify.Auth.getCurrentUser();
    //     user.then((value) {
    //       username = value.userId;
    //       Future<List<Users>> l = Amplify.DataStore.query(Users.classType, where: Users.USERID.eq(username));
    //       l.then((value) {
    //         if(value != null)
    //           {
    //             Users u = value.first;
    //             if(u.Access == AccessLevel.ADMIN)
    //               {
    //                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => admin_home(admin: u,)));
    //               }
    //             else
    //               {
    //                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home()));
    //               }
    //           }
    //         else
    //           {
    //             _ShowToast("Error Retrieving User");
    //           }
    //       });
    //     });
    //   }
    //   else
    //   {
    //     setState(() {
    //       got_user = true;
    //     });
    //   }
    // }, onError: (value) {
    //   setState(() {
    //     got_user = true;
    //   });
    // });
  }

  List<String> s = ['Today', 'Leaves', 'Profile'];
  @override
  Widget build(BuildContext context) {
    // print("I am here");
    if(_amplifyConfigured && !got_user)
    {
      _getCurrentUser();
    }

    return _amplifyConfigured && got_user ? Scaffold(
    // return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to G.D. College", style: TextStyle(fontSize: 30.0),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0))),
        centerTitle: true,
        toolbarHeight: 100.0,
      ),
      body: Column(
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      username = value.trim();
                    },
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      password = value.trim();
                    },
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Register()));
                },
                minWidth: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Register Here", style: TextStyle(fontSize: 15.0, color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                ),
              )
          ),
          button(),
        ],
      ),
    ) : Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}

class button extends StatefulWidget {
  const button({Key? key}) : super(key: key);

  @override
  _buttonState createState() => _buttonState();
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

class _buttonState extends State<button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () async {
            setState(() {
              loading = true;
            });
            try {
              SignInResult res = await Amplify.Auth.signIn(username: username, password: password);
              if(res.isSignedIn)
              {
                List<Users> l = await Amplify.DataStore.query(Users.classType, where: Users.USERNAME.eq(username));
                Users user = l.first;
                if(user.Access == AccessLevel.ADMIN)
                  {
                    loading = false;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => admin_home(admin: user,)));
                  }
                else
                  {
                    loading=false;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home(user: user)));
                  }
              }
              else
              {
                _ShowToast("Unable to Sign In");
                setState(() {
                  loading = false;
                });
              }
            }
            on Exception catch (e)
            {
              _ShowToast("Unable to Sign In");
              setState(() {
                loading = false;
              });
            }

          },
          color: Colors.amberAccent,
          minWidth: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: loading? CircularProgressIndicator() : Text("Sign In", style: TextStyle(fontSize: 25.0),),
          ),
        )
    );
  }
}

