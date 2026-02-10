import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/questionnaries_screen/repository/questionnaries_screen_repository.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:core_kit/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionnariesScreenController extends GetxController {
  final PageController pageController = PageController();
  final QuestionnariesScreenRepository _repository = QuestionnariesScreenRepository();
  final StorageService _storageService = StorageService();

  RxDouble progressValue = 1.0.obs;
  RxInt currentPageIndex = 0.obs;
  RxBool isLoading = false.obs;

  // API response data
  Rxn<Map<String, dynamic>> apiResponseData = Rxn<Map<String, dynamic>>();

  // Configuration
  static const int questionsPerPage = 5;
  static const int totalQuestionPages = 3;
  static const int totalPages = 5; // 3 question pages + 1 goals page + 1 result page

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

  int get totalQuestions => questionsByPage.fold(0, (sum, page) => sum + page.length);

  void selectAnswer(int questionNumber, String answer) {
    answers[questionNumber] = answer;
  }

  bool isAnswerSelected(int questionNumber, String answer) {
    return answers[questionNumber] == answer;
  }

  void nextPage() { 
    if ((currentPageIndex.value == 0 && answers.length < 5) ||
        (currentPageIndex.value == 1 && answers.length < 10) ||
        (currentPageIndex.value == 2 && answers.length < 15)) {
      showSnackBar("Please answer all questions", type: SnackBarType.warning);
      return;
    }
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

  Future<void> completeQuestionnaire() async {
    appLog('Questionnaire completed with ${answers.length} answers');
    await _submitAnswersToApi();
  }

  List<Map<String, String>> _buildApiPayload() {
    final List<Map<String, String>> payload = [];

    // Add 15 question answers
    for (int pageIndex = 0; pageIndex < questionsByPage.length; pageIndex++) {
      final questions = questionsByPage[pageIndex];
      for (int i = 0; i < questions.length; i++) {
        final questionNumber = pageIndex * questionsPerPage + i + 1;
        final answer = answers[questionNumber] ?? '';
        payload.add({'questions': questions[i], 'questionOutput': answer});
      }
    }

    // Add goals question
    final selectedGoalsList = selectedGoals.map((index) => goalOptions[index]).toList();
    payload.add({
      'questions': AppString.whatdoYouwanttoAchieve,
      'questionOutput': selectedGoalsList.join(', '),
    });

    // Add scale question
    payload.add({
      'questions': AppString.resultQuestion,
      'questionOutput': selectedScaleNumber.value?.toString() ?? '',
    });

    return payload;
  }

  /// Build responses payload for OTP verification API
  List<Map<String, dynamic>> _buildResponsesForOtp() {
    final List<Map<String, dynamic>> responses = [];

    // Add 15 question answers
    for (int pageIndex = 0; pageIndex < questionsByPage.length; pageIndex++) {
      final questions = questionsByPage[pageIndex];
      for (int i = 0; i < questions.length; i++) {
        final questionNumber = pageIndex * questionsPerPage + i + 1;
        final answer = answers[questionNumber] ?? '';
        responses.add({'question': questions[i], 'answer': answer});
      }
    }

    // Add goals question with list of selected goals
    final selectedGoalsList = selectedGoals.map((index) => goalOptions[index]).toList();
    responses.add({'question': AppString.whatdoYouwanttoAchieve, 'answer': selectedGoalsList});

    // Add scale question
    responses.add({'question': AppString.resultQuestion, 'answer': selectedScaleNumber.value ?? 0});

    return responses;
  }

  /// Save questionnaire responses and output to storage for OTP verification
  Future<void> _saveResponsesToStorage() async {
    try {
      final responses = _buildResponsesForOtp();
      await _storageService.saveQuestionnaireResponses(responses);
      appLog('QuestionnariesController: Responses saved to storage');
      appLog('QuestionnariesController: Saved responses - $responses');
    } catch (e) {
      appLog('QuestionnariesController: Error saving responses - $e');
    }
  }

  /// Save questionnaire output (API response) to storage
  Future<void> _saveOutputToStorage(Map<String, dynamic> output) async {
    try {
      await _storageService.saveQuestionnaireOutput(output);
      appLog('QuestionnariesController: Output saved to storage');
      appLog('QuestionnariesController: Saved output - $output');
    } catch (e) {
      appLog('QuestionnariesController: Error saving output - $e');
    }
  }

  Future<void> _submitAnswersToApi() async {
    isLoading.value = true;

    try {
      final payload = _buildApiPayload();
      appLog('Submitting payload: $payload');

      // Save responses to storage for OTP verification
      await _saveResponsesToStorage();

      final response = await _repository.submitQuestionAnswers(questionAnswers: payload);

      if (response != null && response['success'] == true) {
        apiResponseData.value = response['data'];
        appLog('API Response: ${response['data']}');

        // Save both responses and output to storage for OTP verification
        await _saveResponsesToStorage();
        await _saveOutputToStorage(response['data']);

        Get.offNamed(AppRoute.questionnaireSummaryScreen, arguments: response['data']);
      } else {
        AppSnackBar.showError('Failed to submit answers. Please try again.');
      }
    } catch (e) {
      appLog('Error submitting answers: $e');
      AppSnackBar.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  String getCurrentStepText() {
    int currentStep = currentPageIndex.value + 1;
    return '$currentStep/${totalPages - 1}';
  }

  double getCompletionPercentage() {
    return (answers.length / totalQuestions) * 100;
  }

  bool get isResultPage => currentPageIndex.value == totalPages - 1;
  bool get isGoalsPage => currentPageIndex.value == totalPages - 2;
  bool get isLastQuestionPage => currentPageIndex.value == totalQuestionPages - 1;

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
