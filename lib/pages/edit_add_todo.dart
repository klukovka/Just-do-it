import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_do_it/blocs/color_bloc.dart';
import 'package:just_do_it/blocs/events/color_event.dart';
import 'package:just_do_it/blocs/states/color_state.dart';
import 'package:just_do_it/blocs/validation_todo_bloc.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/providers/todo_provider.dart';
import 'package:just_do_it/providers/user_provider.dart';
import 'package:just_do_it/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class EditAddToDo extends StatefulWidget {
  ToDo? todo;
  EditAddToDo({Key? key, this.todo}) : super(key: key);

  @override
  _EditAddToDoState createState() => _EditAddToDoState();
}

class _EditAddToDoState extends State<EditAddToDo> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  FToast fToast = FToast();

  @override
  void initState() {
    final colorBloc = BlocProvider.of<ColorBloc>(context);
    colorBloc.add(ColorEvent.white);
    fToast.init(context);
    if (widget.todo == null) {
      titleController.text = '';
      descController.text = '';
    } else {
      titleController.text = widget.todo!.title!;
      descController.text = widget.todo!.description!;
    }
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
              controller: titleController,
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
              controller: descController,
              maxLines: 6,
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
    if (widget.todo != null) _bloc.add(todoProvider.getColorEvent());
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
                          bloc.changeColor(
                              ColorState(color: Colors.red, colorName: 'red'));
                          todoProvider.changeColor('red');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.orange),
                        onTap: () {
                          _bloc.add(ColorEvent.orange);
                          bloc.changeColor(ColorState(
                              color: Colors.orange, colorName: 'orange'));
                          todoProvider.changeColor('orange');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.yellow),
                        onTap: () {
                          _bloc.add(ColorEvent.yellow);
                          bloc.changeColor(ColorState(
                              color: Colors.yellow, colorName: 'yellow'));
                          todoProvider.changeColor('yellow');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.green),
                        onTap: () {
                          _bloc.add(ColorEvent.green);
                          bloc.changeColor(ColorState(
                              color: Colors.green, colorName: 'green'));
                          todoProvider.changeColor('green');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.lightBlue),
                        onTap: () {
                          _bloc.add(ColorEvent.blue);
                          bloc.changeColor(ColorState(
                              color: Colors.lightBlue, colorName: 'blue'));
                          todoProvider.changeColor('blue');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.blue),
                        onTap: () {
                          _bloc.add(ColorEvent.darkblue);
                          bloc.changeColor(ColorState(
                              color: Colors.blue, colorName: 'darkblue'));
                          todoProvider.changeColor('darkblue');
                        },
                      ),
                      GestureDetector(
                        child: coloredBox(snapshot, Colors.purple),
                        onTap: () {
                          _bloc.add(ColorEvent.purple);
                          bloc.changeColor(ColorState(
                              color: Colors.purple, colorName: 'purple'));
                          todoProvider.changeColor('purple');
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
    final todoProvider = Provider.of<ToDoProvider>(context);
    final _bloc = BlocProvider.of<ColorBloc>(context);

    return BlocBuilder<ColorBloc, ColorState>(
        builder: (context, colorSnapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.todo == null ? 'Add' : 'Edit',
            style: TextStyle(
              color: colorSnapshot.color == Colors.white
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          backgroundColor: colorSnapshot.color,
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
        floatingActionButton: StreamBuilder<bool>(
            stream: validationBloc.formValid,
            builder: (context, snapshot) {
              bool correct = snapshot.hasData &&
                  todoProvider.title != null &&
                  todoProvider.description != null;
              return FloatingActionButton(
                onPressed: () {
                  if (correct) {
                    if (widget.todo == null) {
                      todoProvider.changeDone(false);
                      todoProvider.changeInTrash(false);
                      todoProvider.changeUserId('${userProvider.userId}');
                    }
                    todoProvider.saveToDo();
                    _bloc.add(ColorEvent.white);
                    todoProvider.nullToDo();
                    Navigator.of(context).pop();
                  } else {
                    _showToast('Input correct data');
                  }
                },
                child: Icon(Icons.check),
              );
            }),
      );
    });
  }
}
