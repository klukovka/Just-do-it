import 'package:flutter/material.dart';
import 'package:just_do_it/blocs/states/todo_event_state.dart';

class AnimatedStateIcon extends StatelessWidget {
  final ToDoEventState state;
  const AnimatedStateIcon({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      child: state.stateIcon,
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) =>
          ScaleTransition(child: child, scale: animation),
    );
  }
}
