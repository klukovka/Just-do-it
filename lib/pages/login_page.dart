import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/pages/home_page.dart';
import 'package:just_do_it/pages/register_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late StreamSubscription<User?> loginStreamSubscription;
  late String _email, _password;

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
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
          ),
        ),

        SignInButton(Buttons.Email, text: 'Sign In', onPressed: () {
          try {
            authBloc.signInWithEmail(_email, _password);
          } catch (ex) {
            print(ex);
          }
        }),
        SignInButton(Buttons.Google, text: 'Sign In with Google',
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
                MaterialPageRoute(builder: (context) => RegisterPage())),
            child: Text('Create an account')),
      ],
    ));
  }
}
