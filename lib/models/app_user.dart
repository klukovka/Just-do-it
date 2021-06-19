class AppUser {
  String? userId;
  String? name;
  String? auth;

  AppUser({this.userId, this.name, this.auth});

  Map<String, dynamic> get toMap =>
      {'userId': userId, 'name': name, 'auth': auth};

  AppUser.fromFirebase(Map<String, dynamic> firestore)
      : userId = firestore['userId'],
        name = firestore['name'],
        auth = firestore['auth'];
}
