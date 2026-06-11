class ExecutiveInhibitionModel {
  final String name;
  final String task;
  final String goal;
  final bool isWeekly;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> days;

  ExecutiveInhibitionModel({
    required this.name,
    required this.task,
    required this.goal,
    this.isWeekly = true,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  factory ExecutiveInhibitionModel.fromJson(Map<String, dynamic> json) {
    return ExecutiveInhibitionModel(
      name: json['name']?.toString() ?? '',
      task: json['task']?.toString() ?? '',
      goal: json['goal']?.toString() ?? '',
      isWeekly: json['type'] == 'weekly',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.parse("2026-04-28T09:00:00"),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.parse("2026-05-28T09:00:00"),
      days: json['days'] != null ? List<String>.from(json['days']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'task': task,
      'goal': goal,
      'isWeekly': isWeekly,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'days': days,
    };
  }

  ExecutiveInhibitionModel copyWith({
    String? name,
    String? task,
    String? goal,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? days,
  }) {
    return ExecutiveInhibitionModel(
      name: name ?? this.name,
      task: task ?? this.task,
      goal: goal ?? this.goal,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
    );
  }
}
