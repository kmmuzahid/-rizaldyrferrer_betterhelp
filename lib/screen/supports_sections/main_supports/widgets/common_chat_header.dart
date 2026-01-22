/*
 * @Author: Km Muzahid
 * @Date: 2026-01-11 14:48:33
 * @Email: km.muzahid@gmail.com
 */
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class CommonChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback? onBackTap;

  const CommonChatHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
 
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F9FA), // Light teal header background
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          10.width,
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            // Use a fallback icon if imageUrl is null
            child: imageUrl != null
                ? Image.network(imageUrl!)
                : const Icon(Icons.person, color: Colors.cyan),
          ),
          12.width,
          CommonText(
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            textColor: Colors.cyan,
          ),
         
          // CommonText(text: ' - $subtitle', fontSize: 12, textColor: Colors.cyan.withOpacity(0.6)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
