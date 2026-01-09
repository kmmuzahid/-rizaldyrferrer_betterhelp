/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
class AppApiurl {
  AppApiurl._();

  static const liveDomain = "http://10.10.7.65:5003";
  static const localDomain = "http://10.10.7.65:5003";
  static const baseUrl = "$liveDomain/api/v1";
  static const imageUrl = "http://10.10.7.65:5003";
  static const questionAnswer = "$baseUrl/users/question-answer";
  static const createUser = "$baseUrl/users/create";
  static const resendOtp = "$baseUrl/otp/resend-otp";
  static const verifyOtp = "$baseUrl/users/create-user-verify-otp";
  static const forgotPassword = "$baseUrl/auth/forgot-password-otp";
  static const resendForgotPasswordOtp = "$baseUrl/otp/resend-otp";
  static const login = "$baseUrl/auth/login";
  static const changePassword = "$baseUrl/auth/change-password";
  static const forgotPassworResendOtp = "$baseUrl/otp/resend-otp";
  static const forgotPasswordOtpMatch =
      "$baseUrl/auth/forgot-password-otp-match";
  static const resetPassoword = "$baseUrl/auth/forgot-password-reset";
  static const getAllArticle = "$baseUrl/article";
  static getSingleArticle(var id) => "$baseUrl/article/$id";

  static const getCourseList = "$baseUrl/course";
  static getSingleCourse(var id) => "$baseUrl/course/$id";
  static const getCourseCategoryList = "$baseUrl/category";
  static const refreshToken = "$baseUrl/auth/refresh-token";
  static const review = "$baseUrl/review";
}
