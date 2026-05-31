import 'dart:convert';
import 'package:core_kit/storage/ck_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static StorageService get instance => _instance;
  factory StorageService() => _instance;
  StorageService._internal();

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _imageDataPrefix = 'image_';
  static const String _questionnaireResponsesKey = 'questionnaire_responses';
  static const String _questionnaireOutputKey = 'questionnaire_output';
  static const String _createUserTokenKey = 'create_user_token';
  static String get userId => '695e1c0e085dd3d8713c17f7';
  static const String _isFirstAiGeneratedKey = 'is_first_time_user';

  /// Initialize CkStorage
  Future<void> init() async {
    await CkStorage.initialize();
  }

  Future<bool?> isFirstAiTaskGenereted() async {
    final val = await CkStorage.read(_isFirstAiGeneratedKey);
    if (val == null) return null;
    return val == 'true';
  }

  Future<bool> setAiTaskGenerated(bool isFirstTimeUser) async {
    await CkStorage.write(_isFirstAiGeneratedKey, isFirstTimeUser.toString());
    return true;
  }

  // ==================== Token Management ====================

  Future<bool> saveAccessToken(String token) async {
    await CkStorage.write(_accessTokenKey, token);
    return true;
  }

  Future<String?> getAccessToken() async {
    return await CkStorage.read(_accessTokenKey);
  }

  Future<bool> saveRefreshToken(String token) async {
    await CkStorage.write(_refreshTokenKey, token);
    return true;
  }

  Future<String?> getRefreshToken() async {
    return await CkStorage.read(_refreshTokenKey);
  }

  Future<bool> removeTokens() async {
    await CkStorage.delete(_accessTokenKey);
    await CkStorage.delete(_refreshTokenKey);
    return true;
  }

  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== User Data Management ====================

  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    await CkStorage.write(_userDataKey, json.encode(userData));
    return true;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final jsonString = await CkStorage.read(_userDataKey);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<bool> removeUserData() async {
    await CkStorage.delete(_userDataKey);
    return true;
  }

  // ==================== Questionnaire Responses Management ====================

  Future<bool> saveQuestionnaireResponses(List<Map<String, dynamic>> responses) async {
    await CkStorage.write(_questionnaireResponsesKey, json.encode(responses));
    return true;
  }

  Future<List<Map<String, dynamic>>?> getQuestionnaireResponses() async {
    final jsonString = await CkStorage.read(_questionnaireResponsesKey);
    if (jsonString == null) return null;
    final decoded = json.decode(jsonString) as List;
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<bool> removeQuestionnaireResponses() async {
    await CkStorage.delete(_questionnaireResponsesKey);
    return true;
  }

  Future<bool> saveQuestionnaireOutput(Map<String, dynamic> output) async {
    await CkStorage.write(_questionnaireOutputKey, json.encode(output));
    return true;
  }

  Future<Map<String, dynamic>?> getQuestionnaireOutput() async {
    final jsonString = await CkStorage.read(_questionnaireOutputKey);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<bool> removeQuestionnaireOutput() async {
    await CkStorage.delete(_questionnaireOutputKey);
    return true;
  }

  // ==================== Create User Token Management ====================

  Future<bool> saveCreateUserToken(String token) async {
    await CkStorage.write(_createUserTokenKey, token);
    return true;
  }

  Future<String?> getCreateUserToken() async {
    return await CkStorage.read(_createUserTokenKey);
  }

  Future<bool> removeCreateUserToken() async {
    await CkStorage.delete(_createUserTokenKey);
    return true;
  }

  // ==================== Image Data Management ====================

  Future<bool> saveImageData(String imageKey, String imageData) async {
    await CkStorage.write('$_imageDataPrefix$imageKey', imageData);
    return true;
  }

  Future<String?> getImageData(String imageKey) async {
    return await CkStorage.read('$_imageDataPrefix$imageKey');
  }

  Future<bool> removeImageData(String imageKey) async {
    await CkStorage.delete('$_imageDataPrefix$imageKey');
    return true;
  }

  // ==================== Generic Storage Methods ====================

  Future<bool> saveString(String key, String value) async {
    await CkStorage.write(key, value);
    return true;
  }

  Future<String?> getString(String key) async {
    return await CkStorage.read(key);
  }

  Future<bool> saveInt(String key, int value) async {
    await CkStorage.write(key, value.toString());
    return true;
  }

  Future<int?> getInt(String key) async {
    final val = await CkStorage.read(key);
    if (val == null) return null;
    return int.tryParse(val);
  }

  Future<bool> saveBool(String key, bool value) async {
    await CkStorage.write(key, value.toString());
    return true;
  }

  Future<bool?> getBool(String key) async {
    final val = await CkStorage.read(key);
    if (val == null) return null;
    return val == 'true';
  }

  Future<bool> saveDouble(String key, double value) async {
    await CkStorage.write(key, value.toString());
    return true;
  }

  Future<double?> getDouble(String key) async {
    final val = await CkStorage.read(key);
    if (val == null) return null;
    return double.tryParse(val);
  }

  Future<bool> saveStringList(String key, List<String> value) async {
    await CkStorage.write(key, json.encode(value));
    return true;
  }

  Future<List<String>?> getStringList(String key) async {
    final val = await CkStorage.read(key);
    if (val == null) return null;
    final decoded = json.decode(val) as List;
    return decoded.map((e) => e.toString()).toList();
  }

  Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    await CkStorage.write(key, jsonEncode(json));
    return true;
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final val = await CkStorage.read(key);
    if (val == null) return null;
    return jsonDecode(val) as Map<String, dynamic>;
  }

  Future<bool> remove(String key) async {
    await CkStorage.delete(key);
    return true;
  }

  Future<bool> clearAll() async {
    await CkStorage.deleteAll();
    return true;
  }
}
