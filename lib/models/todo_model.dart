class Todo {
  String title;
  String description;
  bool isDone;

  Todo({required this.title, this.description = '', this.isDone = false});

  /// สร้าง Todo จาก JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }

  /// แปลง Todo เป็น JSON
  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'isDone': isDone};
  }
}
