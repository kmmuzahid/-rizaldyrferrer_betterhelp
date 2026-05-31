/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/menu_drawer/faqs/faq_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FaqScreenController>();
    return Scaffold(
      appBar: AppBarWithBack(text: "FAQs", backgroundColor: AppColors.white),
      backgroundColor: AppColors.white,
      body: Obx(() {
        return CkListView(
          limit: 20,
          isLoading: controller.isLoading.value,
          onRefresh: () => controller.fetchFaqList(isRefresh: true),
          onLoadMore: (page) => controller.fetchFaqList(page: page),
          itemCount: controller.faqList.length,
          itemBuilder: (context, index) {
            final faq = controller.faqList[index];
            return FaqItem(question: faq.key, answer: faq.value);
          },
        );
      }),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, required this.question, required this.answer});

  @override
  _FaqItemState createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> with TickerProviderStateMixin {
  bool _isExpanded = false;

  late final AnimationController _controller;
  late final Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<double>(
      begin: 0,
      end: 100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          widget.question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.cyan, // Primary cyan color for the question
          ),
        ),
        subtitle: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SizedBox(
              height: _isExpanded ? _heightAnimation.value : 0,
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.answer,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.cyan, // Use cyan for the icon as well
        ),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
            if (_isExpanded) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          });
        },
      ),
    );
  }
}
