import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';

class ToDoLine extends StatelessWidget {
  ToDo todo;

  ToDoLine({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: todo.todoColor.withOpacity(0.8),
        elevation: 5,
            child: ListTile(
          title: Text('${todo.title}'),
          subtitle: Text('${todo.description}'),
         
        ),
      ),
    );
  }
}
