import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:attend_it/models/AccessLevel.dart';
import 'package:attend_it/models/Users.dart';
import 'package:attend_it/screens/settings.dart';
import 'package:attend_it/screens/team_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class admin_attendance extends StatefulWidget {
  Users me;
  admin_attendance({Key? key, required Users this.me}) : super(key: key);

  @override
  _admin_attendanceState createState() => _admin_attendanceState(me);
}
List<Users> users = new List.empty(growable: true);
bool done = false;
class _admin_attendanceState extends State<admin_attendance> {
  Users me;
  _admin_attendanceState(Users this.me);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchSession().then((value){
      print("Session: " + value!.isSignedIn.toString());
      setState(() {
        done = true;
      });
    });
    _getUsers().then((value) {
      if(value != null)
      {
        setState(() {
          users = value;
        });
      }
    });
  }

  Future<AuthSession?> _fetchSession() async {
    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      return res;
    } on AuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<List<Users>?> _getUsers() async {
    try {
      List<Users> u = await Amplify.DataStore.query(Users.classType, where: Users.USERID.gt(0).and(Users.COMPANY.eq(me.Company)).and(Users.ACCESS.eq(AccessLevel.EMPLOYEE)));
      print("Users: " + u.toString());
      return u;
    } catch (e) {
      print("Could not query DataStore: " + e.toString());
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Team"),
        centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              color: Colors.black,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              },
            )
          ],
      ),
      body: done ? ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index){
            return team_tile(user: users.elementAt(index),);
          }): Center(child: CircularProgressIndicator(),),
    );
  }
}
