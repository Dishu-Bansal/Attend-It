
import 'package:attend_it/models/ModelProvider.dart';
import 'package:attend_it/screens/leaves.dart';
import 'package:attend_it/screens/profile.dart';
import 'package:attend_it/screens/today.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'admin_home.dart';
import 'amplifyconfiguration.dart';
import 'models/AccessLevel.dart';
import 'models/AccessLevel.dart';
import 'models/ModelProvider.dart';
import 'package:amplify_flutter/amplify.dart';
// Amplify Flutter Packages
import 'package:amplify_datastore/amplify_datastore.dart';
// import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed

// Generated in previous step
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';


bool _amplifyConfigured = Amplify.isConfigured;
bool getting_user = true;
Users user = new Users();
int selectedindex = 0;
bool bottomsheet = true;
String username="";

class home extends StatefulWidget {
  Users user;
  home({Key? key, required Users this.user}) : super(key: key);
  @override
  _homeState createState() => _homeState(user);
}



class _homeState extends State<home> {
  Users user;
  _homeState(Users this.user);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!_amplifyConfigured)
      {
        _configureAmplify();
      }
    // else
    //   {
    //     _getUser();
    //   }
  }

  void _configureAmplify() async {

    // await Amplify.addPlugin(AmplifyAPI()); // UNCOMMENT this line after backend is deployed
    await Amplify.addPlugin(AmplifyDataStore(modelProvider: ModelProvider.instance));

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

  void _onTapped(int index) {
    setState((){
      selectedindex = index;
    });
  }

  // _getUser() async {
  //   AuthUser u = await Amplify.Auth.getCurrentUser();
  //   username = u.userId;
  //   List<Users> l = await Amplify.DataStore.query(Users.classType, where: Users.USERID.eq(username));
  //   user = l.first;
  //   if(user.Access == AccessLevel.ADMIN)
  //     {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => admin_home(admin: user,)));
  //     }
  // }

  Widget _getScreen(){
    if(selectedindex == 0)
    {
      return today(username: user.UserID!);
    }
    else if(selectedindex == 1)
    {
      return leaves(username: user.UserID!);
    }
    else
    {
      return Profile();
    }
  }

  List<String> s = ['Today', 'Leaves', 'Profile'];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _getScreen(),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: 'Today'),
            BottomNavigationBarItem(icon: Icon(Icons.sick), label: 'Leaves'),
            BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded), label: 'Profile')
          ],
          currentIndex: selectedindex,
          onTap: _onTapped,
        ),
      ),
    );
  }
}
