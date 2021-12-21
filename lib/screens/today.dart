import 'dart:async';
import 'dart:core';
import 'dart:ui';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:attend_it/models/Attendance.dart';
import 'package:attend_it/screens/face_match.dart';
import 'package:attend_it/screens/location_screen.dart';
import 'package:attend_it/screens/logs.dart';
import 'package:attend_it/screens/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:attend_it/models/ModelProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../amplifyconfiguration.dart';
import '../draggable_sheet.dart';

DateTime _now = DateTime.now();

final key1 = GlobalKey();
List<Attending> attendance_list = List.empty(growable: true);
String _date = DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
Attending Today = new Attending();

class today extends StatefulWidget {
  String username = "";
  today({Key? key, required String this.username}) : super(key: key);

  @override
  _todayState createState() => _todayState(username);
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
bool _amplifyConfigured = Amplify.isConfigured;
class _todayState extends State<today> {

  String username = "";
  _todayState(String this.username);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(!_amplifyConfigured)
      {
        _configureAmplify();
      }
    // _getUser();
    _getTodayAttendance();
    _getAllAttendance();
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

  // _getUser(){
  //   Future<AuthUser> user = Amplify.Auth.getCurrentUser();
  //   user.then((value) {
  //     username = value.userId;
  //   });
  // }
  
  _getTodayAttendance()
  {
    try{
      Future<List<Attending>> attendances = Amplify.DataStore.query(Attending.classType, where: Attending.DATE.eq(_date).and(Attending.USERID.eq(username)));
      attendances.then((value) => {
        setState(()
        {
          if(value != null && value.isNotEmpty) {
            Today = value.elementAt(0);
          }
          else
            {
              print("No Attendance for today");
            }
        })
      });
    }
    on DataStoreException catch (e)
    {
      print("Query Failed: " + e.toString());
      _ShowToast("Error Retrieving Attendance");
    }
  }
  
  _getAllAttendance()
  {
    try{
      Future<List<Attending>> attendances = Amplify.DataStore.query(Attending.classType, where: Attending.USERID.eq(username));
      attendances.then((value) => {
        setState(()
        {
          if(value != null && value.isNotEmpty) {
            attendance_list = value;
          }
          else
            {
              _ShowToast("No Attendance for Today");
            }
        })
      });
    }
    on DataStoreException catch (e)
    {
      print("Query Failed: " + e.toString());
      _ShowToast("Error Retrieveing Attendances");
    }
  }

  @override
  Widget build(BuildContext context) {

    print("Username is " + username);
    return MaterialApp(
      home: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Fizzy Group.jpg"),
                    fit: BoxFit.fill
                )
            ),
          ),
         Scaffold(
           resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Today\'s Attendance', style: TextStyle(color: Colors.black, fontStyle: FontStyle.normal, decorationStyle: TextDecorationStyle.solid),),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            elevation: 0,
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
          body: DraggableBottomSheet(
            backgroundWidget: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50,width: MediaQuery.of(context).size.width,),
                  MyClock(),
                  SizedBox(height: 5, width: MediaQuery.of(context).size.width,),
                  Text(DateFormat("LLLL d, EEEE").format(DateTime.now()), style: TextStyle(fontSize: 16),),
                  SizedBox(height: 20, width: MediaQuery.of(context).size.width,),
                  ElevatedButton(
                      onPressed: () async {
                            bool location = await Navigator.push(context, MaterialPageRoute(builder: (context) => location_screen()));
                            if(location)
                            {
                              bool face = await Navigator.push(context, MaterialPageRoute(builder: (context) => FaceMatch()));
                              if(face)
                              {
                                if(Today.Clockin == null)
                                  {
                                    Attending clockin = Attending(
                                        UserID: username,
                                        Clockin: DateTime.now().millisecondsSinceEpoch.toString(),
                                        Date: DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal()),
                                        WorkingHours: "0.0"
                                    );
                                    await Amplify.DataStore.start();
                                    await Amplify.DataStore.save(clockin);
                                    setState((){Today = clockin;});
                                  }
                                else
                                  {
                                    double min = (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(int.parse(Today.Clockin!))).inMinutes)/60;
                                    Attending clockout = Today.copyWith(Clockout: DateTime.now().millisecondsSinceEpoch.toString(), WorkingHours: (min.toStringAsFixed(2)).toString());

                                    await Amplify.DataStore.save(clockout);
                                    setState((){Today = clockout; attendance_list.add(Today);});
                                  }
                              }
                              else
                              {
                                _ShowToast("Error Matching face");
                              }
                            }
                            else
                            {
                              _ShowToast("Error Getting Location");
                            }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: new CircleBorder(),
                          primary: Colors.blue
                      ),
                      child: Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.yellow, Colors.blue.shade700], )),
                        child: Icon(Icons.add,
                          size: 50,),
                      )
                  ),
                ],
              ),
            previewChild: Preview_child(key: key1,),
            expandedChild: const Expanded_child(),
            minExtent: 100,
            expansionExtent: 315,
            maxExtent: 420,
          ),
        ),
       ]
      ),
    );
  }
  getAttendanceDetail(DateTime date)
  {
    for(Attending attend in attendance_list)
    {
      if(attend.Date.toString() == DateFormat("y-MM-dd").format(date))
      {
        return attend;
      }
    }
    return null;
  }
}

class Expanded_child extends StatelessWidget {
  const Expanded_child({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Icon(Icons.keyboard_arrow_down, size: 50, color: Colors.black12,),
        // SizedBox(height: 8,),
        Container(
          child: SfCalendar(
            headerStyle: CalendarHeaderStyle(textAlign: TextAlign.center),
            showNavigationArrow: true,
            view: CalendarView.month,
            monthCellBuilder: (BuildContext context, MonthCellDetails details) {

              Attending? detail = getAttendanceDetail(details.date);

              if(detail != null) {
                return Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Icon((detail.Clockin != null && detail.Clockout !=null) ? Icons.done_all : Icons.done, color: Colors.lightGreen,),
                      Text(details.date.day.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  // decoration: (detail.ClockIn != null) &&
                  //     (detail.ClockOut != null) ? BoxDecoration(
                  //     // color: Colors.green,
                  // ) : BoxDecoration(
                  //     color: Colors.redAccent),
                  width: 2.0,
                  padding: EdgeInsets.all(2.0),
                  margin: EdgeInsets.all(2.0),
                );
              }
              else
              {
                return Container(
                  child: Text(details.date.day.toString(),
                    textAlign: TextAlign.center,
                  ),
                  width: 2.0,
                  padding: EdgeInsets.all(2.0),
                  margin: EdgeInsets.all(2.0),
                );
              }
            },
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => logs(attendance_list: attendance_list,)));
            },
            child: Text('Show All'))
      ],
    );
  }

  Attending? getAttendanceDetail(DateTime date) {
    for(Attending attend in attendance_list)
    {
      if(attend.Date.toString() == DateFormat("y-MM-dd").format(date))
      {
        return attend;
      }
    }
    return null;
  }
}

class Preview_child extends StatelessWidget {
  const Preview_child({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width/3,
          child: Column(
            children: [
              Icon(Icons.access_time_filled),
              Text((Today.Clockin == null) ? "--:--" : DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(Today.Clockin!)).toLocal())),
              Text("Clock In")
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width/3,
          child: Column(
            children: [
              Icon(Icons.access_time_filled),
              Text((Today.Clockout == null) ? "--:--" : DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(Today.Clockout!)).toLocal())),
              Text("Clock Out")
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width/3,
          child: Column(
            children: [
              Icon(Icons.access_time_filled),
              Text((Today.WorkingHours == null) ? "--:--" : Today.WorkingHours!),
              Text("Work Time")
            ],
          ),
        )
      ],
    );
    //     ],
    //   ),
    // );
  }
}


class MyClock extends StatefulWidget {
  const MyClock({Key? key}) : super(key: key);

  @override
  _MyClockState createState() => _MyClockState();
}

class _MyClockState extends State<MyClock> {

  late Timer timer;
  _startClock() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startClock();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(timer.isActive)
      {
        timer.cancel();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Text(DateFormat("HH:mm:ss").format(_now), style: TextStyle(fontSize: 30),);
  }
}
