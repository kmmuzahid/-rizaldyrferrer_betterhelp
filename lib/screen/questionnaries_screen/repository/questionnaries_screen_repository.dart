import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';

class QuestionnariesScreenRepository {
  final ApiServices _apiServices = ApiServices.instance;

  Future<Map<String, dynamic>?> submitQuestionAnswers({
    required List<Map<String, String>> questionAnswers,
  }) async {
    try {
      final response = await _apiServices.apiPostServices(
        url: AppApiurl.questionAnswer,
        body: questionAnswers,
      );

      if (response != null) {
        appLog('Question answers submitted successfully');
        return response as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      appLog('Error submitting question answers: $e');
      return null;
    }
  }
}
