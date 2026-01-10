/*
 * @Author: Km Muzahid
 * @Date: 2026-01-10 16:02:17
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/report_problem/report_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportProblemScreen extends StatelessWidget {
  final ReportController controller = Get.put(ReportController());

  ReportProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report a Problem", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Write down the problem you are facing"),
            const SizedBox(height: 8),
            CommonMultilineTextField(
              height: 150,
              backgroundColor: AppColors.white,
              hintText: "Type something...",
              validationType: ValidationType.validateRequired,
              onChanged: (value) {
                controller.report = value;
              },
            ),
            50.height,
            _buildSubmitButton(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff309AAD), // Matching the original teal theme
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: controller.submitReport,
        child: const Text("Send Message", style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
