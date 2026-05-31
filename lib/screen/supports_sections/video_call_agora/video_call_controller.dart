import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/supports_sections/main_supports/model/video_session_model.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  int? remoteUid;
  bool localUserJoined = false;
  RtcEngine? engine;

  late String id;

  VideoSessionModel? videoSessionModel;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    getVideoSession();
  }

  getVideoSession() async {
    final result = await CkTransport.request<VideoSessionModel>(
      input: RequestInput(
        endpoint: ApiEndPoints.createVideoSession,
        jsonBody: {"bookingSheduleId": id},
        method: RequestMethod.POST,
      ),
      responseBuilder: (data) {
        return VideoSessionModel.fromJson(data);
      },
    );
    if (result.isSuccess) {
      videoSessionModel = result.data;
      update();
      initAgora();
    } else {
      CkSnackBar(result.message ?? '', type: .error);
      Get.back();
    }
  }

  Future<void> initAgora() async {
    if (videoSessionModel == null) return;
    // retrieve permissions
    final status = await [Permission.microphone, Permission.camera].request();
    if (status.values.every((element) => element.isGranted)) {
      //create the engine
      engine = createAgoraRtcEngine();
      await engine?.initialize(
        RtcEngineContext(
          appId: videoSessionModel!.appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      engine?.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            CkLogger.debug("local user ${connection.localUid} joined");

            localUserJoined = true;
            update();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            CkLogger.debug("remote user $remoteUid joined");

            this.remoteUid = remoteUid;
            update();
          },
          onUserOffline:
              (
                RtcConnection connection,
                int remoteUid,
                UserOfflineReasonType reason,
              ) {
                CkLogger.debug("remote user $remoteUid left channel");

                this.remoteUid = null;
                update();
              },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            CkLogger.debug(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token',
            );
          },
        ),
      );

      await engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine?.enableVideo();
      await engine?.startPreview();

      await engine?.joinChannel(
        token: videoSessionModel!.token,
        channelId: videoSessionModel!.channelName,
        uid: videoSessionModel!.uid,
        options: const ChannelMediaOptions(),
      );
    }
  }

  @override
  void onClose() {
    super.onClose();

    _dispose();
  }

  Future<void> _dispose() async {
    await engine?.leaveChannel();
    await engine?.release();
  }
}
