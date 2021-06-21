import 'package:flutter/widgets.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class ToDoProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String? _toDoId;
  String? _title;
  String? _description;
  bool? _done;
  DateTime? _date;
  bool? _inTrash;
  String? _userId;
  String? _color;
  var uuid = Uuid();

  //getters
  String? get toDoId => _toDoId;
  String? get title => _title;
  String? get description => _description;
  bool? get done => _done;
  DateTime? get date => _date;
  bool? get inTrash => _inTrash;
  String? get userId => _userId;
  String? get color => _color;

  //setters
  changeTitle(String value) {
    _title = value;
    notifyListeners();
  }

  changeDescription(String value) {
    _description = value;
    notifyListeners();
  }

  changeDone(bool value) {
    _done = value;
    notifyListeners();
  }

  changeDate(DateTime value) {
    _date = value;
    notifyListeners();
  }

  changeInTrash(bool value) {
    _inTrash = value;
    notifyListeners();
  }

  changeUserId(String value) {
    _userId = value;
    notifyListeners();
  }

  changeColor(String value) {
    _color = value;
    notifyListeners();
  }

  loadValues(ToDo todo) {
    _toDoId = todo.toDoId;
    _title = todo.title;
    _description = todo.description;
    _done = todo.done;
    _date = todo.date;
    _inTrash = todo.inTrash;
    _userId = todo.userId;
    _color = todo.color;
  }

  saveToDo() {
    String? tdId = toDoId == null ? uuid.v4() : toDoId;
    var todo = ToDo(
      color: color,
      date: date,
      description: description,
      done: done,
      inTrash: inTrash,
      title: title,
      toDoId: tdId,
      userId: userId,
    );
    firestoreService.saveToDo(todo);
  }

  removeToDo(String id) {
    firestoreService.removeToDo(id);
  }
}
