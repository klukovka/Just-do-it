import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_do_it/blocs/color_bloc.dart';
import 'package:just_do_it/blocs/events/color_event.dart';
import 'package:just_do_it/blocs/states/color_state.dart';
import 'package:just_do_it/blocs/validation_todo_bloc.dart';
import 'package:just_do_it/providers/todo_provider.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class EditAddToDo extends StatefulWidget {
  EditAddToDo({Key? key}) : super(key: key);

  @override
  _EditAddToDoState createState() => _EditAddToDoState();
}

class _EditAddToDoState extends State<EditAddToDo> {
  FToast fToast = FToast();

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  void _showToast(String message) {
    fToast.showToast(
      child: CustomToast(toastText: message),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Widget titleWidget(ValidationToDoBloc bloc) {
    final todoProvider = Provider.of<ToDoProvider>(context);
    return StreamBuilder<String>(
        stream: bloc.title,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.title),
                errorText:
                    '${snapshot.error}' == 'null' ? null : '${snapshot.error}',
              ),
              onChanged: (value) {
                bloc.changeTitle(value);
                todoProvider.changeTitle(value);
              },
            ),
          );
        });
  }

  Widget descriptionWidget(ValidationToDoBloc bloc) {
    final todoProvider = Provider.of<ToDoProvider>(context);
    return StreamBuilder<String>(
        stream: bloc.description,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Description',
                icon: Icon(Icons.description),
                errorText:
                    '${snapshot.error}' == 'null' ? null : '${snapshot.error}',
              ),
              onChanged: (value) {
                bloc.changeDescription(value);
                todoProvider.changeDescription(value);
              },
            ),
          );
        });
  }

  Widget coloredBox(ColorState state, Color color) {
    return SizedBox(
      width: state.color == color ? 40 : 30,
      height: state.color == color ? 40 : 30,
      child: Container(
        color: color,
      ),
    );
  }

  Widget colorsWidget(ValidationToDoBloc bloc) {
    final todoProvider = Provider.of<ToDoProvider>(context);
    ColorBloc _bloc = BlocProvider.of<ColorBloc>(context);
    return StreamBuilder<ColorState>(
        stream: bloc.color,
        builder: (context, streamSnapshot) {
          return BlocBuilder<ColorBloc, ColorState>(
              builder: (context, snapshot) {
          //  snapshot = ColorState.fromColor('${todoProvider.color}');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Icon(Icons.color_lens),
                title: Text('Color'),
                subtitle: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.red),
                        onTap: () {
                          _bloc.add(ColorEvent.red);
                          bloc.changeColor(snapshot);
                          todoProvider.changeColor('${snapshot.colorName}');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.orange),
                        onTap: () {
                          _bloc.add(ColorEvent.orange);
                          bloc.changeColor(snapshot);
                          todoProvider.changeColor('${snapshot.colorName}');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.yellow),
                        onTap: () {
                          _bloc.add(ColorEvent.yellow);
                          bloc.changeColor(snapshot);
                          todoProvider.changeColor('${snapshot.colorName}');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.green),
                        onTap: () {
                          _bloc.add(ColorEvent.green);
                          bloc.changeColor(snapshot);
                          todoProvider.changeColor('${snapshot.colorName}');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.lightBlue),
                        onTap: () {
                          _bloc.add(ColorEvent.blue);
                          bloc.changeColor(snapshot);
                          todoProvider.changeColor('${snapshot.colorName}');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.blue),
                        onTap: () {
                          _bloc.add(ColorEvent.darkblue);
                          bloc.changeColor(snapshot);
                          todoProvider.changeColor('${snapshot.colorName}');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.purple),
                        onTap: () {
                          _bloc.add(ColorEvent.purple);
                          bloc.changeColor(snapshot);
                          todoProvider.changeColor('${snapshot.colorName}');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final validationBloc = Provider.of<ValidationToDoBloc>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleWidget(validationBloc),
            descriptionWidget(validationBloc),
            colorsWidget(validationBloc)
          ],
        ),
      ),
    );
  }
}
