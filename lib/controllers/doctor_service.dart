import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_mate/models/doctor_user.dart';


class DoctorService {
  final _doctor = FirebaseAuth.instance.currentUser;
  final CollectionReference doctorsCollection;

  DoctorService()
      : doctorsCollection = FirebaseFirestore.instance
      .collection('doctors');

  Future<void> updateDoctor(DoctorUser doctor) async {
    return await doctorsCollection.doc(doctor!.email).update(doctor.toJson());
  }

  Future<void> removeDoctor(DoctorUser doctor) async {
    return await doctorsCollection.doc(_doctor!.email).delete();
  }

  Future<List<DoctorUser>> listDoctors() async {
    QuerySnapshot snapshot = await doctorsCollection.get();
    return snapshot.docs.map((doc) => DoctorUser.fromJson(doc as Map<String, dynamic>)).toList();
  }
}
