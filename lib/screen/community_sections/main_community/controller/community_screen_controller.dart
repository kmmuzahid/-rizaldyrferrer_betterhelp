import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CommunityTab { peerForum, article }

enum ForumFilter { recent, highlight, popular }

class CommunityScreenController extends GetxController {
  // Selection states (non-reactive for GetBuilder)
  CommunityTab selectedTab = CommunityTab.peerForum;
  ForumFilter selectedFilter = ForumFilter.recent;
  
  // Add a flag to prevent multiple simultaneous updates
  bool _isUpdating = false;

  @override
  void onInit() {
    super.onInit();
    // Ensure initial values are set
    selectedTab = CommunityTab.peerForum;
    selectedFilter = ForumFilter.recent;
    appLog(
      'Controller initialized - Tab: $selectedTab, Filter: $selectedFilter',
    );
  }

  // Method to select tab (Peer Forum or Article)
  void selectTab(CommunityTab tab) {
    // Prevent multiple simultaneous updates
    if (_isUpdating || selectedTab == tab) return;
    
    _isUpdating = true;
    appLog('Selecting tab: $tab');
    selectedTab = tab;
    // Reset filter to recent when switching tabs
    selectedFilter = ForumFilter.recent;
    appLog('Tab selected: $selectedTab, Filter reset to: $selectedFilter');
    
    // Use post-frame callback to ensure update happens after current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isUpdating = false;
      update();
    });
  }

  // Method to select filter (Recent, Highlight, Popular)
  void selectFilter(ForumFilter filter) {
    // Prevent multiple simultaneous updates
    if (_isUpdating || selectedFilter == filter) return;
    
    _isUpdating = true;
    appLog('Selecting filter: $filter');
    selectedFilter = filter;
    appLog('Filter selected: $selectedFilter');
    
    // Use post-frame callback to ensure update happens after current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isUpdating = false;
      update();
    });
  }

  // Helper methods to check current selections
  bool isTabSelected(CommunityTab tab) => selectedTab == tab;
  bool isFilterSelected(ForumFilter filter) => selectedFilter == filter;

  @override
  void onClose() {
    // Clean up resources when controller is disposed
    _isUpdating = false;
    appLog('Controller disposed');
    super.onClose();
  }
}