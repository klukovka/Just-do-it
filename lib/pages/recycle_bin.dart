import 'package:flutter/material.dart';
import 'package:just_do_it/blocs/user_bloc.dart';
import 'package:just_do_it/pages/todos_line.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:provider/provider.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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

          return Scaffold(
            appBar: AppBar(
              title: Text('Recycle Bin'),
            ),
            body: ToDosLine(todos: firestoreService.getToDosInTrash('${snapshot.data!.userId}'),),
          );
        });
  }
}
