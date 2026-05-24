class TaskResponse {
  final List<TaskModel>? data;

  TaskResponse({this.data});

  // Decoder (fromJson)
  factory TaskResponse.fromJson(dynamic json) {
    if (json == null) return TaskResponse();

    return TaskResponse(
      data: (json as List).map((e) => TaskModel.fromJson(e)).toList(),
    );
  }

  // Encoder (toJson)
  Map<String, dynamic> toJson() {
    return {'data': data?.map((e) => e.toJson()).toList()};
  }
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

  factory Meta.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Meta();

    return Meta(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPage: json['totalPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPage': totalPage,
    };
  }
}

class TaskModel {
  final String id;
  final UserModel userId;
  final String doctorId;
  final String assistantId;
  final String type;
  final List<dynamic> days;
  final String title;
  final String description;
  final String taskGoal;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String chatId;
  final String generatedTask;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.assistantId,
    required this.type,
    required this.days,
    required this.title,
    required this.description,
    required this.taskGoal,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.chatId,
    required this.generatedTask,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  TaskModel copyWith({
    String? id,
    UserModel? userId,
    String? doctorId,
    String? assistantId,
    String? type,
    List<dynamic>? days,
    String? title,
    String? description,
    String? taskGoal,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? chatId,
    String? generatedTask,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      assistantId: assistantId ?? this.assistantId,
      type: type ?? this.type,
      days: days ?? this.days,
      title: title ?? this.title,
      description: description ?? this.description,
      taskGoal: taskGoal ?? this.taskGoal,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      chatId: chatId ?? this.chatId,
      generatedTask: generatedTask ?? this.generatedTask,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'] ?? '',
      userId: UserModel.fromJson(json['userId'] ?? {}),
      doctorId: json['doctorId'] ?? '',
      assistantId: json['assistantId'] ?? '',
      type: json['type'] ?? '',
      days: json['days'] ?? [],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      taskGoal: json['taskGoal'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'] ?? '',
      chatId: json['chatId'] ?? '',
      generatedTask: json['generatedTask'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId.toJson(),
      'doctorId': doctorId,
      'assistantId': assistantId,
      'type': type,
      'days': days,
      'title': title,
      'description': description,
      'taskGoal': taskGoal,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'chatId': chatId,
      'generatedTask': generatedTask,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class UserModel {
  final String id;
  final String profile;
  final String fullName;
  final String email;
  final String role;
  final String address;

  UserModel({
    required this.id,
    required this.profile,
    required this.fullName,
    required this.email,
    required this.role,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      profile: json['profile'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profile': profile,
      'fullName': fullName,
      'email': email,
      'role': role,
      'address': address,
    };
  }
}
