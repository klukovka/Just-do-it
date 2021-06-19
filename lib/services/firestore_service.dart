import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_do_it/models/app_user.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(AppUser user) {
    return _db.collection('users').doc(user.userId).set(user.toMap);
  }

  Future<void> removeUser(String userId) {
    return _db.collection('users').doc(userId).delete();
  }
}
