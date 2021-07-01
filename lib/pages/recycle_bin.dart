import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/states/todo_event_state.dart';
import 'package:just_do_it/blocs/todo_view_bloc.dart';
import 'package:just_do_it/blocs/user_bloc.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:provider/provider.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final toDoViewBloc = BlocProvider.of<ToDoViewBloc>(context);
    final FirestoreService firestoreService = FirestoreService();

    return StreamBuilder<UserProvider>(
        stream: userBloc.userProvider,
        builder: (context, snapshot) {
          userBloc.changeUserProvider(userProvider);
          if (!snapshot.hasData)
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
                width: 100,
                height: 100,
              ),
            );

          return BlocBuilder<ToDoViewBloc, ToDoEventState>(
              builder: (context, snapshotToDoEventState) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Recycle Bin'),
                actions: [
                  ButtonBar(
                    children: [
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
                firestoreService.getToDosInTrash('${snapshot.data!.userId}'),
              ),
            );
          });
        });
  }
}
