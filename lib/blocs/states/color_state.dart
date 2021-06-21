import 'package:flutter/material.dart';

class ColorState {
  Color? color;
  String? colorName;

  ColorState({this.color, this.colorName});

  ColorState.fromColor(String name) {
    switch (name) {
      case 'red':
        color = Colors.red;
        break;
      case 'orange':
        color = Colors.orange;

        break;
      case 'yellow':
        color = Colors.yellow;

        break;
      case 'green':
        color = Colors.green;

        break;
      case 'blue':
        color = Colors.lightBlue;

        break;
      case 'darkblue':
        color = Colors.blue;

        break;
      case 'purple':
        color = Colors.purple;

        break;
      default:
        color = Colors.white;
        break;
    }
  }
}
