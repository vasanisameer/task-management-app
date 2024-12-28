class Task {
  int? id;
  String title;
  String description;
  String status;
  DateTime dueDate;

  Task({this.id, required this.title, required this.description, required this.status, required this.dueDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      dueDate: DateTime.parse(map['dueDate']),
    );
  }
}
