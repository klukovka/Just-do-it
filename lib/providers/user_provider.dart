import 'package:flutter/widgets.dart';
import 'package:just_do_it/models/app_user.dart';
import 'package:just_do_it/services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  String? _userId;
  String? _name;
  String? _auth;

  String? get userId => _userId;
  String? get name => _name;
  String? get auth => _auth;

  changeName(String value) {
    _name = value;
    notifyListeners();
  }

  changeUserId(String value) {
    _name = value;
    notifyListeners();
  }

  changeAuth(String value) {
    _auth = value;
    notifyListeners();
  }

  loadValues(AppUser user) {
    _userId = user.userId;
    _name = user.name;
    _auth = user.auth;
  }

  saveUser(String authValue) {
    var user = AppUser(userId: userId, name: name, auth: authValue);
    firestoreService.saveUser(user);
  }

  removeUser(String userId) {
    firestoreService.removeUser(userId);
  }
}
