/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
class AppApiurl {
  AppApiurl._();

  static const liveDomain = "http://10.10.7.65:5003";
  static const localDomain = "http://10.10.7.65:5003";
  static const domain = liveDomain;
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
  static const savedArticle = "$baseUrl/favorite/saved";
  static toggleSaveArticle(var articleId) => "$baseUrl/favorite/saved";
  static const getMyProfile = "$baseUrl/users/my-profile";
  static const editMyProfile = "$baseUrl/users/update-my-profile";
  static const getAllPost = "$baseUrl/post";
  static getSinglePost(var postId) => "$baseUrl/post/$postId";
  static const getHighlightPost = "$baseUrl/post?highlight=true";
  static const getRecentPost = "$baseUrl/post?recent=true";
  static const getPopularPost = "$baseUrl/post?popular=true";
  static const createPost = "$baseUrl/post/create-post";
  static getPostLike(var postId) => "$baseUrl/post/like/$postId";

  static const getCourseList = "$baseUrl/course";
  static getSingleCourse(var id) => "$baseUrl/course/$id";
  static const getCourseCategoryList = "$baseUrl/category";
  static const refreshToken = "$baseUrl/auth/refresh-token";
  static const review = "$baseUrl/review";
  static const favoriteCourse = "$baseUrl/favorite/saved";
  static setCourseViewCount(var id) => "$baseUrl/course/view-count/$id";
  static getPostComment(var postId) => "$baseUrl/comments/post/$postId";
  static const createComment = "$baseUrl/comments/create-comment-or-reply";
  static const createCommentReply = "$baseUrl/comments/create-comment-or-reply";
  static const reactOnComment = "$baseUrl/comments/like-comment";
  static const reactOnCommentReply = "$baseUrl/comments/like-comment";

  static const report = "$baseUrl/report";
  static getMyMessages(var id) => "$baseUrl/message/my-messages/$id";
  static const sendMessages = "$baseUrl/message/send-messages";
  static const createDoctorBooking =
      "$baseUrl/doctor-booking/create-doctor-booking";
  static const getFavouriteArticle = "$baseUrl/favorite/saved";

  static const getDoctorAvailableSlots = "$baseUrl/doctor-booking/my-doctor-available-slots";
  static const createSubscription = "$baseUrl/subscription/create-purchase-subscription";
  static const createVideoSession = "$baseUrl/video-session/create-video-session";
  static const getMyBooking = "$baseUrl/doctor-booking/my-booking";
}
