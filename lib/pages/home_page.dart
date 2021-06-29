import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/blocs/user_bloc.dart';
import 'package:just_do_it/models/app_user.dart';
import 'package:just_do_it/pages/edit_add_todo.dart';
import 'package:just_do_it/pages/login_page.dart';
import 'package:just_do_it/pages/recycle_bin.dart';
import 'package:just_do_it/pages/todos_line.dart';
import 'package:just_do_it/providers/todo_provider.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<User?> loginStreamSubscription;
  int _selectedIndex = 1;

  @override
  void initState() {
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
    super.dispose();
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
          if (!snapshot.hasData)
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
                width: 100,
                height: 100,
              ),
            );
          return StreamBuilder<UserProvider>(
              stream: userBloc.userProvider,
              builder: (context, userSnapshot) {
                userBloc.changeUserProvider(userProvider);
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Just do it'),
                  ),
                  body: _selectedIndex == 0
                      ? ToDosLine(
                          todos: firestore
                              .getAllToDos('${userSnapshot.data!.userId}'))
                      : _selectedIndex == 1
                          ? ToDosLine(
                              todos: firestore.getNotDoneToDos(
                                  '${userSnapshot.data!.userId}'))
                          : ToDosLine(
                              todos: firestore.getDoneToDos(
                                  '${userSnapshot.data!.userId}')),
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
                        print(_selectedIndex);
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
                                    onPressed: () {},
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
                        MaterialPageRoute(builder: (context) => RecycleBin()),
                      );
                                  },
                                  child: Text('Recycle bin'),
                                ),
                                // ignore: deprecated_member_use
                                RaisedButton(
                                  onPressed: () {},
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
                        MaterialPageRoute(builder: (context) => EditAddToDo()),
                      );
                    },
                  ),
                );
              });
        });
  }
}
