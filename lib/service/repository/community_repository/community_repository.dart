import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/community_sections/main_community/model/article_model.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_log/error_log.dart';

class CommunityRepository {
  final _apiServices = ApiServices.instance;

  //! Get all articles with pagination
  Future<ArticleModel?> getAllArticles({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching all articles...');
    appLog('CommunityRepository: Page - $page, Limit - $limit');

    try {
      final response = await _apiServices.apiGetServices(
        '${AppApiurl.getAllArticle}?page=$page&limit=$limit',
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Articles fetched successfully');
        return ArticleModel.fromJson(response);
      } else {
        appLog('CommunityRepository: Failed to fetch articles');
        return null;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during fetching articles', e);
      return null;
    }
  }

  //! Get single article by ID
  Future<Datum?> getSingleArticle(String id) async {
    appLog('CommunityRepository: Fetching article with ID - $id');

    try {
      final response = await _apiServices.apiGetServices(
        AppApiurl.getSingleArticle(id),
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Article fetched successfully');
        return Datum.fromJson(response['data']);
      } else {
        appLog('CommunityRepository: Failed to fetch article');
        return null;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during fetching article', e);
      return null;
    }
  }
}
