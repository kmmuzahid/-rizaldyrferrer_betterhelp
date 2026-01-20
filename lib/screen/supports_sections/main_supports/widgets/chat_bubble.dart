/*
 * @Author: Km Muzahid
 * @Date: 2026-01-11 14:49:38
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/supports_sections/main_supports/model/message_model.dart';
import 'package:core_kit/button/common_button.dart';
import 'package:core_kit/text/common_text.dart';
import 'package:core_kit/utils/core_screen_utils.dart';
import 'package:flutter/material.dart';

class CommonChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSender;
  final String? timestamp;
  final Function(String) onButtonTap;

  const CommonChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    this.timestamp,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.55);
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          border: BoxBorder.all(color: !isSender ? Colors.grey.shade200 : Colors.transparent),
        ),
        padding: !isSender ? EdgeInsets.only(right: 10) : EdgeInsets.zero,
        margin: !isSender ? EdgeInsets.only(bottom: 10, left: 5) : EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: maxWidth,
              margin: EdgeInsets.only(top: 8, left: isSender ? 0 : 10, right: isSender ? 10 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSender ? const Color(0xFFE0F2F1) : const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: CommonText(
                text: message.message,
                textColor: Colors.black87,
                textAlign: TextAlign.left,
                fontSize: 14,
                isDescription: true,
              ),
            ),
            4.height,

            // if (!isSender)
            if (!isSender && !message.isReply)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                constraints: maxWidth,
                child: Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 8,
                  children: [
                    ...List.generate(getLength(message.messageType), (index) {
                      return CommonButton(
                        titleText: '${index + 1}',
                        buttonWidth: 30,
                        buttonColor: const Color(0xFFE0F2F1), // Light teal
                        titleColor: const Color(0xFF00796B),
                        onTap: () {
                          onButtonTap('${index + 1}');
                        },
                      );
                    }),
                  ],
                ),
              ),
            if (timestamp != null)
              CommonText(
                top: 4,
                left: isSender ? 0 : 15,
                right: isSender ? 15 : 0,
                bottom: 4,
                text: timestamp!,
                fontSize: 12,
                textColor: Colors.grey,
              ),
            10.height,
          ],
        ),
      ),
    );
  }

  int getLength(String type) {
    if (type == 'one_to_five') {
      return 5;
    } else if (type == 'task_pending_reminder' || type == 'task_completed_question') {
      return 2;
    } else if (type == 'task_completed_reminder' || type == 'assistant_question') {
      return 3;
    }
    return 0;
  }
}
