import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionnariesScreenController extends GetxController {
  final PageController pageController = PageController();
  RxDouble progressValue = 1.0.obs;
  RxInt currentPageIndex = 0.obs;

  // Configuration
  static const int questionsPerPage = 5;
  static const int totalQuestionPages = 3;
  static const int totalPages =
      5; // 3 question pages + 1 goals page + 1 result page

  // Store answers for all questions (key: questionNumber, value: answer)
  RxMap<int, String> answers = <int, String>{}.obs;

  // Questions data organized by page
  final List<List<String>> questionsByPage = [
    // Page 1 - Questions 1-5
    [
      AppString.question1,
      AppString.question2,
      AppString.question3,
      AppString.question4,
      AppString.question5,
    ],
    // Page 2 - Questions 6-10
    [
      AppString.question6,
      AppString.question7,
      AppString.question8,
      AppString.question9,
      AppString.question10,
    ],
    // Page 3 - Questions 11-15
    [
      AppString.question11,
      AppString.question12,
      AppString.question1, // Reusing for demo - replace with question13
      AppString.question2, // Reusing for demo - replace with question14
      AppString.question3, // Reusing for demo - replace with question15
    ],
  ];

  int get totalQuestions =>
      questionsByPage.fold(0, (sum, page) => sum + page.length);

  void selectAnswer(int questionNumber, String answer) {
    answers[questionNumber] = answer;
  }

  bool isAnswerSelected(int questionNumber, String answer) {
    return answers[questionNumber] == answer;
  }

  void nextPage() {
    if (currentPageIndex.value < totalPages - 1) {
      currentPageIndex.value++;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      updateProgress();
    } else {
      completeQuestionnaire();
    }
  }

  void previousPage() {
    if (currentPageIndex.value > 0) {
      currentPageIndex.value--;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      updateProgress();
    }
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
    updateProgress();
  }

  void updateProgress() {
    progressValue.value = (currentPageIndex.value + 1).toDouble();
  }

  void completeQuestionnaire() {
    appLog('Questionnaire completed with ${answers.length} answers');
    _processAnswers();
    Get.offNamed(AppRoute.subscriptionscreen);
  }

  void _processAnswers() {
    answers.forEach((questionNumber, answer) {
      appLog('Question $questionNumber: $answer');
    });
  }

  String getCurrentStepText() {
    int currentStep = currentPageIndex.value + 1;
    return '$currentStep/$totalPages';
  }

  double getCompletionPercentage() {
    return (answers.length / totalQuestions) * 100;
  }

  bool get isResultPage => currentPageIndex.value == totalPages - 1;
  bool get isGoalsPage => currentPageIndex.value == totalPages - 2;
  bool get isLastQuestionPage =>
      currentPageIndex.value == totalQuestionPages - 1;

  // Goals page multi-select options
  RxList<int> selectedGoals = <int>[].obs;

  // Scale selection (1-10) for result page
  RxnInt selectedScaleNumber = RxnInt(null);

  void selectScaleNumber(int number) {
    selectedScaleNumber.value = number;
  }

  bool isScaleNumberSelected(int number) => selectedScaleNumber.value == number;

  final List<String> goalOptions = [
    AppString.buildingBetterHabits,
    AppString.boostingProductivity,
    AppString.stayingActiveandEngergized,
    AppString.sharperningFocus,
    AppString.strengtheingDiscipline,
    AppString.livingMoreMidfully,
    AppString.mangingTimeBetter,
    AppString.reducingOverwhelm,
    AppString.followingThoughonGoals,
    AppString.feelingEmotionallyBalanced,
    AppString.improvingSelfawreness,
    AppString.creatingAhealthierRoutine,
  ];

  void toggleGoal(int index) {
    if (selectedGoals.contains(index)) {
      selectedGoals.remove(index);
    } else {
      selectedGoals.add(index);
    }
  }

  bool isGoalSelected(int index) => selectedGoals.contains(index);

  @override
  void onClose() {
    pageController.dispose();
    answers.clear();
    selectedGoals.clear();
    selectedScaleNumber.value = null;
    super.onClose();
  }
}
