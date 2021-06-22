import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/pages/home_page.dart';
import 'package:just_do_it/pages/reg_page.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late StreamSubscription<User?> loginStreamSubscription;
  late String _email, _password;
  FToast fToast = FToast();

  @override
  void initState() {
    fToast.init(context);
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStreamSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.getUser(fbUser.uid);
        print('${userProvider.name}==${fbUser.uid}');
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

  void _showToast(String message) {
    fToast.showToast(
      child: CustomToast(toastText: message),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
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
            decoration:
                InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
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
            decoration: InputDecoration(
                labelText: 'Password', icon: Icon(Icons.password)),
          ),
        ),

        SignInButton(Buttons.Email, text: 'Sign In', onPressed: () async {
          try {
            await authBloc.signInWithEmail(_email, _password);
          } on FirebaseAuthException catch (ex) {
            print(ex.message);
            _showToast('${ex.message}');
          } catch (ex) {
            print(ex.toString());
            _showToast('Ooops! Something went wrong :(');
          }
        }),
        SignInButton(Buttons.Google, text: 'Sign In with Google',
            onPressed: () async {
          try {
            await authBloc.loginGoogle();
          } on FirebaseAuthException catch (ex) {
            print(ex.message);
            _showToast('${ex.message}');
          } catch (ex) {
            print(ex.toString());
            _showToast('Ooops! Something went wrong :(');
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
