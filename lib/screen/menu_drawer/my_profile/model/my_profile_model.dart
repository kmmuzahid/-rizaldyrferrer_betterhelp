import 'dart:convert';

class Welcome {
  bool? success;
  String? message;
  Data? data;

  Welcome({this.success, this.message, this.data});

  factory Welcome.fromRawJson(String str) => Welcome.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? id;
  String? profile;
  String? fullName;
  String? email;
  String? role;
  String? phone;
  bool? isActive;
  bool? isDeleted;
  String? address;
  bool? isSubscribed;
  bool? hasAccess;
  dynamic subscriptionId;
  bool? isFreeTrial;
  dynamic assistantId;
  dynamic doctorId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? totalTask;
  int? pendingTask;
  int? completedTask;
  String? doctorChatId;

  Data({
    this.id,
    this.profile,
    this.fullName,
    this.email,
    this.role,
    this.phone,
    this.isActive,
    this.isDeleted,
    this.address,
    this.isSubscribed,
    this.hasAccess,
    this.subscriptionId,
    this.isFreeTrial,
    this.assistantId,
    this.doctorId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.totalTask,
    this.pendingTask,
    this.completedTask,
    this.doctorChatId,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    doctorChatId: json["chatId"],
    profile: json["profile"],
    fullName: json["fullName"],
    email: json["email"],
    role: json["role"],
    phone: json["phone"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    address: json["address"],
    isSubscribed: json["isSubscribed"],
    hasAccess: json["hasAccess"],
    subscriptionId: json["subscriptionId"],
    isFreeTrial: json["isFreeTrial"],
    assistantId: json["assistantId"],
    doctorId: json["doctorId"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    totalTask: json["totalTask"],
    pendingTask: json["pendingTask"],
    completedTask: json["completedTask"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "profile": profile,
    "chatId": doctorChatId,
    "fullName": fullName,
    "email": email,
    "role": role,
    "phone": phone,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "address": address,
    "isSubscribed": isSubscribed,
    "hasAccess": hasAccess,
    "subscriptionId": subscriptionId,
    "isFreeTrial": isFreeTrial,
    "assistantId": assistantId,
    "doctorId": doctorId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "totalTask": totalTask,
    "pendingTask": pendingTask,
    "completedTask": completedTask,
  };
}
