
import 'dart:ui';

import 'package:attend_it/models/LeaveStatus.dart';
import 'package:attend_it/models/LeaveType.dart';
import 'package:attend_it/models/Leaves.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:fluttertoast/fluttertoast.dart';

String start="", end="", reason="";
LeaveType type = LeaveType.CASUAL;
TextEditingController _controller = new TextEditingController();

class leave_application extends StatefulWidget {

  String username="";
  leave_application({Key? key, required String this.username}) : super(key: key);

  @override
  _leave_applicationState createState() => _leave_applicationState(username);
}

class _leave_applicationState extends State<leave_application> {

  String username = "";

  _leave_applicationState(String this.username);

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    PickerDateRange range = args.value;
    start = range.startDate.toString().substring(0,10);
    if(range.endDate == null)
      {
        end = start;
      }
    else
      {
        end = range.endDate.toString().substring(0,10);
      }

    print("Start: " + start + ", End: " + end );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 169, 244, 1.0),
      appBar: AppBar(
        title: Text("Apply For Leave"),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(3, 169, 244, 1.0),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SfDateRangePicker(
            view: DateRangePickerView.month,
            enablePastDates: false,
            selectionMode: DateRangePickerSelectionMode.range,
            onSelectionChanged: _onSelectionChanged,
            monthCellStyle: DateRangePickerMonthCellStyle(todayTextStyle: TextStyle(color: Colors.white),textStyle: TextStyle(color: Colors.white, fontSize: 18)),
            rangeSelectionColor: Colors.white38,
            startRangeSelectionColor: Colors.white,
            endRangeSelectionColor: Colors.white,
            selectionTextStyle: TextStyle(color: Colors.blue),
            rangeTextStyle: TextStyle(color: Colors.white),
            todayHighlightColor: Colors.white,
            headerStyle: DateRangePickerHeaderStyle(textStyle: TextStyle(color: Colors.white, fontSize: 20.0)),
          ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))
                ),
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Text("Type:", style: TextStyle(fontSize: 18),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                      child: DropdownButtonFormField<LeaveType>(
                        items: [DropdownMenuItem(value: LeaveType.SICK,child: Text("Sick Leave")),
                          DropdownMenuItem(value: LeaveType.CASUAL,child: Text("Casual Leave")),
                          DropdownMenuItem(value: LeaveType.PAID,child: Text("Paid Leave")),
                          DropdownMenuItem(value: LeaveType.EMERGENCY,child: Text("Emergency Leave"))],
                        hint: Text("Select Type of leave"),
                        value: LeaveType.CASUAL,
                        onChanged: (value) {
                          if(value != null)
                            {
                              type = value;
                            }
                        },
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Text("Reason:", style: TextStyle(fontSize: 18),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                      child: TextFormField(
                        controller: _controller,
                        onChanged: (value) {
                          reason = value;
                        },
                        maxLines: 7,
                        decoration: InputDecoration(
                          hintText: "Enter Reason here...",
                          filled: true,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                    //   child: ElevatedButton(
                    //       onPressed: () async {
                    //         // if(!loading)
                    //         // {
                    //           Leaves leave = new Leaves(id: username, From: start, To: end, Type: type, Status: LeaveStatus.PENDING, LeaveReason: reason);
                    //
                    //           await Amplify.DataStore.save(leave);
                    //           Navigator.pop(context);
                    //         // }
                    //       },
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(15.0),
                    //         child: Text("Confirm", style: TextStyle(fontSize: 20)),
                    //       )
                    //   ),
                    // )
                    confirmButton(username: username),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class confirmButton extends StatefulWidget {

  String username="";
  confirmButton({Key? key, required String this.username}) : super(key: key);

  @override
  _confirmButtonState createState() => _confirmButtonState(username);
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
class _confirmButtonState extends State<confirmButton> {
  bool loading = false;
  String username="";

  _confirmButtonState(String this.username);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
      child: ElevatedButton(
          onPressed: () async {
                if(start != null && start.isNotEmpty)
                  {
                    Leaves leave = new Leaves(UserID: username, From: start, To: end, Type: type, Status: LeaveStatus.PENDING, LeaveReason: reason);
                    await Amplify.DataStore.save(leave);
                    Navigator.pop(context);
                  }
                else
                  {
                    _ShowToast("Please Select a Date");
                  }
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: loading ? CircularProgressIndicator(): Text("Confirm", style: TextStyle(fontSize: 20)),
          )
      ),
    );
  }
}

