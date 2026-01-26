/*
 * @Author: Km Muzahid
 * @Date: 2026-01-22 13:56:24
 * @Email: km.muzahid@gmail.com
 */
class VideoSessionModel {
  String token;
  String appId;
  String channelName;
  int uid;
  int expiration;

  VideoSessionModel({
    required this.token,
    required this.appId,
    required this.channelName,
    required this.uid,
    required this.expiration,
  });

  // Factory method to create a TokenModel from JSON
  factory VideoSessionModel.fromJson(Map<String, dynamic> json) {
    return VideoSessionModel(
      token: json['token'] ?? '',
      appId: json['appId'] ?? '',
      channelName: json['channelName'] ?? '',
      uid: json['uid'] ?? 0,
      expiration: json['expiration'] ?? 0,
    );
  }

  // Method to convert TokenModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'appId': appId,
      'channelName': channelName,
      'uid': uid,
      'expiration': expiration,
    };
  }
}
