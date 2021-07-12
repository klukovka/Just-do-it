import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/states/todo_event_state.dart';
import 'package:just_do_it/blocs/states/todo_search_state.dart';
import 'package:just_do_it/blocs/todo_search_bloc.dart';
import 'package:just_do_it/blocs/todo_view_bloc.dart';
import 'package:just_do_it/blocs/user_bloc.dart';
import 'package:just_do_it/providers/search_provider.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:just_do_it/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final toDoSearchBloc = BlocProvider.of<ToDoSearchBloc>(context);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final toDoViewBloc = BlocProvider.of<ToDoViewBloc>(context);
    final FirestoreService firestoreService = FirestoreService();

    return StreamBuilder<UserProvider>(
        stream: userBloc.userProvider,
        builder: (context, snapshot) {
          userBloc.changeUserProvider(userProvider);
          if (!snapshot.hasData) return CustomProgressBar();

          return BlocBuilder<ToDoViewBloc, ToDoEventState>(
              builder: (context, snapshotToDoEventState) {
            return BlocBuilder<ToDoSearchBloc, ToDoSearchState>(
                builder: (context, snapshotToDoSearchState) {
              return Scaffold(
                appBar: AppBar(
                  title: snapshotToDoSearchState.searchWidget(
                      searchProvider.searchValue ?? 'Recycle Bin'),
                  actions: [
                    ButtonBar(
                      children: [
                          IconButton(
                                  onPressed: () {
                                    if (snapshotToDoSearchState
                                        is ToDoSearchStateTrue) {
                                      toDoSearchBloc
                                          .add(ToDoSearchEvent.todoNotSearch);
                                      searchProvider.changeSearchValue(null);
                                    } else
                                      toDoSearchBloc
                                          .add(ToDoSearchEvent.todoSearch);
                                  },
                                  icon: snapshotToDoSearchState.searchIcon),
                        IconButton(
                            onPressed: () {
                              if (snapshotToDoEventState is ToDoEventStateList)
                                toDoViewBloc.add(ToDoViewEvent.grid_event);
                              else
                                toDoViewBloc.add(ToDoViewEvent.list_event);
                            },
                            icon: snapshotToDoEventState.stateIcon)
                      ],
                    )
                  ],
                ),
                body: snapshotToDoEventState.getToDos(
                    firestoreService.getAllToDos('${snapshot.data!.userId}'),
                    true,
                    null),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Attention!'),
                            content: Text('Do you want to delete all todos?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    // ignore: deprecated_member_use
                                    /*     Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red[700],
                                    duration: Duration(seconds: 2),
                                    content: Text('Todo moved to recycle bin'),
                                  ),
                                ); */
                                    firestoreService.removeAllToDos(
                                        '${userProvider.userId}');
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
                  child: Icon(Icons.delete_forever),
                  backgroundColor: Colors.redAccent[700],
                ),
              );
            });
          });
        });
  }
}
