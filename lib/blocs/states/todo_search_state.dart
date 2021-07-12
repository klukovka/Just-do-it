import 'package:flutter/material.dart';
import 'package:just_do_it/widgets/search_bar.dart';

abstract class ToDoSearchState {
  Icon get searchIcon;
  Widget searchWidget(String? value);
}

class ToDoSearchStateTrue extends ToDoSearchState {
  @override
  Icon get searchIcon => Icon(Icons.search_off);

  @override
  Widget searchWidget(String? value) => SearchBar();
}

class ToDoSearchStateFalse extends ToDoSearchState {
  @override
  Icon get searchIcon => Icon(Icons.search);

  @override
  Widget searchWidget(String? value) => Text('$value');
}
