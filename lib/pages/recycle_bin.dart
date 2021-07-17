import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/states/todo_event_state.dart';
import 'package:just_do_it/blocs/states/todo_search_state.dart';
import 'package:just_do_it/blocs/todo_search_bloc.dart';
import 'package:just_do_it/blocs/todo_view_bloc.dart';
import 'package:just_do_it/blocs/user_bloc.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:just_do_it/widgets/arrow_recycle_bin.dart';
import 'package:just_do_it/widgets/custom_alert_dialog.dart';
import 'package:just_do_it/widgets/custom_app_bar.dart';
import 'package:just_do_it/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';

class RecycleBin extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  RecycleBin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
                key: scaffoldKey,
                appBar: CustomAppBar(
                  searchState: snapshotToDoSearchState,
                  title: 'Recycle Bin',
                  leading: ArrowRecycleBin(
                    state: snapshotToDoSearchState,
                  ),
                  eventState: snapshotToDoEventState,
                ),
                body: snapshotToDoEventState.getToDos(
                    firestoreService.getAllToDos('${snapshot.data!.userId}'),
                    true,
                    null,
                    scaffoldKey),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return CustomAlertDialog(
                              content: 'Do you want to delete all todos?',
                              scaffoldKey: scaffoldKey,
                              snackBarText: 'All todos were deleted',
                              mainContext: context,
                              func: () {
                                firestoreService
                                    .removeAllToDos('${userProvider.userId}');
                              });
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
