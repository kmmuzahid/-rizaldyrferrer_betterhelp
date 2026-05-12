// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      price: (json['price'] as num?)?.toInt(),
      platform: json['platform'] as String?,
      image: json['image'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      buttonColor: json['buttonColor'] as String?,
      buttonTextColor: json['buttonTextColor'] as String?,
      featureList: (json['featureList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      duration: json['duration'] as String?,
      scheduleBookingCount: (json['scheduleBookingCount'] as num?)?.toInt(),
      productId: json['productId'] as String?,
      isActive: json['isActive'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: (json['__v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'price': instance.price,
      'platform': instance.platform,
      'image': instance.image,
      'backgroundColor': instance.backgroundColor,
      'buttonColor': instance.buttonColor,
      'buttonTextColor': instance.buttonTextColor,
      'featureList': instance.featureList,
      'duration': instance.duration,
      'scheduleBookingCount': instance.scheduleBookingCount,
      'productId': instance.productId,
      'isActive': instance.isActive,
      'isDeleted': instance.isDeleted,
      '_id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '__v': instance.v,
    };
