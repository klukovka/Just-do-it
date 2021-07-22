import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/pages/edit_add_todo.dart';
import 'package:just_do_it/providers/todo_provider.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ToDoLine extends StatelessWidget {
  final ToDo todo;
  final GlobalKey<ScaffoldState> scaffoldKey;
  ToDoLine({required this.todo, required this.scaffoldKey});

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
              SwipeablePageRoute(
                  builder: (context) => EditAddToDo(
                        todo: todo,
                        scaffoldKey: scaffoldKey,
                      )),
            );
          },
          onLongPress: () {
            if (todo.done == false)
              todo.done = true;
            else
              todo.done = false;
            // ignore: deprecated_member_use
            scaffoldKey.currentState!.showSnackBar(
              SnackBar(
                backgroundColor:
                    todo.done == true ? Colors.green : Colors.blueAccent[700],
                duration: Duration(seconds: 2),
                content: Text(
                    todo.done == true ? 'Todo is done' : 'Todo is not done'),
              ),
            );
            firestore.saveToDo(todo);
          },
        ),
      ),
    );
  }
}
