/*
 * @Author: Km Muzahid
 * @Date: 2026-02-17 14:21:13
 * @Email: km.muzahid@gmail.com
 */
import 'package:intl/intl.dart';

class SlotsModel {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  SlotsModel({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  // Converts "2:45 PM" (UTC) → local DateTime
  DateTime _parseUtcTime(String time) {
    final now = DateTime.now().toUtc();
    final format = DateFormat("h:mm a");
    final parsed = format.parse(time); // parsed as local, we treat it as UTC
    return DateTime.utc(now.year, now.month, now.day, parsed.hour, parsed.minute);
  }

  String _formatTime(DateTime dt) => DateFormat("h:mm a").format(dt);

  String get startTimeLocal {
    return _formatTime(_parseUtcTime(startTime).toLocal());
  }

  String get endTimeLocal {
    return _formatTime(_parseUtcTime(endTime).toLocal());
  }

  factory SlotsModel.fromJson(Map json) {
    return SlotsModel(
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  SlotsModel copyWith({
    String? startTime,
    String? endTime,
    bool? isAvailable,
  }) {
    return SlotsModel(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
