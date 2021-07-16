import 'package:flutter/material.dart';
import 'package:just_do_it/widgets/search_bar.dart';

abstract class ToDoSearchState {
  Icon get leftIcon;
  Widget searchWidget(String? value);
}

class ToDoSearchStateTrue extends ToDoSearchState {
  @override
  Widget searchWidget(String? value) => SearchBar();

  @override
  Icon get leftIcon => Icon(Icons.arrow_back);
}

class ToDoSearchStateFalse extends ToDoSearchState {
  @override
  Widget searchWidget(String? value) => Container(
        child: Text('$value'),
        alignment: Alignment.centerLeft,
      );

  @override
  Icon get leftIcon => Icon(Icons.dehaze_outlined);
}
