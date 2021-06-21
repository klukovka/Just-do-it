import 'package:flutter/widgets.dart';
import 'package:just_do_it/services/firestore_service.dart';

class ToDoProvider with ChangeNotifier{
  final firestoreService = FirestoreService();

}