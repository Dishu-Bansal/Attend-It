import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:attend_it/screens/admin_attendance.dart';
import 'package:attend_it/screens/admin_leaves.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

class admin_home extends StatefulWidget {
  Users admin;
  admin_home({Key? key, required Users this.admin}) : super(key: key);

  @override
  _admin_homeState createState() => _admin_homeState(admin);
}


int selectedindex=0;

bool _amplifyConfigured = Amplify.isConfigured;

class _admin_homeState extends State<admin_home> {
  Users admin;
  _admin_homeState(Users this.admin);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!_amplifyConfigured)
    {
      _configureAmplify();
    }
    else {

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

  _onTapped(int index){
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _amplifyConfigured ? MaterialApp(
      home: Scaffold(
        body: selectedindex ==0 ? admin_attendance(me: admin) : admin_leaves(me: admin),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedindex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.wc), label: 'Team'),
            BottomNavigationBarItem(icon: Icon(Icons.sick), label: 'Leaves')
          ],
          onTap: _onTapped,
        ),
      ),
    ) : Flexible(child: CircularProgressIndicator());;
  }
}
