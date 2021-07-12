import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:just_do_it/widgets/custom_progress_bar.dart';
import 'package:just_do_it/widgets/empty_list.dart';
import 'package:just_do_it/widgets/slidable_todo.dart';
import 'package:just_do_it/widgets/todo_line.dart';

// ignore: must_be_immutable
class ToDosLine extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  final Stream<List<ToDo>> todos;
  final bool inTrash;
  final bool? done;

  ToDosLine({required this.todos, required this.inTrash, this.done});

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

          if (list.length == 0) return EmptyList();

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
