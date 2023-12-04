class AppointmentSlot {
  final DateTime dateTime;

  AppointmentSlot({
    required this.dateTime,
  });

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    return AppointmentSlot(
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
