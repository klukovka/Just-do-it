import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/auth_bloc.dart';
import 'package:just_do_it/blocs/color_bloc.dart';
import 'package:just_do_it/blocs/states/color_state.dart';
import 'package:just_do_it/blocs/states/todo_event_state.dart';
import 'package:just_do_it/blocs/todo_view_bloc.dart';
import 'package:just_do_it/blocs/user_bloc.dart';
import 'package:just_do_it/blocs/validation_todo_bloc.dart';
import 'package:just_do_it/pages/login_page.dart';
import 'package:just_do_it/providers/todo_provider.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'blocs/validation_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        Provider<ValidationBloc>(
          create: (context) => ValidationBloc(),
        ),
        Provider<ValidationToDoBloc>(
          create: (context) => ValidationToDoBloc(),
        ),
        Provider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToDoProvider(),
        ),
        BlocProvider(
          create: (context) => ColorBloc(ColorState.fromColor('white')),
        ),
            BlocProvider(
          create: (context) => ToDoViewBloc(ToDoEventStateList()),
        ),
         
      ],
      child: MaterialApp(
        title: 'Just do it',
        home: LoginPage(),
      ),
    );
  }
}
