import 'package:cloud_firestore/cloud_firestore.dart';

class Prescription {
  final String doctorFirstName;
  final String doctorLastName;
  final String userFirstName;
  final String userLastName;
  final String contactInfo;
  final String date;
  final String prescriptionPdfUrl;
  final String medicineName;
  final String doctorImage;
  final String userImage;
  final String?
      userId; //  combination of userFirstName, userLastName and Date of Month of Birthday
  final String prescriptionId;

  Prescription({
    required this.doctorFirstName,
    required this.doctorLastName,
    required this.userFirstName,
    required this.userLastName,
    required this.contactInfo,
    required this.date,
    required this.prescriptionPdfUrl,
    required this.medicineName,
    required this.doctorImage,
    required this.userImage,
    required this.userId,
    required this.prescriptionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorFirstName': doctorFirstName,
      'doctorLastName': doctorLastName,
      'contactInfo': contactInfo,
      'date': date,
      'prescriptionPdfUrl': prescriptionPdfUrl,
      'medicineName': medicineName,
      'doctorImage': doctorImage,
      'userImage': userImage,
      'userId': userId,
    };
  }

  static Prescription fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Prescription(
      doctorFirstName: map['doctorFirstName'],
      doctorLastName: map['doctorLastName'],
      userFirstName: map['userFirstName'],
      userLastName: map['userFirstName'],
      contactInfo: map['contactInfo'],
      date: map['date'],
      prescriptionPdfUrl: map['prescriptionPdfUrl'],
      medicineName: map['medicineName'],
      doctorImage: map['doctorImage'],
      userImage: map['userImage'],
      userId: map['userId'],
      prescriptionId: doc.id,
    );
  }
}
