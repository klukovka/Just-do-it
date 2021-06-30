import 'package:flutter/widgets.dart';
import 'package:just_do_it/blocs/events/color_event.dart';
import 'package:just_do_it/models/todo.dart';
import 'package:just_do_it/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class ToDoProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String? _toDoId;
  String? _title;
  String? _description;
  bool? _done;
  bool? _inTrash;
  String? _userId;
  String? _color;
  var uuid = Uuid();

  //getters
  String? get toDoId => _toDoId;
  String? get title => _title;
  String? get description => _description;
  bool? get done => _done;
  bool? get inTrash => _inTrash;
  String? get userId => _userId;
  String? get color => _color;
  DateTime? get dateCreate => dateCreate;

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
    _toDoId = todo.toDoId ?? uuid.v4();
    _title = todo.title;
    _description = todo.description;
    _done = todo.done;
    _inTrash = todo.inTrash;
    _userId = todo.userId;
    _color = todo.color;
    print(todo.color);
    print(todo.description);
    print(todo.done);
    print(todo.inTrash);
    print(todo.title);
    print(todo.toDoId);
    print(todo.userId);
  }

  nullToDo() {
    _toDoId = null;
    _title = null;
    _description = null;
    _done = false;
    _inTrash = false;
    _userId = null;
    _color = 'white';
  }

  getColorEvent() {
    switch (color) {
      case 'red':
        return ColorEvent.red;
      case 'orange':
        return ColorEvent.orange;
      case 'yellow':
        return ColorEvent.yellow;
      case 'green':
        return ColorEvent.green;
      case 'blue':
        return ColorEvent.blue;
      case 'darkblue':
        return ColorEvent.darkblue;
      case 'purple':
        return ColorEvent.purple;
      default:
        return ColorEvent.white;
    }
  }

  saveToDo() {
    var todo = ToDo(
      color: color ?? 'white',
      description: description,
      done: done,
      inTrash: inTrash,
      title: title,
      toDoId: toDoId ?? uuid.v4(),
      userId: userId,
      dateCreate: DateTime.now(),
    );

    firestoreService.saveToDo(todo);
  }

  removeToDo(String id) {
    firestoreService.removeToDo(id);
  }
}
