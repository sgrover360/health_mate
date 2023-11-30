import 'package:health_mate/models/prescription.dart';

final List<Prescription> prescriptions = [
  Prescription(
    doctorFirstName: 'Mashoor',
    doctorLastName: 'Gulati',
    userFirstName: 'Jack',
    userLastName: 'Morris',
    contactInfo: '123-456-7890',
    date: '2023-01-01',
    prescriptionPdfUrl: 'https://firebasestorage.googleapis.com/v0/b/health-mate-4768.appspot.com/o/prescription.pdf?alt=media&token=5a5f9ac5-88e0-4d22-9215-a9101f4fa2fb', // Replace with the actual URL
    medicineName: 'Aspirin',
    doctorImage: 'assets/doctor_gulati.png',
    userImage: 'assets/user_1.png',
    userId: '',
    prescriptionId: '',
  ),
  Prescription(
    doctorFirstName: 'Rob',
    doctorLastName: 'Smith',
    userFirstName: 'Karina',
    userLastName: 'Karson',
    contactInfo: '123-456-7890',
    date: '2023-01-02',
    prescriptionPdfUrl: 'https://firebasestorage.googleapis.com/v0/b/health-mate-4768.appspot.com/o/prescription.pdf?alt=media&token=5a5f9ac5-88e0-4d22-9215-a9101f4fa2fb', // Replace with the actual URL
    medicineName: 'Advil',
    doctorImage: 'assets/doctor.png',
    userImage: 'assets/user_2.png',
    userId: '', // think about making a static User class containing all the properties
    prescriptionId: '',
  ),
  Prescription(
    doctorFirstName: 'Jogan',
    doctorLastName: 'Walia',
    userFirstName: 'Chris',
    userLastName: 'Vorg',
    contactInfo: '123-456-7890',
    date: '2023-04-01',
    prescriptionPdfUrl: 'https://firebasestorage.googleapis.com/v0/b/health-mate-4768.appspot.com/o/prescription.pdf?alt=media&token=5a5f9ac5-88e0-4d22-9215-a9101f4fa2fb', // Replace with the actual URL
    medicineName: 'Viagra',
    doctorImage: 'assets/doctor_1.png',
    userImage: 'assets/user_3.png',
    userId: '',
    prescriptionId: '',
  ),
  Prescription(
    doctorFirstName: 'Vaibhav',
    doctorLastName: 'Mehra',
    userFirstName: 'John',
    userLastName: 'Smith',
    contactInfo: '123-456-7890',
    date: '2023-04-18',
    prescriptionPdfUrl: 'https://firebasestorage.googleapis.com/v0/b/health-mate-4768.appspot.com/o/prescription.pdf?alt=media&token=5a5f9ac5-88e0-4d22-9215-a9101f4fa2fb', // Replace with the actual URL
    medicineName: 'Ibuprofen',
    doctorImage: 'assets/doctor_3.png',
    userImage: 'assets/user_4.png',
    userId: '',
    prescriptionId: '',
  ),
  Prescription(
    doctorFirstName: 'Sawal',
    doctorLastName: 'Nijjer',
    userFirstName: 'Linda',
    userLastName: 'Rideout',
    contactInfo: '123-456-7890',
    date: '2023-08-23',
    prescriptionPdfUrl: 'https://firebasestorage.googleapis.com/v0/b/health-mate-4768.appspot.com/o/prescription.pdf?alt=media&token=5a5f9ac5-88e0-4d22-9215-a9101f4fa2fb', // Replace with the actual URL
    medicineName: 'Paracetamol',
    doctorImage: 'assets/doctor_4.png',
    userImage: 'assets/user_5.png',
    userId: '',
    prescriptionId: '',
  ),
  Prescription(
    doctorFirstName: 'Bhavesh',
    doctorLastName: 'Sahni',
    userFirstName: 'David',
    userLastName: 'Ellis',
    contactInfo: '123-456-7890',
    date: '2023-11-19',
    prescriptionPdfUrl: 'https://firebasestorage.googleapis.com/v0/b/health-mate-4768.appspot.com/o/prescription.pdf?alt=media&token=5a5f9ac5-88e0-4d22-9215-a9101f4fa2fb', // Replace with the actual URL
    medicineName: 'Lipitor',
    doctorImage: 'assets/doctor.png',
    userImage: 'assets/user_6.png',
    userId: '',
    prescriptionId: '',
  ),
  Prescription(
    doctorFirstName: 'Rishab',
    doctorLastName: 'Gupta',
    userFirstName: 'Ben',
    userLastName: 'Drover',
    contactInfo: '123-456-7890',
    date: '2023-12-27',
    prescriptionPdfUrl: 'https://firebasestorage.googleapis.com/v0/b/health-mate-4768.appspot.com/o/prescription.pdf?alt=media&token=5a5f9ac5-88e0-4d22-9215-a9101f4fa2fb', // Replace with the actual URL
    medicineName: 'Penicillin',
    doctorImage: 'assets/doctor_4.png',
    userImage: 'assets/user_1.png',
    userId: '',
    prescriptionId: '',
  ),
  // Add more prescriptions as needed
];