import 'package:get/get.dart';

class BookingSessionController extends GetxController {
  // Observable list to store booking dates and their slots
  var bookingData = <BookingDate>[].obs;
  var selectedSlot = Rx<String?>(null);
  
  @override
  void onInit() {
    super.onInit();
    generateBookingData();
  }
  
  void generateBookingData() {
    final now = DateTime.now();
    final List<BookingDate> data = [];
    
    // Generate data for next 6 days starting from today
    for (int i = 0; i < 6; i++) {
      final date = now.add(Duration(days: i));
      final bookingDate = BookingDate(
        date: date,
        formattedDate: _formatDate(date),
        slots: _generateSlotsForDay(i),
      );
      data.add(bookingDate);
    }
    
    bookingData.value = data;
  }
  
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}";
  }
  
  List<String> _generateSlotsForDay(int dayIndex) {
    // Create dummy data - some days have slots, some don't
    switch (dayIndex) {
      case 0: // Today
        return ["9:00 AM", "10:30 AM", "2:00 PM", "3:30 PM"];
      case 1: // Tomorrow
        return []; // No slots
      case 2: // Day 2
        return ["11:00 AM", "1:00 PM", "2:30 PM", "4:00 PM", "5:30 PM"];
      case 3: // Day 3
        return ["9:30 AM", "11:00 AM"];
      case 4: // Day 4
        return []; // No slots
      case 5: // Day 5
        return [
          "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", 
          "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", 
          "5:00 PM", "6:00 PM"
        ]; // 10 slots
      default:
        return [];
    }
  }
  
  void selectSlot(String slot) {
    selectedSlot.value = slot;
  }
  
  void clearSelection() {
    selectedSlot.value = null;
  }
  
  bool isSlotSelected(String slot) {
    return selectedSlot.value == slot;
  }
  
  // Get all available slots from all days
  List<String> get allAvailableSlots {
    final List<String> allSlots = [];
    for (var booking in bookingData) {
      allSlots.addAll(booking.slots);
    }
    return allSlots;
  }
  
  // Get selected date info
  BookingDate? get selectedDateInfo {
    if (selectedSlot.value == null) return null;
    
    for (var booking in bookingData) {
      if (booking.slots.contains(selectedSlot.value)) {
        return booking;
      }
    }
    return null;
  }
}

class BookingDate {
  final DateTime date;
  final String formattedDate;
  final List<String> slots;
  
  BookingDate({
    required this.date,
    required this.formattedDate,
    required this.slots,
  });
  
  bool get hasSlots => slots.isNotEmpty;
}