import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/blocs/states/todo_event_state.dart';
import 'package:just_do_it/blocs/states/todo_search_state.dart';
import 'package:just_do_it/blocs/todo_search_bloc.dart';
import 'package:just_do_it/blocs/todo_view_bloc.dart';
import 'package:just_do_it/blocs/user_bloc.dart';
import 'package:just_do_it/models/app_user.dart';
import 'package:just_do_it/pages/edit_add_todo.dart';
import 'package:just_do_it/pages/login_page.dart';
import 'package:just_do_it/pages/recycle_bin.dart';
import 'package:just_do_it/providers/todo_provider.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:just_do_it/widgets/arrow_burger.dart';
import 'package:just_do_it/widgets/custom_alert_dialog.dart';
import 'package:just_do_it/widgets/custom_app_bar.dart';
import 'package:just_do_it/widgets/custom_progress_bar.dart';
import 'package:just_do_it/widgets/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<User?> loginStreamSubscription;
  late AnimationController turnsAnimationController = AnimationController(
    duration: Duration(milliseconds: 600),
    vsync: this,
  );

  FToast fToast = FToast();
  int _selectedIndex = 1;

  @override
  void initState() {
    fToast.init(context);

    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final todoProvider = Provider.of<ToDoProvider>(context, listen: false);

    todoProvider.nullToDo();

    loginStreamSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        userProvider.loadValues(AppUser());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    loginStreamSubscription.cancel();
    turnsAnimationController.dispose();
    super.dispose();
  }

  void _showToast(CustomToast toast) {
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userBloc = context.read<UserBloc>();
    final firestore = FirestoreService();

    return StreamBuilder<User?>(
        stream: authBloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CustomProgressBar();
          return StreamBuilder<UserProvider>(
              stream: userBloc.userProvider,
              builder: (context, userSnapshot) {
                userBloc.changeUserProvider(userProvider);
                if (!userSnapshot.hasData) return CustomProgressBar();
                return BlocBuilder<ToDoViewBloc, ToDoEventState>(
                    builder: (context, snapshotToDoEventState) {
                  return BlocBuilder<ToDoSearchBloc, ToDoSearchState>(
                      builder: (context, snapshotToDoSearchState) {
                    return Scaffold(
                      key: scaffoldKey,
                      appBar: CustomAppBar(
                        turnsAnimationController: turnsAnimationController,
                        eventState: snapshotToDoEventState,
                        leading: ArrowBurger(
                          scaffoldKey: scaffoldKey,
                          searchState: snapshotToDoSearchState,
                          turnsAnimationController: turnsAnimationController,
                        ),
                        searchState: snapshotToDoSearchState,
                        title: 'Just do it!',
                      ),
                      body: userSnapshot.data!.userId != null
                          ? _selectedIndex == 0
                              ? snapshotToDoEventState.getToDos(
                                  firestore.getAllToDos(
                                      '${userSnapshot.data!.userId}'),
                                  false,
                                  null,
                                  scaffoldKey)
                              : _selectedIndex == 1
                                  ? snapshotToDoEventState.getToDos(
                                      firestore.getAllToDos(
                                          '${userSnapshot.data!.userId}'),
                                      false,
                                      false,
                                      scaffoldKey)
                                  : snapshotToDoEventState.getToDos(
                                      firestore.getAllToDos(
                                          '${userSnapshot.data!.userId}'),
                                      false,
                                      true,
                                      scaffoldKey)
                          : CustomProgressBar(),
                      bottomNavigationBar: BottomNavigationBar(
                        items: [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.note_rounded), label: 'All'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.lock_clock), label: 'To do'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.check_box), label: 'Done'),
                        ],
                        currentIndex: _selectedIndex,
                        selectedItemColor: Colors.deepPurple,
                        unselectedItemColor: Colors.blueGrey,
                        onTap: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      ),
                      drawer: Drawer(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text('Name'),
                                      subtitle: userSnapshot.data!.name == null
                                          ? Text('Loaging...')
                                          : Text('${userSnapshot.data!.name}'),
                                    ),
                                    ListTile(
                                      title: Text('Email'),
                                      subtitle: snapshot.data!.email == null
                                          ? Text('Loaging...')
                                          : Text('${snapshot.data!.email}'),
                                    ),
                                    if (userSnapshot.data!.auth != 'google')
                                      // ignore: deprecated_member_use
                                      RaisedButton(
                                        onPressed: () async {
                                          await authBloc.resetPassword(
                                              '${snapshot.data!.email}');
                                          _showToast(CustomToast(
                                            toastText:
                                                'Request was sent to your email',
                                            toastColor: Colors.green,
                                            iconData: Icons.check,
                                          ));
                                        },
                                        child: Text('Change password'),
                                      ),
                                    // ignore: deprecated_member_use
                                    RaisedButton(
                                      onPressed: () {},
                                      child: Text('Change theme'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    // ignore: deprecated_member_use
                                    RaisedButton(
                                      onPressed: () {
                                        authBloc.logout();
                                        try {
                                          authBloc.logoutGoogle();
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Text('Log Out'),
                                    ),
                                    // ignore: deprecated_member_use
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecycleBin()),
                                        );
                                      },
                                      child: Text('Recycle bin'),
                                    ),
                                    // ignore: deprecated_member_use
                                    RaisedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return CustomAlertDialog(
                                                  content:
                                                      'Do you really want to delete your account?',
                                                  scaffoldKey: scaffoldKey,
                                                  snackBarText:
                                                      'Account have been already deleted',
                                                  mainContext: context,
                                                  func: () {
                                                    authBloc.logoutGoogle();
                                                    firestore
                                                        .removeAllToDos(
                                                            '${userSnapshot.data!.userId}')
                                                        .then((value) => firestore
                                                            .removeUser(
                                                                '${userSnapshot.data!.userId}')
                                                            .then((value) =>
                                                                authBloc
                                                                    .deleteUser()));
                                                  });
                                            });
                                      },
                                      child: Text('Delete an account'),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).push(
                            SwipeablePageRoute(
                                builder: (context) => EditAddToDo(
                                      scaffoldKey: scaffoldKey,
                                    )),
                          );
                        },
                      ),
                    );
                  });
                });
              });
        });
  }
}
