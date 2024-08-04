class Task {
  final int? id;
  final String title;
  final String subtitle;
  final String description;
  final int? userId;
  final DateTime dueDate;
  int isCompleted;

  Task({
    this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.userId,
    required this.dueDate,
    this.isCompleted = 0
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'userId': userId,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, subtitle: $subtitle, description: $description, userId: $userId, isCompleted: $isCompleted}';
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      description: map['description'],
      userId: map['userId'],
      isCompleted: map['isCompleted'],
      dueDate: DateTime.parse(map['dueDate']),
    );
  }
}