import 'package:flutter/material.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:just_do_it/widgets/custom_alert_dialog.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:swipe_to/swipe_to.dart';

class SwipeToDo extends StatelessWidget {
  final Widget child;
  final ToDo todo;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SwipeToDo(
      {Key? key,
      required this.child,
      required this.todo,
      required this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();

    return SwipeTo(
      child: child,
      onLeftSwipe: () {
        showDialog(
            context: context,
            builder: (_) {
              return CustomAlertDialog(
                  content: 'Do you want to move todo to recycle bin?',
                  scaffoldKey: scaffoldKey,
                  snackBarText: 'Todo moved to recycle bin',
                  mainContext: context,
                  func: () {
                    todo.inTrash = true;
                    firestoreService.saveToDo(todo);
                  });
            });
      },
      iconOnLeftSwipe: Icons.delete,
      iconColor: Colors.red,
    );
  }
}
