import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:just_do_it/widgets/custom_progress_bar.dart';
import 'package:just_do_it/widgets/slidable_todo.dart';
import 'package:just_do_it/widgets/todo_line.dart';

// ignore: must_be_immutable
class ToDosLine extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  Stream<List<ToDo>> todos;
  ToDosLine({required this.todos});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ToDo>>(
        stream: todos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CustomProgressBar();
          if (snapshot.hasError)
            return Center(
              child: Text('Error'),
            );
          List<ToDo> list = snapshot.data ?? [];
          return ListView.separated(
            itemBuilder: (context, index) => SlidableToDo(
              todo: list[index],
              child: ToDoLine(todo: list[index]),
            ),
            itemCount: list.length,
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 15,
            ),
          );
        });
  }
}
