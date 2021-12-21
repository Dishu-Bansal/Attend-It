import 'dart:io';
import 'dart:ui';

import 'package:attend_it/main.dart';
import 'package:attend_it/models/AccessLevel.dart';
import 'package:attend_it/models/Companies.dart';
import 'package:attend_it/models/Users.dart';
import 'package:attend_it/screens/photo.dart';
import 'package:attend_it/screens/verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../auto_complete_text_view.dart';


String image="";
bool verification_code = false, got_companies=false;
String username="", password="", phonenumber="", name="", email="", code="", company_name="";
bool isSignUpComplete = false, profile_pic_uploaded = false;
AccessLevel position = AccessLevel.EMPLOYEE;
List<Companies> companies = List.empty(growable: true);

class Register extends StatefulWidget {

  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
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

class _RegisterState extends State<Register> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanies();
  }

  getCompanies() async {
    companies  = await Amplify.DataStore.query(Companies.classType);
    setState(() {
      got_companies = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return got_companies ? Scaffold(
      appBar: AppBar(
        title: Text("Welcome to G.D. College", style: TextStyle(fontSize: 30.0),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0))),
        centerTitle: true,
        toolbarHeight: 100.0,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: (image.isNotEmpty) ? Center(
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.file(File(image)),
                    ),
                  ) : Center(
                    child: Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Center(child: IconButton(
                        onPressed: () async {
                          List<String> result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Photo()));
                          if(result.isNotEmpty)
                            {
                              setState(() {
                                image = result.first;
                              });
                            }
                          else
                            {
                              _ShowToast("Unable to get Image");
                            }
                          },
                        icon: Center(child: Icon(Icons.add)),
                        iconSize: 70.0,
                      )
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      name = value.trim();
                    },
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
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
                    onChanged: (value) {
                      phonenumber = value.trim();
                    },
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      email = value.trim();
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("You are ?", style: TextStyle(fontSize: 20),)),
                ),
                Access(),
              ],
            ),
          ),

          Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
                },
                minWidth: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Sign In", style: TextStyle(fontSize: 15.0, color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                ),
              )
          ),
          register_button(),
        ],
      ),
    ) : Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}


class Select_Company extends StatelessWidget {
  const Select_Company({Key? key}) : super(key: key);

  static String _displayStringForOption(Companies option) => option.Name ?? "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: auto_complete_text_view<Companies>(
        displayStringForOption: _displayStringForOption,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<Companies>.empty();
          }
          return companies.where((Companies option) {
            return option.toString().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (Companies selection) {
          company_name = selection.Name!;
        },
      ),
    );
  }
}

class Access extends StatefulWidget {
  const Access({Key? key}) : super(key: key);

  @override
  _AccessState createState() => _AccessState();
}

class _AccessState extends State<Access> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text("Employee"),
            leading: Radio(
              value: AccessLevel.EMPLOYEE,
              onChanged: (AccessLevel? val){
                setState((){
                  position = val!;
                });
              },
              groupValue: position,
            ),
          ),
          ListTile(
            title: Text("Admin"),
            leading: Radio(
              value: AccessLevel.ADMIN,
              onChanged: (AccessLevel? val){
                setState((){
                  position = val!;
                });
              },
              groupValue: position,
            ),
          ),
          position == AccessLevel.EMPLOYEE ? Select_Company() :
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              onChanged: (value) {
                company_name = value.trim();
              },
              decoration: InputDecoration(
                hintText: "Company Name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class register_button extends StatefulWidget {
  const register_button({Key? key}) : super(key: key);

  @override
  _register_buttonState createState() => _register_buttonState();
}

class _register_buttonState extends State<register_button> {

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () async {
            if(image.isNotEmpty)
            {
              if(name.isNotEmpty && username.isNotEmpty && phonenumber.isNotEmpty && email.isNotEmpty && password.isNotEmpty && company_name.isNotEmpty)
              {
                try{
                  Map<String, String> userAttributes =  {
                    "name" : name,
                    "preferred_username" : username,
                    "email" : email,
                    "phone_number" : "+91" + phonenumber,
                    "picture": username
                  };

                  setState(() {
                    loading = true;
                  });
                  SignUpResult res = await Amplify.Auth.signUp(username: username, password: password, options: CognitoSignUpOptions(userAttributes: userAttributes));
                  await Amplify.DataStore.save(new Users(Name: name, PhoneNumber: phonenumber, Username: username, Email: email, Company: company_name, Access: position));
                  if(position == AccessLevel.ADMIN)
                    {
                      await Amplify.DataStore.save(new Companies(Name: company_name));
                    }
                  // UploadFileResult result_file = await Amplify.Storage.uploadFile(local: File(image), key: username);
                  if(res.isSignUpComplete)
                    {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => verification(username: username, password: password, image: image)));
                    }
                  else
                    {
                      _ShowToast("Error Registering");
                      setState(() {
                        loading=false;
                      });
                    }
                }
                on AuthException catch (e) {
                  print(e.message);
                  _ShowToast("Authentication Error: " + e.recoverySuggestion!);
                  setState(() {
                    loading = false;
                  });
                }
                on Exception catch (e){
                  print(e.toString());
                  _ShowToast("Unknown Error Occured : " + e.toString());
                  setState(() {
                    loading = false;
                  });
                }
              }
              else
              {
                _ShowToast("Please fill all the fields");
                setState(() {
                  loading=false;
                });
              }
            }
            else
            {
              _ShowToast("Missing Photo");
              setState(() {
                loading=false;
              });
            }
          },
          color: Colors.amberAccent,
          minWidth: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: loading ? CircularProgressIndicator() : Text("Register", style: TextStyle(fontSize: 25.0),),
          ),
        )
    );
  }
}

