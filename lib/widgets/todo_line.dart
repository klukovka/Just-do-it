import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';

class ToDoLine extends StatelessWidget {
  ToDo todo;

  ToDoLine({required this.todo});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
