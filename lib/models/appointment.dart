import 'package:health_mate/models/appointment_slot.dart';

class Appointment {
  final String? id;
  final AppointmentSlot slot;
  final String doctor;
  final String patient;

  Appointment({
    this.id,
    required this.slot,
    required this.doctor,
    required this.patient,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? "",
      slot: AppointmentSlot(dateTime: DateTime.parse(json['slot']['dateTime'])),
      doctor: json['doctor'] ?? "",
      patient: json['patient'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "slot": {"dateTime": slot.dateTime.toIso8601String()},
      "doctor": doctor,
      "patient": patient,
    };

    if (id != null) {
      json["id"] = id;
    }

    return json;
  }
}
