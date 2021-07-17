import 'package:flutter/material.dart';
import 'package:just_do_it/blocs/states/color_state.dart';

class BoxColored extends StatelessWidget {
  final ColorState colorState;
  final Color color;
  const BoxColored({
    Key? key,
    required this.color,
    required this.colorState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: colorState.color == color ? 40 : 30,
      height: colorState.color == color ? 40 : 30,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
    );
  }
}