import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/blocs/validation_bloc.dart';
import 'package:just_do_it/pages/login_page.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late StreamSubscription<User?> loginStreamSubscription;
  FToast fToast = FToast();

  @override
  void initState() {
    fToast.init(context);
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

  void _showToast(String message) {
    fToast.showToast(
      child: CustomToast(toastText: message),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Widget nameWidget(ValidationBloc bloc) {
    final userProvider = Provider.of<UserProvider>(context);
    return StreamBuilder<Object>(
      stream: bloc.name,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'Name',
              icon: Icon(Icons.account_circle),
              errorText:
                  '${snapshot.error}' == 'null' ? null : '${snapshot.error}',
            ),
            onChanged: (value) {
              bloc.changeName(value);
              userProvider.changeName(value);
            },
          ),
        );
      },
    );
  }

  Widget emailWidget(ValidationBloc bloc) {
    return StreamBuilder<Object>(
        stream: bloc.email,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
                errorText:
                    '${snapshot.error}' == 'null' ? null : '${snapshot.error}',
              ),
              onChanged: bloc.changeEmail,
            ),
          );
        });
  }

  Widget passwordWidget(ValidationBloc bloc) {
    return StreamBuilder<Object>(
        stream: bloc.password,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.password),
                errorText:
                    '${snapshot.error}' == 'null' ? null : '${snapshot.error}',
              ),
              onChanged: bloc.changePassword,
            ),
          );
        });
  }

  Widget repeatedPasswordWidget(ValidationBloc bloc) {
    return StreamBuilder<Object>(
        stream: bloc.repeatedPassword,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.password),
                errorText:
                    '${snapshot.error}' == 'null' ? null : '${snapshot.error}',
              ),
              onChanged: bloc.changeRepeatedPassword,
            ),
          );
        });
  }

  void toLogin() => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));

  @override
  Widget build(BuildContext context) {
    final validationBloc = Provider.of<ValidationBloc>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final authBloc = context.read<AuthBloc>();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              nameWidget(validationBloc),
              emailWidget(validationBloc),
              passwordWidget(validationBloc),
              repeatedPasswordWidget(validationBloc),
              StreamBuilder<Object>(
                  stream: validationBloc.formValid,
                  builder: (context, snapshot) {
                    return SignInButton(Buttons.Email, text: 'Sign Up',
                        onPressed: () async {
                      /*  !snapshot.hasData ? print(bloc.identicalPasswords) : bloc.submitData(); */
                      var signUpBool = snapshot.hasData;
                      if (signUpBool) {
                        if (validationBloc.identicalPasswords) {
                          print('register');

                          try {
                            var email = '${validationBloc.getEmail}';
                            var password = '${validationBloc.getPassword}';

                            User user = await authBloc.createUserWithEmail(
                                email, password);
                            await userProvider.changeUserId(user.uid);
                            await userProvider.saveUser('email');
                            toLogin();
                          } on FirebaseAuthException catch (ex) {
                            print(ex.message);
                            _showToast('${ex.message}');
                          } catch (ex) {
                            print(ex.toString());
                            _showToast('Ooops! Something wents wrong :(');
                          }
                        } else {
                          print('passwords');
                          _showToast('Passwords is not identical');
                        }
                      } else {
                        _showToast('Inspect your data carefully');
                        print('invalid');
                      }
                    });
                  }),
              // ignore: deprecated_member_use
              FlatButton(onPressed: toLogin, child: Text('I have an account')),
            ],
          ),
        ),
      ),
    );
  }
}
