import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late String _email;
  FToast fToast = FToast();

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Email', icon: Icon(Icons.email)),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authBloc.resetPassword(_email);
                  _showToast(CustomToast(
                    toastText: 'Request was sent to your email',
                    toastColor: Colors.green,
                    iconData: Icons.check,
                  ));
                  Navigator.of(context).pop();
                } on FirebaseAuthException catch (ex) {
                  print(ex.message);
                  _showToast(CustomToast(toastText: '${ex.message}'));
                } catch (ex) {
                  print(ex.toString());
                  _showToast(
                      CustomToast(toastText: 'Ooops! Something went wrong :('));
                }
              },
              child: Text('Send Request'),
            ),
          ]),
    );
  }
}
