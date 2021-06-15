import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ValidationBloc {
  final _name = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _repeatedPassword = BehaviorSubject<String>();

  //Get
  Stream<String> get name => _name.stream.transform(validateName);
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get repeatedPassword =>
      _repeatedPassword.stream.transform(validatePassword);
  Stream<bool> get formValid => Rx.combineLatest4(
      name, email, password, repeatedPassword, (a, b, c, d) => true);

  //Set
  Function(String) get changeName => _name.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeRepeatedPassword => _repeatedPassword.sink.add;

  dispose() {
    _name.close();
    _email.close();
    _password.close();
    _repeatedPassword.close();
  }

  //Transformers
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length < 3) {
      sink.addError('Name lenght must be at least 3 characters');
    } else {
      sink.add(name);
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    final RegExp _emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    if (!_emailRegExp.hasMatch(email)) {
      sink.addError('Enter correct email');
    } else {
      sink.add(email);
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    /*  final RegExp _passwordRegExp = RegExp(
      r'^(?=.*[A-Za-zА-Яа-я])(?=.*\d)[A-Za-zА-Яа-я\d]{8,}$',
    );
    if (!_passwordRegExp.hasMatch(password)) { */
    if (password.length < 8) {
      sink.addError('Password must contain at least 8 characters');
    } else {
      sink.add(password);
    }
  });

  submitData() {
    print(_name.value);
    print(_email.value);
    print(_password.value);
    print(_repeatedPassword.value);
  }

  bool get identicalPasswords => _password.value == _repeatedPassword.value;
  String get getEmail => _email.value;
  String get getPassword => _password.value;
}
