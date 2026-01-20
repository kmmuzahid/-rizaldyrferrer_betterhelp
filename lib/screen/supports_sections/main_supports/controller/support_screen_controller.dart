/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/supports_sections/main_supports/model/message_model.dart';
import 'package:better_help/sockets/support_message_socket.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class SupportScreenController extends GetxController {
  RxList<MessageModel> messageModel = RxList<MessageModel>([]);
  late String chatId;
  final MyProfileScreenController profileScreenController = Get.find();

  @override
  void onInit() {
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

  @override
  void dispose() {
    SocketService.instance.stopListeningChat(chatId: chatId);
    super.dispose();
  }

  getMessages({int page = 1}) async {
    final result = await DioService.instance.request<List<MessageModel>>(
      input: RequestInput(
        queryParams: {'page': page, 'limit': 20},
        endpoint: AppApiurl.getMyMessages(chatId),
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
  }

  sendMessage({required String message, required int index}) async {
    final updatedMessage = messageModel[index].copyWith(isResponseSent: true);
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
        endpoint: AppApiurl.sendMessages,
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
