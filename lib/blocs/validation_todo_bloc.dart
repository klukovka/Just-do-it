import 'dart:async';
import 'package:just_do_it/blocs/states/color_state.dart';
import 'package:rxdart/rxdart.dart';

class ValidationToDoBloc {
  final _title = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _color = BehaviorSubject<ColorState>();

  Stream<String> get title => _title.stream.transform(validateTitle);
  Stream<String> get description =>
      _description.stream.transform(validateDescription);
  Stream<ColorState> get color => _color.stream.transform(validateColor);
  Stream<bool> get formValid =>
      Rx.combineLatest3(title, description, color, (a, b, c) => true);

  Function(String) get changeTitle => _title.sink.add;
  Function(String) get changeDescription => _description.sink.add;
  Function(ColorState) get changeColor => _color.sink.add;

  dispose() {
    _title.close();
    _description.close();
    _color.close();
  }

  final validateTitle =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (title.length == 0) {
      sink.addError('Title lenght must be at least 1 character');
    } else {
      sink.add(title);
    }
  });

  final validateDescription =
      StreamTransformer<String, String>.fromHandlers(handleData: (decs, sink) {
    if (decs.length == 0) {
      sink.addError('Description lenght must be at least 1 character');
    } else {
      sink.add(decs);
    }
  });

  final validateColor = StreamTransformer<ColorState, ColorState>.fromHandlers(
      handleData: (color, sink) {
    sink.add(color);
  });
}
