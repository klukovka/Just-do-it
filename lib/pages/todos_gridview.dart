import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:just_do_it/widgets/custom_progress_bar.dart';
import 'package:just_do_it/widgets/slidable_todo.dart';
import 'package:just_do_it/widgets/swipe_todo.dart';
import 'package:just_do_it/widgets/todo_line.dart';

// ignore: must_be_immutable
class ToDosGridView extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  Stream<List<ToDo>> todos;
  final bool inTrash;
  final bool? done;
  ToDosGridView({required this.todos, required this.inTrash, this.done});

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
          list.sort(
              (todo1, todo2) => todo2.dateCreate!.compareTo(todo1.dateCreate!));

          list = list.where((element) {
            if (done != null)
              return element.done == done && element.inTrash == inTrash;
            else
              return element.inTrash == inTrash;
          }).toList();

          List<Widget> widgets = [];
          for (int i = 0; i < list.length; i++) {
            if (list[i].inTrash == true) {
              widgets.add(SlidableToDo(
                todo: list[i],
                child: ToDoLine(todo: list[i]),
              ));
            } else {
              widgets.add(SwipeToDo(
                todo: list[i],
                child: ToDoLine(todo: list[i]),
              ));
            }
          }
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: widgets,
          );
        });
  }
}
