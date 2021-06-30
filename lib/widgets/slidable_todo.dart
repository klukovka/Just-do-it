import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';

class SlidableToDo extends StatelessWidget {
  final Widget child;
  final ToDo todo;
  const SlidableToDo({Key? key, required this.child, required this.todo})
      : super(key: key);

  List<Widget> slidableActions(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();
    if (todo.inTrash == false)
      return [
        IconSlideAction(
          caption: 'To Recycle Bin',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            todo.inTrash = true;
            // ignore: deprecated_member_use
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red[700],
                duration: Duration(seconds: 2),
                content: Text('Todo moved to recycle bin'),
              ),
            );
            firestoreService.saveToDo(todo);
          },
        )
      ];
    return [
      IconSlideAction(
        caption: 'Restore',
        color: Colors.green,
        icon: Icons.restore,
        onTap: () {
          todo.inTrash = false;
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              content: Text('Todo was restored'),
            ),
          );
          firestoreService.saveToDo(todo);
        },
      ),
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent[700],
              duration: Duration(seconds: 2),
              content: Text('Todo was deleted'),
            ),
          );
          firestoreService.removeToDo('${todo.toDoId}');
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
        child: child,
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: slidableActions(context));
  }
}
