import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TimerService extends GetxService {
  static TimerService get instance => Get.find<TimerService>();

  final GetStorage _storage = GetStorage();
  Timer? _backgroundTimer;

  // Storage keys
  static const String _keyRemainingSeconds = 'timer_remaining_seconds';
  static const String _keyIsRunning = 'timer_is_running';
  static const String _keyStartTime = 'timer_start_time';
  static const String _keyTotalDuration = 'timer_total_duration';

  // Reactive variables
  RxInt remainingSeconds = 300.obs;
  RxBool isRunning = false.obs;
  RxInt totalDuration = 300.obs; // 5 minutes (now dynamic)

  @override
  void onInit() {
    super.onInit();
    _loadTimerState();
    _startBackgroundTimer();
  }

  void _loadTimerState() {
    // Load saved timer state
    int savedTotalDuration = _storage.read(_keyTotalDuration) ?? 300;
    totalDuration.value = savedTotalDuration;

    int savedRemaining =
        _storage.read(_keyRemainingSeconds) ?? totalDuration.value;
    bool savedIsRunning = _storage.read(_keyIsRunning) ?? false;
    int? savedStartTime = _storage.read(_keyStartTime);

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
        _clearTimerState();
      }
    } else {
      remainingSeconds.value = savedRemaining;
      isRunning.value = false;
    }
  }

  void _startBackgroundTimer() {
    _backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isRunning.value && remainingSeconds.value > 0) {
        remainingSeconds.value--;
        _saveTimerState();

        if (remainingSeconds.value <= 0) {
          // Timer completed
          completeTimer();
        }
      }
    });
  }

  void startTimer() {
    if (!isRunning.value && remainingSeconds.value > 0) {
      isRunning.value = true;
      _storage.write(_keyStartTime, DateTime.now().millisecondsSinceEpoch);
      _saveTimerState();
    }
  }

  void pauseTimer() {
    isRunning.value = false;
    _storage.remove(_keyStartTime);
    _saveTimerState();
  }

  void resetTimer() {
    isRunning.value = false;
    remainingSeconds.value = totalDuration.value;
    _clearTimerState();
  }

  void setCustomTime(int seconds) {
    // Stop the timer if it's running
    if (isRunning.value) {
      pauseTimer();
    }

    // Set new total duration and remaining seconds
    totalDuration.value = seconds;
    remainingSeconds.value = seconds;

    // Save the new state
    _saveTimerState();
  }

  void completeTimer() {
    isRunning.value = false;
    remainingSeconds.value = 0;
    _clearTimerState();

    // Show completion notification
    //
  }

  void _saveTimerState() {
    _storage.write(_keyRemainingSeconds, remainingSeconds.value);
    _storage.write(_keyIsRunning, isRunning.value);
    _storage.write(_keyTotalDuration, totalDuration.value);
  }

  void _clearTimerState() {
    _storage.remove(_keyRemainingSeconds);
    _storage.remove(_keyIsRunning);
    _storage.remove(_keyStartTime);
    _storage.remove(_keyTotalDuration);
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
    super.onClose();
  }
}
