/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/model/booking_session_model.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/supports_sections/main_supports/model/message_model.dart';
import 'package:better_help/sockets/support_message_socket.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class SupportScreenController extends GetxController {
  RxList<MessageModel> messageModel = RxList<MessageModel>([]); 
  String replyMessage = '';
  late String chatId;
  final MyProfileScreenController profileScreenController = Get.find();
  Rxn<BookedSessionModel?> bookedSessionModel = Rxn();
  RxBool isLoading = false.obs;

  RxInt replyIndex = (-1).obs;

  late DateTime _todayDayStart;
  late DateTime _todayDayEnd;
  @override
  void onInit() {
    super.onInit(); 
    _todayDayStart = startOfDayLocal(DateTime.now());
    _todayDayEnd = endOfDayLocal(DateTime.now());
    chatId = profileScreenController.profileData.value?.doctorChatId ?? '';
    getMessages(page: 1);

    SocketService.instance.startListeningChat(
      chatId: chatId,
      onMessage: (data) {
        final message = MessageModel.fromJson(data);
        messageModel.insert(0, message);
      },
    );

    super.onInit();
  }

  // Start of day in local time
  DateTime startOfDayLocal(DateTime localDate) =>
      DateTime(localDate.year, localDate.month, localDate.day, 0, 0);

  // End of day in local time
  DateTime endOfDayLocal(DateTime localDate) =>
      DateTime(localDate.year, localDate.month, localDate.day, 23, 59);

  fetchBookingSession({bool refresh = false, int page = 1}) async {
    final result = await DioService.instance.request<List<BookedSessionModel>>(
      input: RequestInput(
        endpoint: ApiEndPoints.getMyBooking,
        queryParams: {
          'page': page,
          'limit': 1,
          'dayStartTime': _todayDayStart.toIso8601String(),
          'dayEndTime': _todayDayEnd.toIso8601String(),
        },
        method: RequestMethod.GET,
      ),
      responseBuilder: (response) {
        return List<BookedSessionModel>.from(response.map((x) => BookedSessionModel.fromJson(x)));
      },
    );
    if (result.isSuccess) {
      bookedSessionModel.value = result.data?.first;
    }
  }

  @override
  void dispose() {
    SocketService.instance.stopListeningChat(chatId: chatId); 
    super.dispose();
  }

  getMessages({int page = 1}) async {
    isLoading.value = true;
    final result = await DioService.instance.request<List<MessageModel>>(
      input: RequestInput(
        queryParams: {'page': page, 'limit': 20},
        endpoint: ApiEndPoints.getMyMessages(chatId),
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) {
        return data["newResult"]['result']
            .map<MessageModel>((x) => MessageModel.fromJson(x))
            .toList();
      },
    );
    if (result.isSuccess) {
      messageModel.addAll(result.data ?? []);
    }
    isLoading.value = false;
  }

  sendMessage({required String message, required int index}) async {
    final updatedMessage = messageModel[index].copyWith(isResponseSent: true);
    print(profileScreenController.profileData.value?.id);
    messageModel.insert(
      0,
      updatedMessage.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        messageType: 'regular',
        sender: Sender(
          id: profileScreenController.profileData.value?.id ?? '',
          profile: '',
          fullName: '',
          role: '',
        ),
      ),
    );
    final result = await DioService.instance.request<dynamic>(
      input: RequestInput(
        endpoint: ApiEndPoints.sendMessages,
        method: RequestMethod.POST,
        formFields: {
          'message': message,
          'chatId': chatId,
          'messageType': updatedMessage.messageType,
          'messageId': updatedMessage.id,
        },
      ),
      responseBuilder: (data) {
        return data;
      },
    );
    if (result.isSuccess) {
      final index = messageModel.indexWhere((element) => element.id == updatedMessage.id);
      if (index != -1) {
        messageModel[index] = updatedMessage;
      }
    }
  }
}
