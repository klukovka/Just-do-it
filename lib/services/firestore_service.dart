import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_do_it/models/app_user.dart';
import 'package:just_do_it/models/todo.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(AppUser user) {
    return _db.collection('users').doc(user.userId).set(user.toMap);
  }

  Future<AppUser> getUser(String userId) {
    return _db.collection('users').doc(userId).get().then(
        (value) => AppUser.fromFirebase(value.data() as Map<String, dynamic>));
  }

  Future<void> removeUser(String userId) {
    return _db.collection('users').doc(userId).delete();
  }

  Future<void> saveToDo(ToDo todo) {
    return _db.collection('todos').doc(todo.toDoId).set(todo.toMap);
  }

  Future<void> removeToDo(String id) {
    return _db.collection('todos').doc(id).delete();
  }
}
