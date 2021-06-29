import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/pages/edit_add_todo.dart';
import 'package:just_do_it/providers/todo_provider.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ToDoLine extends StatelessWidget {
  ToDo todo;

  ToDoLine({required this.todo});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();
    final todoPrvider = Provider.of<ToDoProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
          color: todo.todoColor.withOpacity(0.8),
          elevation: 5,
          child: ListTile(
      title: Text('${todo.title}'),
      subtitle: Text('${todo.description}'),
      trailing: todo.done == false
          ? Icon(Icons.check_box_outline_blank)
          : Icon(Icons.check_box),
      onTap: () {
        todoPrvider.loadValues(todo);
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => EditAddToDo(
                    todo: todo,
                  )),
        );
      },
      onLongPress: () {
        if (todo.done == false)
          todo.done = true;
        else
          todo.done = false;
        firestore.saveToDo(todo);
      },
          ),
        ),
    );
  }
}
