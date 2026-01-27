/*
 * @Author: Km Muzahid
 * @Date: 2026-01-27 12:06:27
 * @Email: km.muzahid@gmail.com
 */
import 'package:core_kit/core_kit.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String message;
  final String type;
  final String status;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.type,
    required this.status,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? message,
    String? type,
    String? status,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      type: type ?? this.type,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Factory method to create Notification from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: CoreUtils.parseDate(json['createdAt']),
      updatedAt: CoreUtils.parseDate(json['updatedAt']),
    );
  }

  // Method to convert Notification to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'message': message,
      'type': type,
      'status': status,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
