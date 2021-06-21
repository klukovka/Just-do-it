import 'package:flutter/widgets.dart';
import 'package:just_do_it/models/app_user.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  String? _userId;
  String? _name;
  String? _auth;
  List<ToDo> _todos = [];

  String? get userId => _userId;
  String? get name => _name;
  String? get auth => _auth;
  List<ToDo> get todos => _todos;

  changeName(String value) {
    _name = value;
    notifyListeners();
  }

  changeUserId(String value) {
    _userId = value;
    print('$_userId == $value');
    notifyListeners();
  }

  changeAuth(String value) {
    _auth = value;
    notifyListeners();
  }

  changeToDos(List<ToDo> value) {
    _todos = value;
    notifyListeners();
  }

  getUser(String id) {
    firestoreService.getUser(id).then((value) => loadValues(value));
  }

  loadValues(AppUser user) {
    print('User ${user.userId} => ${user.name} => ${user.auth}');
    _userId = user.userId;
    _name = user.name;
    _auth = user.auth;
    print('Provider $_userId => $_name => $_auth');
  }

  saveUser(String authValue) {
    var user = AppUser(userId: userId, name: name, auth: authValue);
    firestoreService.saveUser(user);
  }

  removeUser(String userId) {
    firestoreService.removeUser(userId);
  }
}
