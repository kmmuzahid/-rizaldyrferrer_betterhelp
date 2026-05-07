import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static StorageService get instance => _instance;
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _imageDataPrefix = 'image_';
  static const String _questionnaireResponsesKey = 'questionnaire_responses';
  static const String _questionnaireOutputKey = 'questionnaire_output';
  static const String _createUserTokenKey = 'create_user_token';
  static String get userId => '695e1c0e085dd3d8713c17f7';
  static const String _isFirstTimeUserKey = 'is_first_time_user';
  //static const String _settingsKey = 'app_settings';

  /// Check if user is first time user

  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  Future<bool?> getIsFirstTimeUser() async {
    final prefs = await _preferences;
    return prefs.getBool(_isFirstTimeUserKey);
  }

  /// Save user is first time user status
  Future<bool> setIsFirstTimeUser(bool isFirstTimeUser) async {
    final prefs = await _preferences;
    return await prefs.setBool(_isFirstTimeUserKey, isFirstTimeUser);
  }

  // ==================== Token Management ====================

  /// Save access token
  Future<bool> saveAccessToken(String token) async {
    final prefs = await _preferences;
    return await prefs.setString(_accessTokenKey, token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    final prefs = await _preferences;
    return prefs.getString(_accessTokenKey);
  }

  /// Save refresh token
  Future<bool> saveRefreshToken(String token) async {
    final prefs = await _preferences;
    return await prefs.setString(_refreshTokenKey, token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await _preferences;
    return prefs.getString(_refreshTokenKey);
  }

  /// Remove tokens (logout)
  Future<bool> removeTokens() async {
    final prefs = await _preferences;
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    return true;
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== User Data Management ====================

  /// Save user data as JSON
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await _preferences;
    final jsonString = json.encode(userData);
    return await prefs.setString(_userDataKey, jsonString);
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(_userDataKey);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Remove user data
  Future<bool> removeUserData() async {
    final prefs = await _preferences;
    return await prefs.remove(_userDataKey);
  }

  // ==================== Questionnaire Responses Management ====================

  /// Save questionnaire responses
  Future<bool> saveQuestionnaireResponses(
    List<Map<String, dynamic>> responses,
  ) async {
    final prefs = await _preferences;
    final jsonString = json.encode(responses);
    return await prefs.setString(_questionnaireResponsesKey, jsonString);
  }

  /// Get questionnaire responses
  Future<List<Map<String, dynamic>>?> getQuestionnaireResponses() async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(_questionnaireResponsesKey);
    if (jsonString == null) return null;
    final decoded = json.decode(jsonString) as List;
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Remove questionnaire responses
  Future<bool> removeQuestionnaireResponses() async {
    final prefs = await _preferences;
    return await prefs.remove(_questionnaireResponsesKey);
  }

  /// Save questionnaire output (API response data)
  Future<bool> saveQuestionnaireOutput(Map<String, dynamic> output) async {
    final prefs = await _preferences;
    final jsonString = json.encode(output);
    return await prefs.setString(_questionnaireOutputKey, jsonString);
  }

  /// Get questionnaire output
  Future<Map<String, dynamic>?> getQuestionnaireOutput() async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(_questionnaireOutputKey);
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Remove questionnaire output
  Future<bool> removeQuestionnaireOutput() async {
    final prefs = await _preferences;
    return await prefs.remove(_questionnaireOutputKey);
  }

  // ==================== Create User Token Management ====================

  /// Save create user token (for OTP verification)
  Future<bool> saveCreateUserToken(String token) async {
    final prefs = await _preferences;
    return await prefs.setString(_createUserTokenKey, token);
  }

  /// Get create user token
  Future<String?> getCreateUserToken() async {
    final prefs = await _preferences;
    return prefs.getString(_createUserTokenKey);
  }

  /// Remove create user token
  Future<bool> removeCreateUserToken() async {
    final prefs = await _preferences;
    return await prefs.remove(_createUserTokenKey);
  }

  // ==================== Image Data Management ====================

  /// Save image data (base64 string or path)
  Future<bool> saveImageData(String imageKey, String imageData) async {
    final prefs = await _preferences;
    final key = '$_imageDataPrefix$imageKey';
    return await prefs.setString(key, imageData);
  }

  /// Get image data
  Future<String?> getImageData(String imageKey) async {
    final prefs = await _preferences;
    final key = '$_imageDataPrefix$imageKey';
    return prefs.getString(key);
  }

  /// Remove image data
  Future<bool> removeImageData(String imageKey) async {
    final prefs = await _preferences;
    final key = '$_imageDataPrefix$imageKey';
    return await prefs.remove(key);
  }

  /// Get all image keys
  Future<List<String>> getAllImageKeys() async {
    final prefs = await _preferences;
    final keys = prefs.getKeys();
    return keys
        .where((key) => key.startsWith(_imageDataPrefix))
        .map((key) => key.replaceFirst(_imageDataPrefix, ''))
        .toList();
  }

  // ==================== Generic Storage Methods ====================

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    final prefs = await _preferences;
    return await prefs.setString(key, value);
  }

  /// Get string value
  Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  /// Save int value
  Future<bool> saveInt(String key, int value) async {
    final prefs = await _preferences;
    return await prefs.setInt(key, value);
  }

  /// Get int value
  Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }

  /// Save bool value
  Future<bool> saveBool(String key, bool value) async {
    final prefs = await _preferences;
    return await prefs.setBool(key, value);
  }

  /// Get bool value
  Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }

  /// Save double value
  Future<bool> saveDouble(String key, double value) async {
    final prefs = await _preferences;
    return await prefs.setDouble(key, value);
  }

  /// Get double value
  Future<double?> getDouble(String key) async {
    final prefs = await _preferences;
    return prefs.getDouble(key);
  }

  /// Save list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    final prefs = await _preferences;
    return await prefs.setStringList(key, value);
  }

  /// Get list of strings
  Future<List<String>?> getStringList(String key) async {
    final prefs = await _preferences;
    return prefs.getStringList(key);
  }

  /// Save JSON object
  Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    final prefs = await _preferences;
    final jsonString = jsonEncode(json);
    return await prefs.setString(key, jsonString);
  }

  /// Get JSON object
  Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Remove a specific key
  Future<bool> remove(String key) async {
    final prefs = await _preferences;
    return await prefs.remove(key);
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }

  /// Clear all data
  Future<bool> clearAll() async {
    final prefs = await _preferences;
    return await prefs.clear();
  }

  /// Get all keys
  Future<Set<String>> getAllKeys() async {
    final prefs = await _preferences;
    return prefs.getKeys();
  }
}
