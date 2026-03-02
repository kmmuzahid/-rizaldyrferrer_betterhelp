/*
 * @Author: Km Muzahid
 * @Date: 2026-02-17 14:21:13
 * @Email: km.muzahid@gmail.com
 */
import 'package:intl/intl.dart';

class SlotsModel {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  SlotsModel({required this.startTime, required this.endTime, this.isAvailable = true});

  String get startTimeLocal => _formatTime(startTime.toLocal());

  String get endTimeLocal => _formatTime(endTime.toLocal());

  String _formatTime(DateTime dt) => DateFormat("h:mm a").format(dt);

  factory SlotsModel.fromJson(Map json) {
    return SlotsModel(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  SlotsModel copyWith({DateTime? startTime, DateTime? endTime, bool? isAvailable}) {
    return SlotsModel(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
