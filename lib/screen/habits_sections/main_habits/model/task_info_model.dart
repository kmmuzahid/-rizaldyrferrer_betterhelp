class ExecutiveInhibitionModel {
  final String name;
  final String task;
  final String goal;
  final bool isWeekly;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final List<String> days;

  ExecutiveInhibitionModel({
    required this.name,
    required this.task,
    required this.goal,
    required this.isWeekly,
    required this.startDate,
    required this.endDate,
    required this.type,
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
      type: json['type']?.toString() ?? 'daily',
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
      'type': type,
      'days': days,
    };
  }

  ExecutiveInhibitionModel copyWith({
    String? name,
    String? task,
    String? goal,
    bool? isWeekly,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    List<String>? days,
  }) {
    return ExecutiveInhibitionModel(
      name: name ?? this.name,
      task: task ?? this.task,
      goal: goal ?? this.goal,
      isWeekly: isWeekly ?? this.isWeekly,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      days: days ?? this.days,
    );
  }
}
