import 'package:better_help/utils/app_images/app_images.dart';
import 'package:get/get.dart';

class TrendingCourseController extends GetxController {
  // Trending courses data
  List<String> get trendingCourseImages => [
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
  ];

  List<String> get trendingCourseTitles => [
    "Overcoming Workplace Anxiety",
    "Building Healthy Relationships",
    "Stress Management Techniques",
    "Self-Care Development",
    "Mindfulness and Meditation",
    "Emotional Intelligence",
    "Time Management Skills",
    "Communication Mastery",
    "Confidence Building",
    "Work-Life Balance",
  ];

  List<String> get trendingCourseInstructors => [
    "Dr. Rizaldy Ferrer",
    "Dr. Sarah Johnson",
    "Dr. Michael Chen",
    "Dr. Emily Davis",
    "Dr. James Wilson",
    "Dr. Lisa Anderson",
    "Dr. Robert Taylor",
    "Dr. Maria Garcia",
    "Dr. David Brown",
    "Dr. Jennifer Lee",
  ];

  List<double> get trendingCourseRatings => [
    4.3,
    4.5,
    4.2,
    4.7,
    4.1,
    4.6,
    4.4,
    4.8,
    4.0,
    4.5,
  ];

  List<String> get trendingCourseViews => [
    "2,453 View",
    "3,821 View",
    "1,967 View",
    "4,102 View",
    "2,876 View",
    "3,245 View",
    "1,654 View",
    "5,123 View",
    "2,098 View",
    "3,567 View",
  ];
}
