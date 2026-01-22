import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:better_help/screen/supports_sections/video_call_agora/video_call_controller.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  double _left = 10.0;
  double? _top;
  double? bottom = 40;
  bool showRemoteInBox = false;
  DateTime dargStartedAt = DateTime.now();
  DateTime dargEndedAt = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<VideoCallController>()) {
      Get.put<VideoCallController>(VideoCallController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithBack(text: ''),
      body: GetBuilder<VideoCallController>(
        builder: (controller) {
          return Stack(
            children: [
              Center(child: _remoteVideo(controller)),
              Positioned(
                top: _top,
                left: _left,
                bottom: bottom,
                child: Draggable(
                  onDragStarted: () {
                    dargStartedAt = DateTime.now();
                  },
                  onDragUpdate: (details) {
                    bottom = null;
                    _shiftingPositon(details.localPosition, context);
                  },
                  onDragEnd: (details) {
                    dargEndedAt = DateTime.now();
                    _shiftingPositon(details.offset, context);
                    if (dargEndedAt.difference(dargStartedAt).inMilliseconds < 500) {
                      showRemoteInBox = !showRemoteInBox;
                    }
                  },
                  feedback: _selfVideo(controller),
                  childWhenDragging: SizedBox.shrink(),

                  child: _selfVideo(controller),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _shiftingPositon(Offset details, BuildContext context) {
    setState(() {
      _left = details.dx.clamp(0.0, MediaQuery.of(context).size.width - 150);
      _top = details.dy.clamp(0.0, MediaQuery.of(context).size.height - 200);
    });
  }

  Container _selfVideo(VideoCallController controller) {
    if (showRemoteInBox) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(width: 1.2, color: Colors.grey),
        ),
        width: 150,
        height: 200,
        child: controller.remoteUid != null
            ? AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.engine,
                  canvas: VideoCanvas(uid: controller.remoteUid!),
                  connection: RtcConnection(channelId: controller.videoSessionModel?.channelName),
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                child: Center(child: CircularProgressIndicator()),
              ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(width: 1.2, color: Colors.grey),
      ),
      width: 150,
      height: 200,
      child: controller.localUserJoined
          ? (AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: controller.engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            ))
          : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo(VideoCallController controller) {
    if (showRemoteInBox) {
      return controller.localUserJoined
          ? (AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: controller.engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            ))
          : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
              child: Center(child: CircularProgressIndicator()),
            );
    }
    if (controller.remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.engine,
          canvas: VideoCanvas(uid: controller.remoteUid!),
          connection: RtcConnection(channelId: controller.videoSessionModel?.channelName),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Please wait for the doctor to join',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}
