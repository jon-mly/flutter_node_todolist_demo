class User {
  final String username;
  final String id;
  final String token;

  User({this.username, this.id, this.token});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(username: map["username"], id: map["_id"], token: map["token"]);
  }

  Map<String, dynamic> toMap() {
    return {"username": username, "_id": id, "token": token};
  }
}
