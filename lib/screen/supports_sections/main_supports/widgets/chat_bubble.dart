/*
 * @Author: Km Muzahid
 * @Date: 2026-01-11 14:49:38
 * @Email: km.muzahid@gmail.com
 */
import 'package:core_kit/text/common_text.dart';
import 'package:core_kit/utils/core_screen_utils.dart';
import 'package:flutter/material.dart';

class CommonChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String? timestamp;

  const CommonChatBubble({super.key, required this.text, required this.isSender, this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
            margin: EdgeInsets.only(top: 8, left: isSender ? 0 : 10, right: isSender ? 10 : 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSender ? const Color(0xFFE0F2F1) : const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: CommonText(
              text: text,
              textColor: Colors.black87,
              textAlign: TextAlign.left,
              fontSize: 14,
              isDescription: true,
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
        ],
      ),
    );
  }
}
