import 'package:better_help/service/timer_service/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerScreenController extends GetxController
    with GetTickerProviderStateMixin {
  ValueNotifier<double>? _valueNotifier;
  late TimerService _timerService;
  Worker? _progressWorker;
  AnimationController? _progressAnimationController;
  Animation<double>? _progressAnimation;

  ValueNotifier<double> get valueNotifier {
    _valueNotifier ??= ValueNotifier<double>(100.0);
    return _valueNotifier!;
  }

  @override
  void onInit() {
    super.onInit();
    _timerService = TimerService.instance;
    _initializeAnimationController();
    _initializeProgressListener();
  }

  void _initializeAnimationController() {
    // Create animation controller with the same duration as timer
    _progressAnimationController = AnimationController(
      duration: Duration(seconds: _timerService.totalDuration.value),
      vsync: this,
    );

    // Create animation that goes from 100 to 0
    _progressAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController!,
        curve: Curves.linear, // Linear for consistent speed
      ),
    );

    // Listen to animation changes and update value notifier
    _progressAnimation!.addListener(() {
      if (_valueNotifier != null) {
        _valueNotifier!.value = _progressAnimation!.value;
      }
    });
  }

  void _initializeProgressListener() {
    //! Cancel existing worker if any
    _progressWorker?.dispose();

    //! Listen to timer service changes
    _progressWorker = ever(_timerService.remainingSeconds, (int remaining) {
      // ignore: invalid_use_of_protected_member
      if (_valueNotifier != null && !_valueNotifier!.hasListeners) {
        //! ValueNotifier has been disposed, don't update
        return;
      }

      // Update animation controller based on timer state
      _updateAnimationProgress();
    });

    //! Initialize progress bar with current timer state
    _updateAnimationProgress();
  }

  void _updateAnimationProgress() {
    if (_progressAnimationController == null) return;

    double currentProgress = _timerService.progressPercentage;

    // Calculate the animation progress (inverted because we want 100->0)
    double animationProgress = (100.0 - currentProgress) / 100.0;

    // Update animation controller to current progress without animation
    _progressAnimationController!.value = animationProgress;

    // Update value notifier immediately for sync
    if (_valueNotifier != null) {
      _valueNotifier!.value = currentProgress;
    }
  }

  @override
  void onReady() {
    super.onReady();
    //! Ensure progress is synced when screen becomes ready
    _updateAnimationProgress();
  }

  void startTimer() {
    _timerService.startTimer();

    // Start animation from current position
    if (_progressAnimationController != null &&
        !_progressAnimationController!.isAnimating) {
      double currentProgress = _timerService.progressPercentage;
      double startAnimationValue = (100.0 - currentProgress) / 100.0;

      // Update duration for remaining time
      int remainingSeconds = _timerService.remainingSeconds.value;
      _progressAnimationController!.duration = Duration(
        seconds: remainingSeconds,
      );

      // Start from current position
      _progressAnimationController!.forward(from: startAnimationValue);
    }
    WakelockPlus.enable();
  }

  void pauseTimer() {
    _timerService.pauseTimer();

    // Pause animation
    if (_progressAnimationController != null) {
      _progressAnimationController!.stop();
    }
    WakelockPlus.disable();
  }

  void resetTimer() {
    _timerService.resetTimer();

    // Reset animation
    if (_progressAnimationController != null) {
      _progressAnimationController!.reset();
      _progressAnimationController!.duration = Duration(
        seconds: _timerService.totalDuration.value,
      );
    }

    // Reset value notifier
    if (_valueNotifier != null) {
      _valueNotifier!.value = 100.0;
    }
    WakelockPlus.disable();
  }

  void setCustomTime(int totalSeconds) {
    // Set custom time in the timer service
    _timerService.setCustomTime(totalSeconds);

    // Update animation controller duration
    if (_progressAnimationController != null) {
      _progressAnimationController!.duration = Duration(seconds: totalSeconds);
      _progressAnimationController!.reset();
    }

    // Reset value notifier to 100%
    if (_valueNotifier != null) {
      _valueNotifier!.value = 100.0;
    }
  }

  //! Getters that delegate to the service
  RxInt get remainingSeconds => _timerService.remainingSeconds;
  RxBool get isRunning => _timerService.isRunning;
  String get formattedTime => _timerService.formattedTime;
  RxInt get totalDuration => _timerService.totalDuration;

  @override
  void onClose() {
    _progressWorker?.dispose();
    _progressAnimationController?.dispose();
    _valueNotifier?.dispose();
    _valueNotifier = null;
    WakelockPlus.disable();
    super.onClose();
  }
}
