import 'dart:convert';

class ProfileData {
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
  String? subscriptionPackageId;
  DateTime? subscriptionExpiredDate;
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
  String? subscriptionPlanType;
  bool isAiGenerated;

  ProfileData({
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
    this.subscriptionPackageId,
    this.subscriptionExpiredDate,
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
    this.subscriptionPlanType,
    this.isAiGenerated = false,
  });

  ProfileData copyWith({
    String? id,
    String? profile,
    String? fullName,
    String? email,
    String? role,
    String? phone,
    bool? isActive,
    bool? isDeleted,
    String? address,
    bool? isSubscribed,
    bool? hasAccess,
    String? subscriptionPackageId,
    DateTime? subscriptionExpiredDate,
    bool? isFreeTrial,
    dynamic assistantId,
    dynamic doctorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    int? totalTask,
    int? pendingTask,
    int? completedTask,
    String? doctorChatId,
    String? subscriptionPlanType,
    bool? isAiGenerated,
  }) {
    return ProfileData(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      address: address ?? this.address,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      hasAccess: hasAccess ?? this.hasAccess,
      subscriptionPackageId:
          subscriptionPackageId ?? this.subscriptionPackageId,
      subscriptionExpiredDate:
          subscriptionExpiredDate ?? this.subscriptionExpiredDate,
      isFreeTrial: isFreeTrial ?? this.isFreeTrial,
      assistantId: assistantId ?? this.assistantId,
      doctorId: doctorId ?? this.doctorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      totalTask: totalTask ?? this.totalTask,
      pendingTask: pendingTask ?? this.pendingTask,
      completedTask: completedTask ?? this.completedTask,
      doctorChatId: doctorChatId ?? this.doctorChatId,
      subscriptionPlanType: subscriptionPlanType ?? this.subscriptionPlanType,
      isAiGenerated: isAiGenerated ?? this.isAiGenerated,
    );
  }

  factory ProfileData.fromRawJson(String str) =>
      ProfileData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileData.fromJson(dynamic json) => ProfileData(
    isAiGenerated: json["isAiGenerated"] ?? false,
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
    subscriptionPackageId:
        json["subscriptionPackageId"] ?? json["subscriptionId"],
    subscriptionExpiredDate: json["subscriptionExpiredDate"] == null
        ? null
        : DateTime.tryParse(json["subscriptionExpiredDate"]),
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
    subscriptionPlanType: json["subscriptionPlanType"],
  );

  Map<String, dynamic> toJson() => {
    "isAiGenerated": isAiGenerated,
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
    "subscriptionId": subscriptionPackageId,
    "isFreeTrial": isFreeTrial,
    "assistantId": assistantId,
    "doctorId": doctorId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "totalTask": totalTask,
    "pendingTask": pendingTask,
    "completedTask": completedTask,
    "subscriptionPlanType": subscriptionPlanType,
  };
}
