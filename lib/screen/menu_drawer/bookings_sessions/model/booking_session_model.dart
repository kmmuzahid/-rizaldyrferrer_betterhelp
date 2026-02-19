class User {
  String id;
  String profile;
  String fullName;
  String email;
  String role;

  User({
    required this.id,
    required this.profile,
    required this.fullName,
    required this.email,
    required this.role,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      profile: json['profile'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {'_id': id, 'profile': profile, 'fullName': fullName, 'email': email, 'role': role};
  }
}

class BookedSessionModel {
  String id;
  User userId;
  User doctorId;
  User assistantId; 
  DateTime startTime;
  DateTime endTime;
  int scheduledDuration;
  String status;
  String channelName;

  BookedSessionModel({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.assistantId, 
    required this.startTime,
    required this.endTime,
    required this.scheduledDuration,
    required this.status,
    required this.channelName,
  });

  // Factory method to create a BookedSessionModel from JSON
  factory BookedSessionModel.fromJson(Map<String, dynamic> json) {
    return BookedSessionModel(
      id: json['_id'] ?? '',
      userId: User.fromJson(json['userId'] ?? {}),
      doctorId: User.fromJson(json['doctorId'] ?? {}),
      assistantId: User.fromJson(json['assistantId'] ?? {}), 
      startTime: DateTime.parse(json['startTime'] ?? '1970-01-01T00:00:00.000Z'),
      endTime: DateTime.parse(json['endTime'] ?? '1970-01-01T00:00:00.000Z'),
      scheduledDuration: json['scheduledDuration'] ?? 0,
      status: json['status'] ?? 'pending',
      channelName: json['channelName'] ?? '',
    );
  }

  // Method to convert BookedSessionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId.toJson(),
      'doctorId': doctorId.toJson(),
      'assistantId': assistantId.toJson(), 
      'startTime': startTime,
      'endTime': endTime,
      'scheduledDuration': scheduledDuration,
      'status': status,
      'channelName': channelName,
    };
  }
}
