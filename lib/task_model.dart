class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.isCompleted = false,
  });

  // Allows toggling states while keeping other properties intact
  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      title: title,
      description: description,
      dateTime: dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}