import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/states/todo_search_state.dart';
import 'package:just_do_it/blocs/todo_search_bloc.dart';
import 'package:just_do_it/providers/search_provider.dart';
import 'package:provider/provider.dart';

class ArrowRecycleBin extends StatelessWidget {
  final ToDoSearchState state;
  const ArrowRecycleBin({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toDoSearchBloc = BlocProvider.of<ToDoSearchBloc>(context);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (state is ToDoSearchStateFalse) {
            Navigator.of(context).pop();
          } else {
            toDoSearchBloc.add(ToDoSearchEvent.todoNotSearch);
            searchProvider.changeSearchValue(null);
          }
        });
  }
}
