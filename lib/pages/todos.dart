import 'package:flutter/material.dart';
import 'package:just_do_it/blocs/states/todo_event_state.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/providers/search_provider.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:just_do_it/widgets/custom_progress_bar.dart';
import 'package:just_do_it/widgets/empty_list.dart';
import 'package:just_do_it/widgets/scale_widget.dart';
import 'package:just_do_it/widgets/slidable_todo.dart';
import 'package:just_do_it/widgets/swipe_todo.dart';
import 'package:just_do_it/widgets/todo_line.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ToDos extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  final Stream<List<ToDo>> todos;
  final bool inTrash;
  final bool? done;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ToDoEventState state;

  ToDos({
    required this.todos,
    required this.inTrash,
    this.done,
    required this.scaffoldKey,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    return StreamBuilder<List<ToDo>>(
        stream: todos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return ScaleWidget(child: CustomProgressBar());

          if (snapshot.hasError)
            return ScaleWidget(
              child: Center(
                child: Text('Error'),
              ),
            );

          List<ToDo> list = snapshot.data ?? [];
          list.sort(
              (todo1, todo2) => todo2.dateCreate!.compareTo(todo1.dateCreate!));

          list = list.where((element) {
            if (done != null)
              return element.done == done && element.inTrash == inTrash;
            else
              return element.inTrash == inTrash;
          }).where((element) {
            if (searchProvider.searchValue != null)
              return element.title!.contains('${searchProvider.searchValue}') ||
                  element.description!
                      .contains('${searchProvider.searchValue}');
            else
              return true;
          }).toList();

          if (list.length == 0) return ScaleWidget(child: EmptyList());

          if (state is ToDoEventStateList) {
            return ListView.separated(
              itemBuilder: (context, index) => ScaleWidget(
                child: SlidableToDo(
                  scaffoldKey: scaffoldKey,
                  todo: list[index],
                  child: ToDoLine(
                    todo: list[index],
                    scaffoldKey: scaffoldKey,
                  ),
                ),
              ),
              itemCount: list.length,
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 15,
              ),
            );
          } else {
            List<Widget> widgets = [];
            for (int i = 0; i < list.length; i++) {
              if (list[i].inTrash == true) {
                widgets.add(ScaleWidget(
                  child: SlidableToDo(
                    todo: list[i],
                    child: ToDoLine(
                      todo: list[i],
                      scaffoldKey: scaffoldKey,
                    ),
                    scaffoldKey: scaffoldKey,
                  ),
                ));
              } else {
                widgets.add(ScaleWidget(
                  child: SwipeToDo(
                    scaffoldKey: scaffoldKey,
                    todo: list[i],
                    child: ToDoLine(
                      todo: list[i],
                      scaffoldKey: scaffoldKey,
                    ),
                  ),
                ));
              }
            }
            return GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: widgets,
            );
          }
        });
  }
}
