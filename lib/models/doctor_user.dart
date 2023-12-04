import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_mate/models/chat_user.dart';
import 'appointment.dart';

class DoctorUser extends ChatUser{
  DoctorUser({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.medicalId,
    required this.researchPaperURL,
    required this.dateOfBirth,
    required this.chatIds,
    required this.appointments,
    this.description = '',
    this.rating = 0,
    this.goodReviews = 0,
    this.totalScore = 0,
    this.satisfaction = 0,
    this.isFavourite = false,
    this.image = '',
    this.location = '',
    this.hospital = '',
    this.isDoctor,
  }): super(id: id, name: name, chatIds: chatIds, isDoctor: isDoctor, email: email);

  final String id;
  final String name;
  final String email;
  final String specialization;
  final String medicalId;
  final String researchPaperURL;
  final DateTime dateOfBirth;
  final List<String> chatIds;
  final List<Appointment> appointments;
  final String description;
  final double rating;
  final double goodReviews;
  final double totalScore;
  final double satisfaction;
  final bool isFavourite;
  final String image;
  final String location;
  final String hospital;
  bool? isDoctor;

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
        email: json["email"] ?? "",
        specialization: json["specialization"] ?? "",
        medicalId: json["medicalId"] ?? "",
        researchPaperURL: json["researchPaperURL"] ?? "",
        dateOfBirth: parsedDateOfBirth,
  // json["dateOfBirth"] is String
        //     ? DateTime.parse(json["dateOfBirth"])
        //     : (json["dateOfBirth"] as Timestamp).toDate(),
        chatIds: json["chatIds"] == null
            ? []
            : List<String>.from(json["chatIds"]!.map((x) => x)),
        appointments: json['appointments'] != null
            ? List<Appointment>.from(
                json['appointments'].map((x) => Appointment.fromJson(x)))
            : [],
        description: json["description"] ?? "",
        rating: json["rating"] ?? 0,
        goodReviews: json["goodReviews"] ?? 0,
        totalScore: json["totalScore"] ?? 0,
        satisfaction: json["satisfaction"] ?? 0,
        isFavourite: json["isFavourite"] ?? false,
        image: json["image"] ?? "",
        location: json["location"] ?? "",
        hospital: json["hospital"] ?? "",
        isDoctor: json["isDoctor"]);
  }

  // Convert DoctorUser to JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "specialization": specialization,
        "medicalId": medicalId,
        "researchPaperURL": researchPaperURL,
        "dateOfBirth": dateOfBirth, //.toIso8601String(),
        "chatIds": chatIds.map((x) => x).toList(),
        'appointments': appointments.map((x) => x.toJson()).toList(),
        "description": description,
        "rating": rating,
        "goodReviews": goodReviews,
        "totalScore": totalScore,
        "satisfaction": satisfaction,
        "isFavourite": isFavourite,
        "image": image,
        "location": location,
        "hospital": hospital,
        "isDoctor": isDoctor,
      };
  // Get a user-friendly representation of the doctor
  String getDetails() {
    return '$name, $specialization (ID: $medicalId)';
  }
}
