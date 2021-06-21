import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/blocs/states/color_state.dart';

import 'events/color_event.dart';

class ColorBloc extends Bloc<ColorEvent, ColorState> {
  ColorBloc(ColorState initialState) : super(initialState);

  @override
  Stream<ColorState> mapEventToState(event) async* {
    switch (event) {
      case ColorEvent.red:
        yield ColorState(color: Colors.red, colorName: 'red');
        break;
      case ColorEvent.orange:
        yield ColorState(color: Colors.orange, colorName: 'orange');
        break;
      case ColorEvent.yellow:
        yield ColorState(color: Colors.yellow, colorName: 'yellow');
        break;
      case ColorEvent.green:
        yield ColorState(color: Colors.green, colorName: 'green');
        break;
      case ColorEvent.blue:
        yield ColorState(color: Colors.lightBlue, colorName: 'blue');
        break;
      case ColorEvent.darkblue:
        yield ColorState(color: Colors.blue, colorName: 'darkblue');
        break;
      case ColorEvent.purple:
        yield ColorState(color: Colors.purple, colorName: 'purple');
        break;
      default:
        yield ColorState(color: Colors.white, colorName: 'white');
        break;
    }
  }
}
