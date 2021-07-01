import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:swipe_to/swipe_to.dart';

class SwipeToDo extends StatelessWidget {
  final Widget child;
  final ToDo todo;
  const SwipeToDo({Key? key, required this.child, required this.todo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();

    return SwipeTo(
      child: child,
      onLeftSwipe: () {
         showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Attention!'),
                    content: Text('Do you want to move todo to recycle bin?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            todo.inTrash = true;
                            // ignore: deprecated_member_use
                       /*     Scaffold.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red[700],
                                duration: Duration(seconds: 2),
                                content: Text('Todo moved to recycle bin'),
                              ),
                            ); */
                            firestoreService.saveToDo(todo);
                            Navigator.of(context).pop();
                          },
                          child: Text('Yes')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'))
                    ],
                  );
                });
      },
      iconOnLeftSwipe: Icons.delete,
      iconColor: Colors.red,
    );
  }
}
