/*
 * @Author: Km Muzahid
 * @Date: 2026-01-28 16:18:17
 * @Email: km.muzahid@gmail.com
 */
class TaskSummaryModel {
  final int totalTasks;
  final int totalCompletedTask;
  final int totalPendingTask;
  final int totalOverdueTask;
  final List<TaskData> data;

  TaskSummaryModel({
    required this.totalTasks,
    required this.totalCompletedTask,
    required this.totalPendingTask,
    required this.totalOverdueTask,
    required this.data,
  });

  factory TaskSummaryModel.fromMap(Map<String, dynamic> map) {
    return TaskSummaryModel(
      totalTasks: map['totalTasks'] ?? 0,
      totalCompletedTask: map['totalCompletedTask'] ?? 0,
      totalPendingTask: map['totalPendingTask'] ?? 0,
      totalOverdueTask: map['totalOverdueTask'] ?? 0,
      data: List<TaskData>.from(map['data']?.map((x) => TaskData.fromMap(x)) ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalTasks': totalTasks,
      'totalCompletedTask': totalCompletedTask,
      'totalPendingTask': totalPendingTask,
      'totalOverdueTask': totalOverdueTask,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }
}

class TaskData {
  final String day;
  final int task;

  TaskData({required this.day, required this.task});

  factory TaskData.fromMap(Map<String, dynamic> map) {
    return TaskData(day: map['day'] ?? '', task: map['task'] ?? 0);
  }

  Map<String, dynamic> toMap() {
    return {'day': day, 'task': task};
  }
}
