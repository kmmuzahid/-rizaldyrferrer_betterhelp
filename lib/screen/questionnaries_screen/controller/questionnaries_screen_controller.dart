import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionnariesScreenController extends GetxController {
  final PageController pageController = PageController();
  RxDouble progressValue = 1.0.obs;
  RxInt currentQuestionIndex = 0.obs;
  RxInt currentPageIndex = 0.obs;
  RxString selectedAnswer = ''.obs;

  final int totalQuestions = 25; 
  final int totalSteps = 5;
  final int totalPages = 6;

  // Answer options
  final List<String> answerOptions = ['rarely', 'frequently', 'sometimes'];

  // Store answers for all questions
  RxMap<int, String> answers = <int, String>{}.obs;

  // Store selected options for multi-select questions (like page 5)
  RxList<int> selectedOptions = <int>[].obs;

  void selectAnswer(String answer) {
    selectedAnswer.value = answer;
    answers[currentQuestionIndex.value] = answer;
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

  void nextQuestion() {
    if (currentQuestionIndex.value < totalQuestions - 1) {
      currentQuestionIndex.value++;
      selectedAnswer.value = answers[currentQuestionIndex.value] ?? '';
      updateProgress();
    } else {
      completeQuestionnaire();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      selectedAnswer.value = answers[currentQuestionIndex.value] ?? '';
      updateProgress();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      currentQuestionIndex.value = index;
      selectedAnswer.value = answers[index] ?? '';
      updateProgress();
    }
  }

  void updateProgress() {
    // Progress based on current page (1-5 scale for 5 steps)
    int currentStep = currentPageIndex.value + 1;
    progressValue.value = currentStep.toDouble();
  }

  void completeQuestionnaire() {
    appLog('Questionnaire completed with ${answers.length} answers');
    // Process answers and navigate to next screen
    _processAnswers();
  }

  void _processAnswers() {
    // Process all answers here
    answers.forEach((questionIndex, answer) {
      appLog('Question ${questionIndex + 1}: $answer');
    });
  }

  String getCurrentStepText() {
    int currentStep = currentPageIndex.value + 1;
    return '$currentStep/$totalPages';
  }

  String getCurrentQuestionText() {
    return '${currentQuestionIndex.value + 1}/$totalQuestions';
  }

  bool isAnswerSelected(String answer) {
    return selectedAnswer.value == answer;
  }

  bool isQuestionAnswered(int questionIndex) {
    return answers.containsKey(questionIndex);
  }

  double getCompletionPercentage() {
    return (answers.length / totalQuestions) * 100;
  }

  // Methods for multi-select options (page 5)
  void toggleOption(int index) {
    if (selectedOptions.contains(index)) {
      selectedOptions.remove(index);
    } else {
      selectedOptions.add(index);
    }
  }

  void clearSelectedOptions() {
    selectedOptions.clear();
  }

  bool isOptionSelected(int index) {
    return selectedOptions.contains(index);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
