
class DoctorUser {
  DoctorUser({
    required this.id,
    required this.name,
    required this.specialization,
    required this.medicalId,
    required this.researchPaperURL,
    required this.dateOfBirth,
    required this.chatIds,
  });

  final String id;
  final String name;
  final String specialization;
  final String medicalId;
  final String researchPaperURL;
  final DateTime dateOfBirth;
  final List<String> chatIds;

  // Create a DoctorUser from JSON data
  factory DoctorUser.fromJson(Map<String, dynamic> json) {
    return DoctorUser(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      specialization: json["specialization"] ?? "",
      medicalId: json["medicalId"] ?? "",
      researchPaperURL: json["researchPaperURL"] ?? "",
      dateOfBirth: DateTime.parse(json["dateOfBirth"]),
      chatIds: json["chatIds"] == null
          ? []
          : List<String>.from(json["chatIds"]!.map((x) => x)),
    );
  }

  // Convert DoctorUser to JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "specialization": specialization,
    "medicalId": medicalId,
    "researchPaperURL": researchPaperURL,
    "dateOfBirth": dateOfBirth,//.toIso8601String(),
    "chatIds": chatIds.map((x) => x).toList(),
  };
}
