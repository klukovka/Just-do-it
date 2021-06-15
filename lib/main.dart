import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/pages/login_page.dart';
import 'package:provider/provider.dart';

import 'blocs/validation_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: Provider(
        create: (context) => ValidationBloc(),
        child: MaterialApp(
          title: 'Just do it',
          home: LoginPage(),
        ),
      ),
    );
  }
}
