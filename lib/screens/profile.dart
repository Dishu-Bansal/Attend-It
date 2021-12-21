import 'dart:io';
import 'dart:ui';

import 'package:attend_it/models/ModelProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amplify_flutter/amplify.dart';
// Amplify Flutter Packages
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
// import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed

String profile_image = "";
DateTime selected_month = DateTime(DateTime.now().year, DateTime.now().month, 1);
bool got_attendance = false, got_leaves=false;
String username="", name = "";
List<String> month = ["None", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<ChartData> datas = List.empty(growable: true);
  List<ChartData> leaves = List.empty(growable: true);
  List<ColumnData> work = List.empty(growable: true);
  List<Attendance> attendance_list = List.empty(growable: true);
  List<Leaves> leaves_list = List.empty(growable: true);

  Future<File> _downloadProfileImage() async
  {
    AuthUser user = await Amplify.Auth.getCurrentUser();
    username = user.userId;
    name = user.username;
    _getAllAttendance();
    _getAllLeaves();
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + "/profile.jpg";
    final file = File(filepath);
    await Amplify.Storage.downloadFile(key: user.username, local: file);
    return file;
  }

  _getAllAttendance() async {
    // try{
    //   Future<List<Attendance>> attendances = Amplify.DataStore.query(Attendance.classType, where: Attendance.USERID.eq(username));
    //   attendances.then((value) => {
    //     setState(()
    //     {
    //       if(value != null && value.isNotEmpty) {
    //         attendance_list = value;
    //       }
    //       got_attendance = true;
    //     })
    //   });
    // }
    // on DataStoreException catch (e)
    // {
    //   print("Query Failed: " + e.toString());
    // }

    try{
      List<Attendance> attendances = await Amplify.DataStore.query(Attendance.classType, where: Attendance.USERID.eq(username));
      if(attendances!= null && attendances.isNotEmpty)
        {
          attendance_list = attendances;
        }
      got_attendance = true;
    }
    on DataStoreException catch(e)
    {
      print("Query Failed: " + e.message);
    }
  }

  _getAllLeaves() async {
    // try{
    //   print("Profile Username: " + username);
    //   Future<List<Leaves>> leaves = Amplify.DataStore.query(Leaves.classType, where: Leaves.USERID.eq(username));
    //   leaves.then((value) => {
    //     setState(()
    //     {
    //       if(value != null && value.isNotEmpty) {
    //         leaves_list = value;
    //       }
    //       got_leaves = true;
    //     })
    //   });
    // }
    // on DataStoreException catch (e)
    // {
    //   print("Query Failed: " + e.toString());
    // }

    try{
      List<Leaves> value = await Amplify.DataStore.query(Leaves.classType, where: Leaves.USERID.eq(username));
      if(value!= null && value.isNotEmpty)
      {
        leaves_list = value;
      }
      got_leaves = true;
    }
    on DataStoreException catch(e)
    {
      print("Query Failed: " + e.message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    Future<File> profile = _downloadProfileImage();
    profile.then((value) {
      setState(() {
        profile_image = value.path;
      });
    });
  }

  _setAttendanceData(){

    datas.clear();
    leaves.clear();

    int present = 0;
    int absent = 0;
    int holiday = 0;
    int leaves_num=0;
    int casual = 0;
    int emergency = 0;
    int sick=0;
    int paid=0;
    bool found = false;
    DateTime current_date = selected_month;
    while(current_date.month == selected_month.month)
      {
        found = false;
        String current = DateFormat('yyyy-MM-dd').format(current_date);
        for(Attendance attend in attendance_list)
          {
            if(attend.Date == current)
              {
                present++;
                found = true;
                break;
              }
          }
        if(found)
          {
            current_date = current_date.add(Duration(days: 1));
            continue;
          }
        for(Leaves leave in leaves_list)
          {
            DateTime from = DateTime.parse(leave.From!);
            DateTime to = DateTime.parse(leave.To!);
            if(current_date == from || current_date == to)
              {
                leaves_num++;
                if (leave.Type == LeaveType.CASUAL) {
                  casual++;
                }
                else if (leave.Type == LeaveType.EMERGENCY) {
                  emergency++;
                }
                else if (leave.Type == LeaveType.SICK) {
                  sick++;
                }
                else
                {
                  paid++;
                }
                found = true;
                break;
              }
            else
              {
                if(current_date.isAfter(from) && current_date.isBefore(to))
                  {
                    leaves_num++;
                    if (leave.Type == LeaveType.CASUAL) {
                      casual++;
                    }
                    else if (leave.Type == LeaveType.EMERGENCY) {
                      emergency++;
                    }
                    else if (leave.Type == LeaveType.SICK) {
                      sick++;
                    }
                    else
                    {
                      paid++;
                    }
                    found = true;
                    break;
                  }
              }
          }
        if(found){
          current_date = current_date.add(Duration(days: 1));
          continue;
        }
        else
          {
            if(current_date.weekday != 7)
              {
                absent++;
              }
            else
              {
                holiday++;
              }
          }

        current_date = current_date.add(Duration(days: 1));
      }

    datas.add(new ChartData("Present", present, Colors.lightGreenAccent));
    datas.add(new ChartData("Absent", absent, Colors.red));
    datas.add(new ChartData("Leaves", leaves_num, Colors.yellow));
    datas.add(new ChartData("Holidays", holiday, Colors.grey));

    print("Present: " + present.toString() + ", Absent: " + absent.toString() + ", Leaves:" + leaves_num.toString());
    print(attendance_list.toString());

    leaves.add(new ChartData("Casual", casual, Colors.green));
    leaves.add(new ChartData("Sick", sick, Colors.yellowAccent));
    leaves.add(new ChartData("Paid", paid, Colors.redAccent));
    leaves.add(new ChartData("Emergency", emergency, Colors.grey));
  }


  _setWorkingHoursData(){
    work.clear();
    for(Attendance attend in attendance_list)
      {
        if(selected_month.toString().contains(attend.Date!.substring(0,7)))
          {
            work.add(new ColumnData(DateTime.parse(attend.Date!), attend.WorkingHours == null || attend.WorkingHours!.isEmpty ? 0.0 : double.parse(attend.WorkingHours!)));
          }
      }
  }

  @override
  Widget build(BuildContext context) {

    if(got_attendance && got_leaves)
      {
        _setAttendanceData();
        _setWorkingHoursData();

        return Scaffold(
          appBar: AppBar(
            title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          backgroundColor: Colors.amberAccent,
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(new File(profile_image), fit: BoxFit.fill,),
              ),
              // SizedBox(height: 20,),
              Text(name, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              // ElevatedButton(onPressed: () {}, child: Padding(
              //   padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
              //   child: Text("Edit", style: TextStyle(fontSize: 20.0),),
              // ),
              // ),
              SizedBox(height: 20.0,),
              Flexible(
                fit: FlexFit.tight,
                child: Container(

                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: ListView(
                    children: [
                      Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Report", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      )),
                      MaterialButton(
                        onPressed: () {
                          showMonthPicker(
                            context: context,
                            initialDate: selected_month,
                          ).then((value) {
                            if(value != null)
                            {
                              setState(() {
                                selected_month = value;
                              });
                            }

                          });
                        },
                        child: Text(month[selected_month.month] + " " + selected_month.year.toString()),
                      ),
                      Card(
                        elevation: 15.0,
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SfCircularChart(
                              title: ChartTitle(text: "Attendance", textStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                              legend: Legend(
                                  isVisible: true,
                                  textStyle: TextStyle(fontSize: 20.0)
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<ChartData, String> (
                                    dataSource: datas,
                                    pointColorMapper: (ChartData data, _) => data.color,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    radius: '70%',
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        labelPosition: ChartDataLabelPosition.outside
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        elevation: 15.0,
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SfCartesianChart(
                              title: ChartTitle(text: "Working Hours", textStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                              legend: Legend(
                                  isVisible: true,
                                  textStyle: TextStyle(fontSize: 20.0)
                              ),
                              primaryXAxis: DateTimeAxis(),
                              series: <ChartSeries>[
                                ColumnSeries<ColumnData, DateTime> (
                                    dataSource: work,
                                    xValueMapper: (ColumnData data, _) => data.x,
                                    yValueMapper: (ColumnData data, _) => data.y,
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        labelPosition: ChartDataLabelPosition.outside
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        elevation: 15.0,
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SfCircularChart(
                              title: ChartTitle(text: "Leaves", textStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                              legend: Legend(
                                  isVisible: true,
                                  textStyle: TextStyle(fontSize: 20.0)
                              ),
                              series: <CircularSeries>[
                                PieSeries<ChartData, String> (
                                    dataSource: leaves,
                                    pointColorMapper: (ChartData data, _) => data.color,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    radius: '70%',
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        labelPosition: ChartDataLabelPosition.inside
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    else
      {
        return Scaffold(
          appBar: AppBar(
            title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          backgroundColor: Colors.amberAccent,
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    image: DecorationImage(
                        image: FileImage(new File(profile_image)),
                        fit: BoxFit.fill
                    )
                ),
                // clipBehavior: Clip.antiAlias,
              ),
              // SizedBox(height: 20,),
              Text("Imaginary Name", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () {}, child: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                child: Text("Edit", style: TextStyle(fontSize: 20.0),),
              ),
              ),
              SizedBox(height: 20.0,),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: ListView(
                    children: [
                      Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Report", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      )),
                      MaterialButton(
                        onPressed: () {
                          showMonthPicker(
                            context: context,
                            initialDate: selected_month,
                          ).then((value) {
                            if(value != null)
                            {
                              setState(() {
                                selected_month = value;
                              });
                            }

                          });
                        },
                        child: Text(month[selected_month.month] + " " + selected_month.year.toString()),
                      ),
                      Container(child: Center(child: CircularProgressIndicator())),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }

  }
}


class ChartData {
  final String x;
  final int y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}

class ColumnData{
  ColumnData(this.x, this.y);

  DateTime x;
  double y;
}