import 'dart:ui';

import 'package:attend_it/models/LeaveStatus.dart';
import 'package:attend_it/models/Leaves.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';

class leave_tile extends StatelessWidget {
  Leaves leave;
  leave_tile({Key? key, required Leaves this.leave}) : super(key: key);
  late LeaveStatus status;

  List<String> month = ["None", "Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"];

  @override
  Widget build(BuildContext context) {

    status = leave.Status!;
    DateTime from = DateTime.parse(leave.From!);
    DateTime To = DateTime.parse(leave.To!);

    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [BoxShadow(offset: Offset(0, 2), blurRadius: 5)]
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 10, top: 10),child: Text(month[from.month] + " " + from.day.toString() + " - " + month[To.month] + " " + To.day.toString(),overflow: TextOverflow.clip, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
              Expanded(child: SizedBox(height: 10,),),
              Padding(padding: EdgeInsets.only(right: 10, top: 10), child: Container(width: 100,height: 25, child: Text(leave.Status.toString().substring(12), style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(115, 103, 0, 1.0))), alignment: Alignment(0.0, 0.0),decoration: BoxDecoration(color: Color.fromRGBO(253, 200, 14, 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),), )
            ]
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(fit: FlexFit.tight,child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text("Type:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 0.6)),),
              )),
              Flexible(fit: FlexFit.tight,child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Reason:", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0, color: Color.fromRGBO(0, 0, 0, 0.6)),),
              ))
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(fit: FlexFit.tight,child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(leave.Type.toString().substring(10), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)),),
              )),
              Flexible(fit: FlexFit.tight,child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(leave.LeaveReason == null ? "" : leave.LeaveReason.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(0, 0, 0, 1)),),
              ))
            ],
          ),
          status == LeaveStatus.REJECTED ? Row(
            children: [Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text("Reason for Rejection", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 0.6)),),
            )]
          ) : SizedBox(width: 0, height: 0,),
          status == LeaveStatus.REJECTED ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text("Type your reason for rejection", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(0, 0, 0, 1.0)),),
              ),
            ],
          ) : SizedBox(height: 0, width: 0,),
          status == LeaveStatus.PENDING ? ElevatedButton(onPressed: () {
            Amplify.DataStore.delete(leave);
          },style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)), child: Text("Withdraw", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),)) : SizedBox(width: 0, height: 0,)
        ],
      ),
    );
  }
}
