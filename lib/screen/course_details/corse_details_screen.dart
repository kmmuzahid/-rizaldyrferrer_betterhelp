import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/course_details_control.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final CourseDetailsController controller = Get.put(CourseDetailsController());

    return Scaffold(
      appBar: AppBarWithBack(text: "Course Details", backgroundColor: AppColors.white),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(controller),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(controller),
                      const SizedBox(height: 20),
                      const CommonText(
                        text: 'Description',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      _buildDescription(controller),
                      const SizedBox(height: 24),
                      const CommonText(
                        text: 'Review & Rating',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      _buildRatingSection(controller),
                      const SizedBox(height: 30),
                      _buildFeedbackButton(controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Sub-Widgets ---

  Widget _buildHeader(CourseDetailsController controller) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 250,
        maxWidth: double.infinity,
        minWidth: double.infinity,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (controller.isPlay.value == false) ...[
            CommonImage(
              src: controller.courseDetails.value?.data.thumbnail ?? '',
              height: 250,
              width: double.infinity,
            ),
            GestureDetector(
              onTap: () {
                controller.playNow();
              },
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.teal.withOpacity(0.8),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
              ),
            ),
          ],
          if (controller.isPlay.value)
            BetterPlayer(controller: controller.betterPlayerController.value!),
        ],
      ),
    );
  }

  Widget _buildTitleSection(CourseDetailsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CommonText(
                text: controller.courseDetails.value?.data.title ?? '',
                maxLines: 2,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
             
            _badge(Icons.access_time, controller.videoDuration.value)
  
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CommonText(
              text: controller.courseDetails.value?.data.categoryName ?? '',
              style: const TextStyle(color: Colors.grey, fontSize: 18),
            ),
            10.width,
            _buildInfoBadges(controller),
          ],
        ),
      ],
    );
  }

 

  Widget _buildDescription(CourseDetailsController controller) {
    return Obx(
      () => CommonText(
        text: controller.courseDetails.value?.data.description ?? '',
        isDescription: true,
        textAlign: TextAlign.left,
        style: const TextStyle(color: Colors.grey, height: 1.4),
      ),
    );
  }

  Widget _buildRatingSection(CourseDetailsController controller) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              ...(controller.courseDetails.value?.reviewRating.map(
                    (e) => _ratingBar(e.rating, e.count),
                  ) ??
                  []),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Column(
          children: [
            Row(
              children: [
                Obx(
                  () => Text(
                    '${controller.courseDetails.value?.data.ratings ?? 0}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.star, color: Colors.orange, size: 28),
              ],
            ),
            Obx(
              () => Text(
                '${controller.courseDetails.value?.data.reviews ?? 0} Reviews',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedbackButton(CourseDetailsController controller) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF33A1B3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          controller.selectedRating.value = 3;
          showFeedbackSheet(controller);
        }, // State change test
        child: const Text('Give Feedback', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  // --- Helpers ---

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoBadges(CourseDetailsController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _badge(
          Icons.access_time,
          (controller.courseDetails.value?.data.createdAt ?? DateTime.now()).checkTime,
        ),
        10.width,
        _badge(
          Icons.people_outline,
          '${controller.courseDetails.value?.data.viewUsers.length} views',
        ),
      ],
    );
  }

  Widget _badge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.blue, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _ratingBar(int star, int val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$star', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: val.toDouble(),
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Colors.orange),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  void showFeedbackSheet(CourseDetailsController controller) {
    // Use Get.bottomSheet instead of showBottomSheet
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The grey handle at the top
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Submit your Feedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your feedback helps us improve this course.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            10.height,
            CommonMultilineTextField(
              height: 80,
              hintText: 'Write your feedback',
              backgroundColor: Colors.white70.withAlpha(50),
              validationType: ValidationType.notRequired,
              onChanged: (value) {
                controller.reviewController.text = value;
              },
            ),

            // Star Rating Row
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    // Remove Navigator.pop from here;
                    // the user should be able to change their mind before clicking 'Send'
                    onPressed: () => controller.updateRating(index + 1),
                    icon: Icon(
                      Icons.star_rounded,
                      color: index < controller.selectedRating.value
                          ? Colors.amber
                          : Colors.grey[300],
                      size: 48,
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 32),

            // Send Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33A1B3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  controller.submitFeedback();
                  Get.back(); // This closes the bottom sheet after submission
                },
                child: const Text('Send', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      // Allows the sheet to adjust if you later add a keyboard/TextField
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
