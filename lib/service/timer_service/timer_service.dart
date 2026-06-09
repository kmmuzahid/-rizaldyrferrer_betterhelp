import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TimerService extends GetxService {
  static TimerService get instance => Get.find<TimerService>();

  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _backgroundTimer;

  // Storage keys
  static const String _keyRemainingSeconds = 'timer_remaining_seconds';
  static const String _keyIsRunning = 'timer_is_running';
  static const String _keyStartTime = 'timer_start_time';
  static const String _keyTotalDuration = 'timer_total_duration';

  // Reactive variables
  RxInt remainingSeconds = 1500.obs;
  RxBool isRunning = false.obs;
  RxInt totalDuration = 1500.obs; // 25 minutes (now dynamic)

  @override
  void onInit() {
    super.onInit();
    _initTimerState();
  }

  Future<void> _initTimerState() async {
    await _loadTimerState();
    _startBackgroundTimer();
  }

  Future<void> _loadTimerState() async {
    // Load saved timer state
    int savedTotalDuration = await StorageService.instance.getInt(_keyTotalDuration) ?? 1500;
    totalDuration.value = savedTotalDuration;

    int savedRemaining =
        await StorageService.instance.getInt(_keyRemainingSeconds) ?? totalDuration.value;
    bool savedIsRunning = await StorageService.instance.getBool(_keyIsRunning) ?? false;
    int? savedStartTime = await StorageService.instance.getInt(_keyStartTime);

    if (savedIsRunning && savedStartTime != null) {
      // Calculate actual remaining time based on elapsed time
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int elapsedSeconds = ((currentTime - savedStartTime) / 1000).floor();
      int actualRemaining = savedRemaining - elapsedSeconds;

      if (actualRemaining > 0) {
        remainingSeconds.value = actualRemaining;
        isRunning.value = true;
      } else {
        // Timer has completed while app was closed
        remainingSeconds.value = 0;
        isRunning.value = false;
        await _clearTimerState();
      }
    } else {
      remainingSeconds.value = savedRemaining;
      isRunning.value = false;
    }
  }

  void _startBackgroundTimer() {
    _backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (isRunning.value && remainingSeconds.value > 0) {
        remainingSeconds.value--;
        await _saveTimerState();

        if (remainingSeconds.value <= 0) {
          // Timer completed
          await completeTimer();
        }
      }
    });
  }

  Future<void> startTimer() async {
    if (!isRunning.value && remainingSeconds.value > 0) {
      isRunning.value = true;
      await StorageService.instance.saveInt(_keyStartTime, DateTime.now().millisecondsSinceEpoch);
      await _saveTimerState();
    }
  }

  Future<void> pauseTimer() async {
    isRunning.value = false;
    await StorageService.instance.remove(_keyStartTime);
    await _saveTimerState();
  }

  Future<void> resetTimer() async {
    isRunning.value = false;
    remainingSeconds.value = totalDuration.value;
    await _clearTimerState();
  }

  Future<void> setCustomTime(int seconds) async {
    // Stop the timer if it's running
    if (isRunning.value) {
      await pauseTimer();
    }

    // Set new total duration and remaining seconds
    totalDuration.value = seconds;
    remainingSeconds.value = seconds;

    // Save the new state
    await _saveTimerState();
  }

  Future<void> completeTimer() async {
    isRunning.value = false;
    remainingSeconds.value = 0;
    await _clearTimerState();

    try {
      await _audioPlayer.play(AssetSource('sounds/timer_end.mp3'));
    } catch (e) {
      debugPrint("Error playing timer sound: $e");
    }
  }

  Future<void> _saveTimerState() async {
    await StorageService.instance.saveInt(_keyRemainingSeconds, remainingSeconds.value);
    await StorageService.instance.saveBool(_keyIsRunning, isRunning.value);
    await StorageService.instance.saveInt(_keyTotalDuration, totalDuration.value);
  }

  Future<void> _clearTimerState() async {
    await StorageService.instance.remove(_keyRemainingSeconds);
    await StorageService.instance.remove(_keyIsRunning);
    await StorageService.instance.remove(_keyStartTime);
    await StorageService.instance.remove(_keyTotalDuration);
  }

  String get formattedTime {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progressPercentage {
    return (remainingSeconds.value / totalDuration.value) * 100;
  }

  @override
  void onClose() {
    _backgroundTimer?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }
}
