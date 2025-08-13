import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:better_help/service/timer_service/timer_service.dart';

class TimerScreenController extends GetxController {
  ValueNotifier<double>? _valueNotifier;
  late TimerService _timerService;
  Worker? _progressWorker;

  ValueNotifier<double> get valueNotifier {
    _valueNotifier ??= ValueNotifier<double>(100.0);
    return _valueNotifier!;
  }

  @override
  void onInit() {
    super.onInit();
    _timerService = TimerService.instance;
    _initializeProgressListener();
  }

  void _initializeProgressListener() {
    //! Cancel existing worker if any
    _progressWorker?.dispose();

    //! Listen to timer service changes and update progress bar
    _progressWorker = ever(_timerService.remainingSeconds, (int remaining) {
      if (_valueNotifier != null && !_valueNotifier!.hasListeners) {
        //! ValueNotifier has been disposed, don't update
        return;
      }
      double progressValue = _timerService.progressPercentage;
      if (_valueNotifier != null) {
        _valueNotifier!.value = progressValue;
      }
    });

    //! Initialize progress bar with current timer state
    if (_valueNotifier != null) {
      _valueNotifier!.value = _timerService.progressPercentage;
    }
  }

  @override
  void onReady() {
    super.onReady();
    //! Ensure progress is synced when screen becomes ready
    if (_valueNotifier != null) {
      _valueNotifier!.value = _timerService.progressPercentage;
    }
  }

  void startTimer() {
    _timerService.startTimer();
  }

  void pauseTimer() {
    _timerService.pauseTimer();
  }

  void resetTimer() {
    _timerService.resetTimer();
  }

  //! Getters that delegate to the service
  RxInt get remainingSeconds => _timerService.remainingSeconds;
  RxBool get isRunning => _timerService.isRunning;
  String get formattedTime => _timerService.formattedTime;
  int get totalDuration => _timerService.totalDuration;

  @override
  void onClose() {
    _progressWorker?.dispose();
    _valueNotifier?.dispose();
    _valueNotifier = null;
    super.onClose();
  }
}
