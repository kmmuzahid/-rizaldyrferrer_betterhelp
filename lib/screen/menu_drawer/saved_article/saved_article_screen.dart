import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_course_card/app_course_card.dart';
import 'package:flutter/material.dart';

class SavedArticleScreen extends StatelessWidget {
  const SavedArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> articleImages = [
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
        text: "Saved Articles",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          children: List.generate(articleImages.length, (index) {
            return CourseCard(
              margin: EdgeInsets.only(bottom: 10),
              cardType: CardType.article,
              title: "The Science Behind Mindfulness Meditation",
              instructor: "Dr Rizal Dy Ferrer",
              timeToread: "5 minutes to read",
              date: "12 Aug, 2024",
              imageUrl: articleImages[index],
            );
          }),
        ),
      ),
    );
  }
}
