import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/states/todo_event_state.dart';
import 'package:just_do_it/blocs/states/todo_search_state.dart';
import 'package:just_do_it/blocs/todo_search_bloc.dart';
import 'package:just_do_it/blocs/todo_view_bloc.dart';
import 'package:just_do_it/widgets/animated_state_icon.dart';
import 'package:just_do_it/widgets/title_app_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ToDoSearchState searchState;
  final ToDoEventState eventState;
  final String title;
  final Widget leading;
  final AnimationController? turnsAnimationController;
  const CustomAppBar({
    Key? key,
    required this.searchState,
    required this.title,
    required this.leading,
    required this.eventState,
    this.turnsAnimationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toDoViewBloc = BlocProvider.of<ToDoViewBloc>(context);
    final toDoSearchBloc = BlocProvider.of<ToDoSearchBloc>(context);

    return AppBar(
      title: TitleAppBar(
        state: searchState,
        title: title,
      ),
      leading: leading,
      actions: [
        ButtonBar(
          children: [
            if (searchState is ToDoSearchStateFalse)
              IconButton(
                  onPressed: () {
                    turnsAnimationController!.animateTo(0.25).whenComplete(() {
                      toDoSearchBloc.add(ToDoSearchEvent.todoSearch);
                      turnsAnimationController!.animateTo(0);
                    });
                  },
                  icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  if (eventState is ToDoEventStateList)
                    toDoViewBloc.add(ToDoViewEvent.grid_event);
                  else
                    toDoViewBloc.add(ToDoViewEvent.list_event);
                },
                icon: AnimatedStateIcon(state: eventState)),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
