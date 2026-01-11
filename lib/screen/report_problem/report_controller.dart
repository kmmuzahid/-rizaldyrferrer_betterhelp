/*
 * @Author: Km Muzahid
 * @Date: 2026-01-10 16:01:41
 * @Email: km.muzahid@gmail.com
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  // Selected category state
  var selectedCategory = "".obs;

  var report = '';

  // Controller for the multi-line text field
  final TextEditingController descriptionController = TextEditingController();

  // List of categories for the dropdown
  final List<String> categories = [
    "Technical Issue",
    "Account Problem",
    "Billing/Payment",
    "App Feedback",
    "Other",
  ];

  void setCategory(String? value) {
    if (value != null) selectedCategory.value = value;
  }

  void submitReport() {
    if (report.isNotEmpty) {}
  }

  @override
  void onClose() {
    descriptionController.dispose(); // Always dispose controllers
    super.onClose();
  }
}
