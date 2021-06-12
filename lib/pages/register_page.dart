import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/pages/home_page.dart';
import 'package:just_do_it/pages/login_page.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late StreamSubscription<User?> loginStreamSubscription;
  late String _email, _password, _repeatedPassword, _name;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStreamSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
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

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Name'),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Email'),
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: 'Repeat password'),
            onChanged: (value) {
              setState(() {
                _repeatedPassword = value;
              });
            },
          ),
        ),
        SignInButton(Buttons.Email, text: 'Sign Up', onPressed: () {
          if (_password == _repeatedPassword) {
            authBloc.createUserWithEmail(_email, _password);
          } else {
            print('error');
          }
        }),
        SignInButton(Buttons.Google, text: 'Sign Up with Google',
            onPressed: () {
          try {
            authBloc.loginGoogle();
          } catch (ex) {
            print(ex);
          }
        }),
        // ignore: deprecated_member_use
        FlatButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage())),
            child: Text('I have an account')),
      ],
    ));
  }
}
