import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_course_card/app_course_card.dart';
import 'package:flutter/material.dart';

class FavoriteCourseScreen extends StatelessWidget {
  const FavoriteCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> courseImages = [
      AppStaticImages.habits01,
      AppStaticImages.habits02,
      AppStaticImages.habits03,
      AppStaticImages.habits04,
      AppStaticImages.habits01,
      AppStaticImages.habits02,
      AppStaticImages.habits03,
      AppStaticImages.habits04,
      AppStaticImages.habits01,
      AppStaticImages.habits02,
      AppStaticImages.habits03,
      AppStaticImages.habits04,
      AppStaticImages.habits01,
      AppStaticImages.habits02,
      AppStaticImages.habits03,
      AppStaticImages.habits04,
    ];
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Favorite Course",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          children: List.generate(courseImages.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CourseCard(
                margin: EdgeInsets.only(bottom: 10),
                cardType: CardType.course,
                height: AppSize.height(value: 247),
                title: "The Science Behind Mindfulness Meditation",
                instructor: "Dr Rizal Dy Ferrer",
                rating: 4.5,
                imageUrl: courseImages[index],
              ),
            );
          }),
        ),
      ),
    );
  }
}
