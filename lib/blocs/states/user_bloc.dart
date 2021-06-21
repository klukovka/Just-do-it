import 'dart:async';

import 'package:just_do_it/providers/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _userProvider = BehaviorSubject<UserProvider>();

  //get
  Stream<UserProvider> get userProvider =>
      _userProvider.stream.transform(addUser);

  //set
  Function(UserProvider) get changeUserProvider => _userProvider.sink.add;

  dispose() {
    _userProvider.close();
  }

  final addUser = StreamTransformer<UserProvider, UserProvider>.fromHandlers(
      handleData: (data, sink) {
    sink.add(data);
  });
}
