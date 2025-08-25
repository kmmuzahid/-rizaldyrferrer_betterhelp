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
    if (_isUpdating || selectedTab == tab) {
      appLog('Tab selection ignored - already updating or same tab');
      return;
    }
    
    _isUpdating = true;
    appLog('Selecting tab: $tab (from: $selectedTab)');
    selectedTab = tab;
    // Reset filter to recent when switching tabs
    selectedFilter = ForumFilter.recent;
    appLog('Tab selected: $selectedTab, Filter reset to: $selectedFilter');
    
    // Force immediate update for tab switching
    update();
    
    // Use post-frame callback to reset the updating flag
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isUpdating = false;
      appLog('Tab update completed, _isUpdating reset to false');
    });
  }

  // Method to select filter (Recent, Highlight, Popular)
  void selectFilter(ForumFilter filter) {
    // Prevent multiple simultaneous updates
    if (_isUpdating || selectedFilter == filter) {
      appLog('Filter selection ignored - already updating or same filter');
      return;
    }
    
    _isUpdating = true;
    appLog('Selecting filter: $filter (from: $selectedFilter)');
    selectedFilter = filter;
    appLog('Filter selected: $selectedFilter');
    
    // Force immediate update for filter switching
    update();
    
    // Use post-frame callback to reset the updating flag
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isUpdating = false;
      appLog('Filter update completed, _isUpdating reset to false');
    });
  }

  // Helper methods to check current selections
  bool isTabSelected(CommunityTab tab) {
    bool result = selectedTab == tab;
    appLog('isTabSelected($tab): $result (current: $selectedTab)');
    return result;
  }
  
  bool isFilterSelected(ForumFilter filter) {
    bool result = selectedFilter == filter;
    appLog('isFilterSelected($filter): $result (current: $selectedFilter)');
    return result;
  }

  @override
  void onClose() {
    // Clean up resources when controller is disposed
    _isUpdating = false;
    appLog('Controller disposed');
    super.onClose();
  }
}