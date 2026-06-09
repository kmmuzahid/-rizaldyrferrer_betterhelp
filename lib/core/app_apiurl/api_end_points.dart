/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
class ApiEndPoints {
  ApiEndPoints._();
  //live
  // static const imageUrl = "http://54.241.114.7:5000";
  // static const liveDomain = "http://54.241.114.7:5000";
  //local public
  static const imageUrl = "https://humayon5002.binarybards.online";
  static const liveDomain = "https://humayon5002.binarybards.online";
  //local
  // static const imageUrl = "https://api.betterhabitsforlife.com";
  // static const liveDomain = "https://api.betterhabitsforlife.com";

  // static const localDomain = "http://10.10.7.65:5003";
  static const domain = liveDomain;
  static const baseUrl = "$liveDomain/api/v1";

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
  static const forgotPassoword = "$baseUrl/auth/change-password";
  static const getAllArticle = "$baseUrl/article";
  static String getSingleArticle(var id) => "$baseUrl/article/$id";
  static const savedArticle = "$baseUrl/favorite/saved";
  static String toggleSaveArticle(var articleId) => "$baseUrl/favorite/saved";
  static const getMyProfile = "$baseUrl/users/my-profile";
  static const editMyProfile = "$baseUrl/users/update-my-profile";
  static const getAllPost = "$baseUrl/post";
  static String getSinglePost(var postId) => "$baseUrl/post/$postId";
  static const getHighlightPost = "$baseUrl/post?highlight=true";
  static const getRecentPost = "$baseUrl/post?recent=true";
  static const getPopularPost = "$baseUrl/post?popular=true";
  static const createPost = "$baseUrl/post/create-post";
  static String getPostLike(var postId) => "$baseUrl/post/like/$postId";

  static const getCourseList = "$baseUrl/course";
  static String getSingleCourse(var id) => "$baseUrl/course/$id";
  static const getCourseCategoryList = "$baseUrl/category";
  static const refreshToken = "$baseUrl/auth/refresh-token";
  static const review = "$baseUrl/review";
  static const favoriteCourse = "$baseUrl/favorite/saved";
  static String setCourseViewCount(var id) => "$baseUrl/course/view-count/$id";
  static String getPostComment(var postId) => "$baseUrl/comments/post/$postId";
  static const createComment = "$baseUrl/comments/create-comment-or-reply";
  static const createCommentReply = "$baseUrl/comments/create-comment-or-reply";
  static const reactOnComment = "$baseUrl/comments/like-comment";
  static const reactOnCommentReply = "$baseUrl/comments/like-comment";

  static const report = "$baseUrl/report";
  static String getMyMessages(var id) => "$baseUrl/message/my-messages/$id";
  static const sendMessages = "$baseUrl/message/send-messages";
  static const createDoctorBooking =
      "$baseUrl/doctor-booking/create-doctor-booking";
  static const getFavouriteArticle = "$baseUrl/favorite/saved";

  static const createSubscription = "$baseUrl/subscription/create";
  static const createVideoSession = "$baseUrl/doctor-booking/agora-token";
  static const getMyBooking = "$baseUrl/doctor-booking/my-booking";
  static String taskBytheDate(var data) => "$baseUrl/task?dateTime=$data";
  static const seeAllBookings = "$baseUrl/doctor-booking/my-booking";
  static String taskCompleted(var taskId) =>
      "$baseUrl/task/status/$taskId?status=completed";
  static String taskCancelled(var taskId) =>
      "$baseUrl/task/status/$taskId?status=cancelled";

  static const notification = "$baseUrl/notification";
  static const notificationAllRead = "$baseUrl/notification/all-read";
  static String getNotificationRead(var id) => "$baseUrl/notification/read/$id";
  static const faq = "$baseUrl/faq";
  static const talkToSupport = "$baseUrl/report";
  static const termsOfService = "$baseUrl/setting?termsOfService";
  static const privacyPolicy = "$baseUrl/setting?privacyPolicy";
  static const taskStatistics = "$baseUrl/task/statistics";
  static const bhaBhaaReassignRequest = "$baseUrl/bha-bhaa-reassign";

  static const getDoctorAvailableSlots =
      "$baseUrl/doctor-booking/my-doctor-available-slots";
  static const availableBookingDate =
      "$baseUrl/doctor-booking/my-doctor-available-date";
  static const resetPassword = "$baseUrl/auth/forgot-password-reset";
  static const generateTaskByAi = "$baseUrl/task/generate-by-ai";
  static const createTask = "$baseUrl/task/create-by-user";
  static String taskStatus(var taskId) => "$baseUrl/task/status/$taskId";

  static const package = "$baseUrl/package/user";
}
