import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:just_do_it/widgets/custom_alert_dialog.dart';

class SlidableToDo extends StatelessWidget {
  final Widget child;
  final ToDo todo;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SlidableToDo(
      {Key? key,
      required this.child,
      required this.todo,
      required this.scaffoldKey})
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
          scaffoldKey.currentState!.showSnackBar(
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
          showDialog(
              context: context,
              builder: (_) {
                return CustomAlertDialog(
                    content: 'Do you want to delete this todo?',
                    scaffoldKey: scaffoldKey,
                    snackBarText: 'Todo was deleted',
                    mainContext: context,
                    func: () {
                      firestoreService.removeToDo('${todo.toDoId}');
                    });
              });
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
