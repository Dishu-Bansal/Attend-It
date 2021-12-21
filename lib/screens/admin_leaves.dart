import 'package:attend_it/models/Users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class admin_leaves extends StatefulWidget {
  Users me;
  admin_leaves({Key? key, required Users this.me}) : super(key: key);

  @override
  _admin_leavesState createState() => _admin_leavesState(me);
}

class _admin_leavesState extends State<admin_leaves> {
  Users me;
  _admin_leavesState(Users this.me);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
