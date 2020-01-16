class Task {
  String creatorId;
  DateTime date;
  String title;
  bool done;
  String id;

  Task({this.title, this.date, this.creatorId, this.done, this.id});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        title: map["title"],
        date: (map["date"] != null)
            ? DateTime.fromMillisecondsSinceEpoch(map["date"])
            : null,
        done: map["done"],
        creatorId: map["creatorId"],
        id: map["_id"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "date": date?.millisecondsSinceEpoch,
      "done": done,
      "creatorId": creatorId,
      "_id": id
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
