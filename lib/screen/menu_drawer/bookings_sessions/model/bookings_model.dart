class BookingsResponse {
  final bool? success;
  final String? message;
  final BookingMeta? meta;
  final List<BookingsModel>? data;

  BookingsResponse({
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  // Decoder (fromJson)
  factory BookingsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BookingsResponse();
    
    return BookingsResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      meta: json['meta'] != null ? BookingMeta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? (json['data'] as List).map((item) => BookingsModel.fromJson(item)).toList()
          : null,
    );
  }

  // Encoder (toJson)
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'meta': meta?.toJson(),
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class BookingMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  BookingMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  // Decoder (fromJson)
  factory BookingMeta.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BookingMeta();
    
    return BookingMeta(
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

class BookingsModel {
  final String? id;
  final BookingUser? userId;
  final String? doctorId;
  final String? assistantId;
  final DateTime? bookingDate;
  final String? startTime;
  final String? endTime;
  final int? scheduledDuration;
  final String? status;
  final String? channelName;

  BookingsModel({
    this.id,
    this.userId,
    this.doctorId,
    this.assistantId,
    this.bookingDate,
    this.startTime,
    this.endTime,
    this.scheduledDuration,
    this.status,
    this.channelName,
  });

  // Decoder (fromJson)
  factory BookingsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BookingsModel();
    
    return BookingsModel(
      id: json['_id'] as String?,
      userId: json['userId'] != null ? BookingUser.fromJson(json['userId']) : null,
      doctorId: json['doctorId'] as String?,
      assistantId: json['assistantId'] as String?,
      bookingDate: json['bookingDate'] != null 
          ? DateTime.tryParse(json['bookingDate']) 
          : null,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      scheduledDuration: json['scheduledDuration'] as int?,
      status: json['status'] as String?,
      channelName: json['channelName'] as String?,
    );
  }

  // Encoder (toJson)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId?.toJson(),
      'doctorId': doctorId,
      'assistantId': assistantId,
      'bookingDate': bookingDate?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'scheduledDuration': scheduledDuration,
      'status': status,
      'channelName': channelName,
    };
  }
}

class BookingUser {
  final String? id;
  final String? profile;
  final String? fullName;
  final String? email;
  final String? role;

  BookingUser({
    this.id,
    this.profile,
    this.fullName,
    this.email,
    this.role,
  });

  // Decoder (fromJson)
  factory BookingUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BookingUser();
    
    return BookingUser(
      id: json['_id'] as String?,
      profile: json['profile'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
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
    };
  }
}