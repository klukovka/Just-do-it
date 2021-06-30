import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToDo {
  String? toDoId;
  String? title;
  String? description;
  bool? done;
  bool? inTrash;
  String? userId;
  String? color;
  Timestamp? dateCreate;

  ToDo({
    this.description,
    this.done,
    this.inTrash,
    this.title,
    this.toDoId,
    this.userId,
    this.color,
    this.dateCreate,
  });

  Map<String, dynamic> get toMap => {
        'toDoId': toDoId,
        'title': title,
        'description': description,
        'done': done,
        'inTrash': inTrash,
        'userId': userId,
        'color': color,
        'dateCreate':dateCreate,
      };

  ToDo.fromFirestore(Map<String, dynamic> firestore)
      : toDoId = firestore['toDoId'],
        title = firestore['title'],
        description = firestore['description'],
        done = firestore['done'],
        inTrash = firestore['inTrash'],
        color = firestore['color'],
        dateCreate=firestore['dateCreate'],
        userId = firestore['userId'];

  Color get todoColor {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.lightBlue;
      case 'darkblue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.white;
    }
  }
}
