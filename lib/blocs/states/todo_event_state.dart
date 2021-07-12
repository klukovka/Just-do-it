import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/pages/todos_gridview.dart';
import 'package:just_do_it/pages/todos_line.dart';

abstract class ToDoEventState {
  Widget getToDos(Stream<List<ToDo>> todos, bool inTrash, bool? done,
      GlobalKey<ScaffoldState> scaffoldKey);
  Icon get stateIcon;
}

class ToDoEventStateList extends ToDoEventState {
  @override
  Widget getToDos(Stream<List<ToDo>> todos, bool inTrash, bool? done,
          GlobalKey<ScaffoldState> scaffoldKey) =>
      ToDosLine(
        todos: todos,
        inTrash: inTrash,
        done: done,
        scaffoldKey: scaffoldKey,
      );

  @override
  Icon get stateIcon => Icon(Icons.apps_outlined);
}

class ToDoEventStateGrid extends ToDoEventState {
  @override
  Widget getToDos(Stream<List<ToDo>> todos, bool inTrash, bool? done,
          GlobalKey<ScaffoldState> scaffoldKey) =>
      ToDosGridView(
        todos: todos,
        inTrash: inTrash,
        done: done,
        scaffoldKey: scaffoldKey,
      );

  @override
  Icon get stateIcon => Icon(Icons.line_style);
}
