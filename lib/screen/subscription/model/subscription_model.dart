import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionModel {
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'subtitle')
  final String? subtitle;
  @JsonKey(name: 'price')
  final int? price;
  @JsonKey(name: 'platform')
  final String? platform;
  @JsonKey(name: 'image')
  final String? image;
  @JsonKey(name: 'backgroundColor')
  final String? backgroundColor;
  @JsonKey(name: 'buttonColor')
  final String? buttonColor;
  @JsonKey(name: 'buttonTextColor')
  final String? buttonTextColor;
  @JsonKey(name: 'featureList')
  final List<String?>? featureList;
  @JsonKey(name: 'duration')
  final String? duration;
  @JsonKey(name: 'scheduleBookingCount')
  final int? scheduleBookingCount;
  @JsonKey(name: 'productId')
  final String? productId;
  @JsonKey(name: 'isActive')
  final bool? isActive;
  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;
  @JsonKey(name: '__v')
  final int? v;

  SubscriptionModel({
    this.title,
    this.subtitle,
    this.price,
    this.platform,
    this.image,
    this.backgroundColor,
    this.buttonColor,
    this.buttonTextColor,
    this.featureList,
    this.duration,
    this.scheduleBookingCount,
    this.productId,
    this.isActive,
    this.isDeleted,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}
