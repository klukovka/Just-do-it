import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/pages/todos.dart';

abstract class ToDoEventState {
  Widget getToDos(Stream<List<ToDo>> todos, bool inTrash, bool? done,
          GlobalKey<ScaffoldState> scaffoldKey) =>
      ToDos(
        todos: todos,
        inTrash: inTrash,
        done: done,
        scaffoldKey: scaffoldKey,
        state: this,
      );
  Icon get stateIcon;
}

class ToDoEventStateList extends ToDoEventState {
  
  @override
  Icon get stateIcon => Icon(
        Icons.apps_outlined,
        key: ValueKey<String>('List'),
      );
}

class ToDoEventStateGrid extends ToDoEventState {
  @override
  Icon get stateIcon => Icon(
        Icons.line_style,
        key: ValueKey<String>('Grid'),
      );
}
