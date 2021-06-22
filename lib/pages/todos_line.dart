import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/widgets/todo_line.dart';

// ignore: must_be_immutable
class ToDosLine extends StatelessWidget {
  Stream<List<ToDo>> todos;
  ToDosLine({required this.todos});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ToDo>>(
        stream: todos,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(),
              width: 100,
              height: 100,
            ));
          if (snapshot.hasError)
            return Center(
              child: Text('Error'),
            );
          List<ToDo> list = snapshot.data ?? [];
          return ListView.builder(
            itemBuilder: (context, index) => ToDoLine(todo: list[index]),
            itemCount: list.length,
          );
        });
  }
}
