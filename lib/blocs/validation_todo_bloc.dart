import 'dart:async';
import 'package:rxdart/rxdart.dart';

class ValidationToDoBloc {
  final _title = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _color = BehaviorSubject<String>();
  final _date = BehaviorSubject<DateTime>();

  Stream<String> get title => _title.stream.transform(validateTitle);
  Stream<String> get description =>
      _description.stream.transform(validateDescription);
  Stream<String> get color => _color.stream.transform(validateColor);
  Stream<DateTime> get date => _date.stream.transform(validateDate);
  Stream<bool> get formValid =>
      Rx.combineLatest4(title, description, color, date, (a, b, c, d) => true);

  Function(String) get changeTitle => _title.sink.add;
  Function(String) get changeDescription => _description.sink.add;
  Function(String) get changeColor => _color.sink.add;
  Function(DateTime) get changeDate => _date.sink.add;

  dispose() {
    _title.close();
    _description.close();
    _color.close();
    _date.close();
  }

  final validateTitle =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (title.length < 1) {
      sink.addError('Title lenght must be at least 1 character');
    } else {
      sink.add(title);
    }
  });

  final validateDescription =
      StreamTransformer<String, String>.fromHandlers(handleData: (decs, sink) {
    if (decs.length < 1) {
      sink.addError('Description lenght must be at least 1 character');
    } else {
      sink.add(decs);
    }
  });

  final validateColor =
      StreamTransformer<String, String>.fromHandlers(handleData: (color, sink) {
    if (color.length < 1) {
      sink.add('white');
    } else {
      sink.add(color);
    }
  });

  final validateDate = StreamTransformer<DateTime, DateTime>.fromHandlers(
      handleData: (date, sink) {
    if (date == null) {
      sink.addError('You must select date for end');
    } else {
      sink.add(date);
    }
  });
}
