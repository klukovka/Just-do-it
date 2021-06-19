class ToDo {
  String? toDoId;
  String? title;
  String? description;
  bool? done;
  DateTime? date;
  bool? inTrash;
  String? userId;

  ToDo({
    this.date,
    this.description,
    this.done,
    this.inTrash,
    this.title,
    this.toDoId,
    this.userId,
  });

  Map<String, dynamic> get toMap => {
        'toDoId': toDoId,
        'title': title,
        'description': description,
        'done': done,
        'date': date,
        'inTrash': inTrash,
        'userId': userId,
      };

  ToDo.fromFirebase(Map<String, dynamic> firestore)
      : toDoId = firestore['toDoId'],
        title = firestore['title'],
        description = firestore['description'],
        done = firestore['done'],
        date = firestore['date'],
        inTrash = firestore['inTrash'],
        userId = firestore['userId'];
}