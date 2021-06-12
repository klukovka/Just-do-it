import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
    int _selectedIndex = 1;

    const List<Widget> _widgetOptions = <Widget>[
      Text(
        'All',
      ),
      Text(
        'To do',
      ),
      Text(
        'Done',
      ),
    ];

    return StreamBuilder<User?>(
        stream: authBloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return Scaffold(
            appBar: AppBar(
              title: Text('Just do it'),
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
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  )
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8,
                    activeColor: Colors.black,
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    duration: Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.grey[100]!,
                    color: Colors.black,
                    tabs: [
                      GButton(
                        icon: Icons.note_rounded,
                        text: 'All',
                      ),
                      GButton(
                        icon: Icons.lock_clock,
                        text: 'To do',
                      ),
                      GButton(
                        icon: Icons.check_box,
                        text: 'Done',
                      ),
                    ],
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      print(_selectedIndex);
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
