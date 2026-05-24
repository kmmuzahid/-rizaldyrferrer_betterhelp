import 'package:json_annotation/json_annotation.dart';

part 'payment_verification_model.g.dart';

@JsonSerializable()
class PaymentVerificationModel {
  @JsonKey(name: 'active')
  final bool? active;
  @JsonKey(name: 'message')
  final String? message;

  PaymentVerificationModel({
    this.active,
    this.message,
  });

  factory PaymentVerificationModel.fromJson(Map<String, dynamic> json) => _$PaymentVerificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentVerificationModelToJson(this);
}