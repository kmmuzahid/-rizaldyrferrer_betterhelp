class TaskResponse {
  final bool? success;
  final String? message;
  final Meta? meta;
  final List<TaskData>? data;

  TaskResponse({
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  // Decoder (fromJson)
  factory TaskResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TaskResponse();
    
    return TaskResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => TaskData.fromJson(e)).toList()
          ? (json['data'] as List).map((item) => TaskData.fromJson(item)).toList()
          : null,
    );
  }

  // Encoder (toJson)
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'meta': meta?.toJson(),
      'data': data?.map((e) => e.toJson()).toList(),
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  // Decoder (fromJson)
  factory Meta.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Meta();
    
    return Meta(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPage: json['totalPage'] as int?,
    );
  }

  // Encoder (toJson)
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPage': totalPage,
    };
  }
}

class TaskData {
  final String? id;
  final UserInfo? userId;
  final User? userId;
  final String? doctorBookingId;
  final String? doctorId;
  final String? assistantId;
  final String? title;
  final String? description;
  final String? categoryId;
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final String? chatId;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskData({
    this.id,
    this.userId,
    this.doctorBookingId,
    this.doctorId,
    this.assistantId,
    this.title,
    this.description,
    this.categoryId,
    this.category,
    this.startDate,
    this.endDate,
    this.status,
    this.chatId,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  // Decoder (fromJson)
  factory TaskData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TaskData();
    
    return TaskData(
      id: json['_id'] as String?,
      userId: json['userId'] != null ? UserInfo.fromJson(json['userId']) : null,
      userId: json['userId'] != null ? User.fromJson(json['userId']) : null,
      doctorBookingId: json['doctorBookingId'] as String?,
      doctorId: json['doctorId'] as String?,
      assistantId: json['assistantId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String?,
      category: json['category'] as String?,
      startDate: json['startDate'] != null 
          ? DateTime.tryParse(json['startDate']) 
          : null,
      endDate: json['endDate'] != null 
          ? DateTime.tryParse(json['endDate']) 
          : null,
      status: json['status'] as String?,
      chatId: json['chatId'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt']) 
          : null,
    );
  }

  // Encoder (toJson)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId?.toJson(),
      'doctorBookingId': doctorBookingId,
      'doctorId': doctorId,
      'assistantId': assistantId,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'category': category,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'chatId': chatId,
      'isDeleted': isDeleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class UserInfo {
class User {
  final String? id;
  final String? profile;
  final String? fullName;
  final String? email;
  final String? role;
  final String? address;

  UserInfo({
  User({
    this.id,
    this.profile,
    this.fullName,
    this.email,
    this.role,
    this.address,
  });

  factory UserInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserInfo();
    
    return UserInfo(
  // Decoder (fromJson)
  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return User();
    
    return User(
      id: json['_id'] as String?,
      profile: json['profile'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      address: json['address'] as String?,
    );
  }

  // Encoder (toJson)
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