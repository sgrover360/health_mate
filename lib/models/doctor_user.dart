import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_mate/models/chat_user.dart';

class DoctorUser extends ChatUser{
  DoctorUser({
    required this.id,
    required this.name,
    required this.specialization,
    required this.medicalId,
    required this.researchPaperURL,
    required this.dateOfBirth,
    required this.chatIds,
  }) : super(id: id, name: name, chatIds: chatIds);

  final String id;
  final String name;
  final String specialization;
  final String medicalId;
  final String researchPaperURL;
  final DateTime dateOfBirth;
  final List<String> chatIds;

  // Create a DoctorUser from JSON data
  factory DoctorUser.fromJson(Map<String, dynamic> json) {
    DateTime parsedDateOfBirth;
    if (json['dateOfBirth'] is Timestamp) {
      parsedDateOfBirth = (json['dateOfBirth'] as Timestamp).toDate();
    } else if (json['dateOfBirth'] is String) {
      parsedDateOfBirth = DateTime.tryParse(json['dateOfBirth']) ?? DateTime.now();
    } else {
      parsedDateOfBirth = DateTime.now(); // default or fallback value
    }

    return DoctorUser(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      specialization: json["specialization"] ?? "",
      medicalId: json["medicalId"] ?? "",
      researchPaperURL: json["researchPaperURL"] ?? "",
      dateOfBirth: parsedDateOfBirth,
      chatIds: json["chatIds"] == null ? [] : List<String>.from(json["chatIds"].map((x) => x)),
    );
  }

  // Convert DoctorUser to JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "specialization": specialization,
    "medicalId": medicalId,
    "researchPaperURL": researchPaperURL,
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "chatIds": chatIds.map((x) => x).toList(),
  };

  // Get a user-friendly representation of the doctor
  String getDetails() {
    return '$name, $specialization (ID: $medicalId)';
  }
}
