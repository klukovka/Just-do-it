import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/pages/login_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<User?> loginStreamSubscription;
  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStreamSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
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

    return StreamBuilder<User?>(
        stream: authBloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return DefaultTabController(
            length: 3,
                      child: Scaffold(
              appBar: AppBar(
                title: Text('Just do it'),
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.lock_clock), text: 'To do'),
                    Tab(icon: Icon(Icons.check_box), text: 'Done'),
                    Tab(icon: Icon(Icons.note_rounded), text: 'All'),
                  ],
                ),
              ),
              body: TabBarView(children: [
                Text('to do'),
                Text('done'),
                Text('all'),
              ]),
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
                              subtitle: Text('${snapshot.data!.displayName}'),
                            ),
                            ListTile(
                              title: Text('Email'),
                              subtitle: Text('${snapshot.data!.email}'),
                            ),
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
                              onPressed: () {},
                              child: Text('Recucle bin'),
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
            ),
          );
        });
  }
}
