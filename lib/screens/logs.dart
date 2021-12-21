import 'dart:ui';

import 'package:attend_it/models/Attendance.dart';
import 'package:attend_it/models/Attending.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';

String username = "";
int month=DateTime.now().month;
List<String> weekdays = ["None", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
class logs extends StatefulWidget {
  List<Attending> attendance_list;

  logs({Key? key, required List<Attending> this.attendance_list}) : super(key: key);

  @override
  _logsState createState() => _logsState(attendance_list);
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

class _logsState extends State<logs> {

  List<Attending> attendance_list;

  _logsState(this.attendance_list);
  List<Attending> filtered_list = List.empty(growable: true);

  _filterAttendance()
  {
    filtered_list.clear();
    for(Attending attend in attendance_list)
      {
        int attendMonth = int.parse(attend.Date!.substring(5,7));
        if(attendMonth == month)
          {
            filtered_list.add(attend);
          }
      }
  }

  @override
  Widget build(BuildContext context) {

    _filterAttendance();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(3, 169, 244, 1.0),
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {Navigator.pop(context);},
          ),
          title: const Text("Attendance"),
          backgroundColor: const Color.fromRGBO(3, 169, 244, 1.0),
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            SfCalendar(
              viewHeaderStyle: const ViewHeaderStyle(dayTextStyle: TextStyle(color: Colors.white)),
              headerStyle: const CalendarHeaderStyle(textAlign: TextAlign.center, backgroundColor: Color.fromRGBO(3, 169, 244, 1.0), textStyle: TextStyle(color: Colors.white, fontSize: 20)),
              view: CalendarView.month,
              todayHighlightColor: Colors.white,
              todayTextStyle: const TextStyle(color: Color.fromRGBO(3, 169, 244, 1.0)),
              showNavigationArrow: true,
              backgroundColor: const Color.fromRGBO(3, 169, 244, 1.0),
              monthViewSettings: const MonthViewSettings(showTrailingAndLeadingDates: false,monthCellStyle: MonthCellStyle(textStyle: TextStyle(color: Colors.white, fontSize: 18))),
              onViewChanged: (ViewChangedDetails details) {
                if(month != details.visibleDates.first.month)
                  {
                    setState(() {
                      month = details.visibleDates.first.month;
                    });
                  }
              },
              monthCellBuilder: (BuildContext context, MonthCellDetails details) {
              try{
                Attending? detail = _getAttendanceDetail(details.date);
                if(detail != null) {
                  return Container(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Icon((detail.Clockin != null && detail.Clockout !=null) ? Icons.done_all : Icons.done, color: Colors.lightGreen,),
                        Text(details.date.day.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    decoration: (detail.Clockin != null) && (detail.Clockout != null) ? const BoxDecoration(color: Colors.green,) : const BoxDecoration(color: Colors.redAccent),
                    width: 2.0,
                    padding: const EdgeInsets.all(2.0),
                    margin: const EdgeInsets.all(2.0),
                  );
                }
                else
                  {
                    return Container(
                      child: Text(details.date.day.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      width: 2.0,
                      padding: const EdgeInsets.all(2.0),
                      margin: const EdgeInsets.all(2.0),
                    );
                  }
    }
    on Exception catch(e)
    {
      _ShowToast(e.toString());
      return Container(
        child: Text(details.date.day.toString(),
          textAlign: TextAlign.center,
        ),
        width: 2.0,
        padding: const EdgeInsets.all(2.0),
        margin: const EdgeInsets.all(2.0),
      );
    }

                },
            ),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                  color: Colors.white
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     const Padding(
                       padding: EdgeInsets.all(10.0),
                       child: Text("Logs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Expanded(
                             child: Container(
                               child: const Text("Date"),
                               alignment: Alignment.center,
                             ),
                           ),
                           Expanded(
                             child: Container(
                               child: const Text("Clock In"),
                               alignment: Alignment.topCenter,
                             ),
                           ),
                           Expanded(
                             child: Container(
                               child: const Text("Clock Out"),
                               alignment: Alignment.center,
                             ),
                           ),
                           Expanded(
                             child: Container(
                               child: const Text("Work time"),
                               alignment: Alignment.center,
                             ),
                           )
                         ],
                       ),
                     ),
                     Expanded(
                       child: (filtered_list.isNotEmpty) ? ListView.builder(
                         itemCount: filtered_list.length,
                         itemBuilder: (context, index) {
                           Attending attendance = filtered_list.elementAt(filtered_list.length -1 -index);
                           return log_tile(date: attendance.Date!, month: attendance.Date!, clockin: (attendance.Clockin == null) ? "--:--" : DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(attendance.Clockin!)).toLocal()), clockout: (attendance.Clockout == null) ? "--:--" : DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(attendance.Clockout!)).toLocal()), workinghours: attendance.WorkingHours.toString(), );
                       }) : const Center(child: Text("No Data for this month"),),
                     )
                   ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Attending? _getAttendanceDetail(DateTime date)
  {
    for(Attending attend in filtered_list)
    {
      if(attend.Date.toString() == DateFormat("y-MM-dd").format(date))
      {
        return attend;
      }
    }
    return null;
  }
}


class log_tile extends StatelessWidget {
  String date="", month="", clockin="", clockout="", workinghours="";
  log_tile({Key? key, required String this.date, required String this.month, required String this.clockin, required String this.clockout, required String this.workinghours}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid)
        ),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(DateTime.parse(date).day.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text(weekdays[DateTime.parse(date).weekday], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),)
                  ]
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(clockin, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
            ),
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(clockout, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                )
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(workinghours, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
