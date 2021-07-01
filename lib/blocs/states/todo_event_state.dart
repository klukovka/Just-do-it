import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/pages/todos_gridview.dart';
import 'package:just_do_it/pages/todos_line.dart';

abstract class ToDoEventState {
  Widget getToDos(Stream<List<ToDo>> todos);
  Icon get stateIcon;
}

class ToDoEventStateList extends ToDoEventState {
  @override
  Widget getToDos(Stream<List<ToDo>> todos) => ToDosLine(todos: todos);

  @override
  Icon get stateIcon => Icon(Icons.grid_4x4);
}

class ToDoEventStateGrid extends ToDoEventState {
  @override
  Widget getToDos(Stream<List<ToDo>> todos) => ToDosGridView(todos: todos);

  @override
  Icon get stateIcon => Icon(Icons.line_style);
}
