import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/learn_sections/categories_screen/controller/categories_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_aspect_ratio/app_aspect_ration.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoriesScreenController controller = Get.put(
      CategoriesScreenController(),
    );
    return Scaffold(
      appBar: AppBarWithBack(
        text: AppString.categories,
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          children: [
            Gap(height: 12),
            AppTextInput(
              prefixIcon: Icons.search,
              hintText: "Search categories",
              height: AppSize.height(value: 48),
              backgroundColor: AppColors.white,
              borderColor: AppColors.black10,
              borderSide: BorderSide(color: AppColors.black10),
            ),
            Gap(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: getResponsiveAspectRatio(
                  context: context,
                  ratioAdjuster: 0.170,
                ),
              ),
              itemCount: controller.categoryImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoute.trendingCourse,
                      arguments: {
                        'categoryName': controller.categoryNames[index],
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(05),
                    padding: EdgeInsets.all(05),
                    decoration: BoxDecoration(
                      color: AppColors.red50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          controller.categoryImages[index],
                          height: AppSize.height(value: 32),
                          width: AppSize.width(value: 32),
                        ),
                        Gap(height: 02),
                        AppText(
                          text: controller.categoryNames[index],
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 12),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryBlack,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
