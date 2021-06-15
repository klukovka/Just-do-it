import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/pages/home_page.dart';
import 'package:just_do_it/pages/login_page.dart';
import 'package:just_do_it/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late StreamSubscription<User?> loginStreamSubscription;

  FToast fToast = FToast();
  String _name = '';
  String _email = '';
  String _password = '';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _nameController.text = _name;
    _emailController.text = _email;
    _passwordController.text = _password;
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

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'Please enter name';
                    _nameController.text = _name = value;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'Please enter email';
                    if (value.indexOf('@') < 1)
                      return 'Please enter correct email';

                    _emailController.text = _email = value;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'Please enter password';
                    if (value.length < 8)
                      return 'Please enter correct password';

                    _passwordController.text = _password = value;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Repeat password'),
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'Please enter password';
                    if (value.length < 8)
                      return 'Please enter correct password';
                    if (value != _password) return 'Passwords is not identical';
                    return null;
                  },
                ),
              ),
              SignInButton(Buttons.Email, text: 'Sign Up', onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    User user =
                        await authBloc.createUserWithEmail(_email, _password);
                  } on FirebaseAuthException catch (ex) {
                    print(ex.message);
                    _showToast('${ex.message}');
                  } catch (ex) {
                    print(ex.toString());
                    _showToast('Ooops! Something went wrong :(');
                  }
                } else {
                  _showToast('Inspect your data carefully');
                }
              }),
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage())),
                  child: Text('I have an account')),
            ],
          ),
        ),
      ),
    );
  }
}
