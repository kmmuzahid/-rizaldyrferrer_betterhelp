/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/supports_sections/main_supports/model/message_model.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class SupportScreenController extends GetxController {
  RxList<MessageModel> messageModel = RxList<MessageModel>([]);
  final String chatId = '6963790ef4b4ee82746a472e';

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

  sendMessage({required String message}) async {
    final result = await DioService.instance.request<MessageModel>(
      input: RequestInput(
        endpoint: AppApiurl.sendMessages,
        method: RequestMethod.POST,
        formFields: {'message': message, 'chatId': chatId},
      ),
      responseBuilder: (data) {
        print(data);
        return MessageModel.fromJson(data);
      },
    );
    if (result.isSuccess && result.data != null) {
      messageModel.add(result.data!);
    }
  }
}
