import 'package:flutter/material.dart';


class EditAddToDo extends StatefulWidget {
  EditAddToDo({Key? key}) : super(key: key);

  @override
  _EditAddToDoState createState() => _EditAddToDoState();
}

class _EditAddToDoState extends State<EditAddToDo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit'),),
      body: Center(child: Column(children: [],),),
    );
  }
}