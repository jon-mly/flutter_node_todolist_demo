class Task {
  final String creatorId;
  final DateTime date;
  final String title;
  final bool done;

  Task({this.title, this.date, this.creatorId, this.done});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        title: map["title"],
        date: (map["date"] != null)
            ? DateTime.fromMillisecondsSinceEpoch(map["date"])
            : null,
        done: map["done"],
        creatorId: map["creatorId"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "date": date?.millisecondsSinceEpoch,
      "done": done,
      "creatorId": creatorId
    };
  }
}
