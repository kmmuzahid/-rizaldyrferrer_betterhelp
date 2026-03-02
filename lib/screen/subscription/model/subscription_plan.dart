/*
 * @Author: Km Muzahid
 * @Date: 2026-03-02 08:34:15
 * @Email: km.muzahid@gmail.com
 */
import 'package:flutter/material.dart';

class SubscriptionPlan {
  final String title;
  final String subtitle;
  final String image;
  final Color backgroundColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final String applePrdocutId;
  final String googleProductId;
  final List<String> featureList;

  SubscriptionPlan({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
    required this.featureList,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.applePrdocutId,
    required this.googleProductId,
  });
}
