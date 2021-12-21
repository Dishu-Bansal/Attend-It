import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'dart:ui';

import 'package:attend_it/models/Attendance.dart';
import 'package:attend_it/models/Attending.dart';
import 'package:attend_it/models/Users.dart';
import 'package:attend_it/screens/admin_profile.dart';
import 'package:attend_it/screens/profile.dart';
import 'package:attend_it/models/Attendance.dart';
import 'package:attend_it/models/Users.dart';
import 'package:attend_it/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:amplify_flutter/amplify.dart';

import 'admin_attendance.dart';

class team_tile extends StatefulWidget {
  Users user;
  team_tile({Key? key, required Users this.user}) : super(key: key);

  @override
  _team_tileState createState() => _team_tileState(user);
}

class _team_tileState extends State<team_tile> {
  String image = "";
  Attending attendance = new Attending();
  Users user;

  _team_tileState(Users this.user);

  Future<File> _getData () async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + "/" + user.Username! + ".jpg";
    final file = File(filepath);
    await Amplify.Storage.downloadFile(key: user.Username!, local: file);
    return file;
  }

  Future<Attending> _getAttendance () async {
    String date = DateFormat("yyyy-MM-dd").format(DateTime.now().toLocal());
    List<Attending> a = await Amplify.DataStore.query(Attending.classType, where: Attending.USERID.eq(user.UserID).and(Attending.DATE.eq(date)));
    return a.first;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData().then((value) {
      setState(() {
        image = value.path;
      });
    });
    _getAttendance().then((value) {
      setState(() {
        attendance = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    print("Image: " + image + ", Attendance: " + attendance.toString());
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => admin_profile(user: user, image: image)));
      },
      child: Card(
        shadowColor: Color.fromRGBO(0, 0, 0, 20),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
        margin: EdgeInsets.all(8.0),
        child:  image.isNotEmpty && attendance != null ? Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  image: DecorationImage(
                      image: Image.file(new File(image)).image,
                      fit: BoxFit.fill
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                // child: Image.file(new File(image)),
              ),
              Text(attendance.Clockin == null? "--:--" : DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(attendance.Clockin!)).toLocal()), style: TextStyle(fontSize: 20.0),),
              Text(attendance.Clockout == null? "--:--" : DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(attendance.Clockout!)).toLocal()), style: TextStyle(fontSize: 20.0),),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(attendance.WorkingHours == null ? "--" : attendance.WorkingHours.toString(), style: TextStyle(fontSize: 20.0),),
              )
            ],
          ),
        ) : Container(child: Center(child: CircularProgressIndicator(),),),
      ),
    );
  }
}

