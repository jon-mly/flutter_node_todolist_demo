class User {
  final String username;
  final String id;

  User({this.username, this.id});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(username: map["username"], id: map["id"]);
  }

  Map<String, dynamic> toMap() {
    return {"username": username, "id": id};
  }
}
