import 'dart:ui';

import 'package:attend_it/models/Leaves.dart';
import 'package:attend_it/screens/leave_application.dart';
import 'package:attend_it/screens/leave_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

String username = "";
bool loading = true;
List<Leaves> leaves_list = List.empty(growable: true);

class leaves extends StatefulWidget {
  String username="";
  leaves({Key? key, required String this.username}) : super(key: key);

  @override
  _leavesState createState() => _leavesState(username);
}

class _leavesState extends State<leaves> {

  String username="";

  List<Leaves> leaves_list = List.empty(growable: true);

  _leavesState(String this.username);

  _getAllLeaves(){
    try{
      Future<List<Leaves>> leaves = Amplify.DataStore.query(Leaves.classType, where: Leaves.USERID.eq(username));
      leaves.then((value) => {
        setState(()
        {
          if(value != null && value.isNotEmpty) {
            leaves_list = value;
          }
          loading = false;
        })
      });
    }
    on DataStoreException catch (e)
    {
      print("Query Failed: " + e.toString());
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return !loading ? MaterialApp(
      home: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Fizzy Group leaves.jpg"),
                fit: BoxFit.fill
              )
            ),
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.white,
              title: Text("Leaves", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings), color: Colors.black,)],
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            body: ListView.builder(
              itemCount: leaves_list.length,
              itemBuilder: (context, index){
                Leaves leave = leaves_list.elementAt(index);
                return leave_tile(leave: leave);
              },
            ),
            floatingActionButton: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => leave_application(username: username,)));
            }, child: Text("Apply for leave"),),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          )
        ],
      ),
    ) : Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
