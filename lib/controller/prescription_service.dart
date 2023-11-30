import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_mate/models/prescription.dart';

class PrescriptionService {
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference prescriptions;

  PrescriptionService()
      : prescriptions = FirebaseFirestore.instance
      .collection('prescriptions')
      .doc(FirebaseAuth.instance.currentUser!.displayName) // Need to use a more realistic way to organise prescriptions in firestore firebase
      .collection('userPrescriptions');

  Future<DocumentReference<Object?>> addPrescription(Prescription prescription) async {
    return await prescriptions.add(prescription.toMap());
  }

  Future<void> updatePrescription(Prescription prescription) async {
    return await prescriptions.doc(prescription.prescriptionId).update(prescription.toMap());
  }

  Future<void> removePrescription(Prescription prescription) async {
    return await prescriptions.doc(prescription.prescriptionId).delete();
  }

  Future<List<Prescription>> listPrescriptions() async {
    QuerySnapshot snapshot = await prescriptions.get();
    return snapshot.docs.map((doc) => Prescription.fromMap(doc)).toList();
  }

  // Future<List<Prescription>> filterPrescriptions(String filterBy, searchFragment) async {
  //   List<Prescription> filteredPrescriptions;
  //   if (filterBy == "rating") {
  //     filteredEntries = await filterEntriesByRating(searchFragment);
  //     return filteredEntries;
  //   }
  //   // if (filterBy == "description_fragment") {                                                 // to be implemented
  //   //   filteredEntries = filterEntriesByDescriptionFragments(searchFragment);
  //   //   return filteredEntries;
  //   // }
  //   else {
  //     return listEntries();
  //   }
  // }

  // List<DiaryEntry> filterEntriesByDescriptionFragments(searchFragment) {
  //                                                                                            // to be implemented
  // }

  // Future<List<DiaryEntry>> filterEntriesByRating(int rating) async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('entries')
  //       .where('rating', isEqualTo: rating)
  //       .get();
  //
  //   final filteredEntries = querySnapshot
  //       .docs
  //       .map((doc) => DiaryEntry.fromMap(doc))
  //       .toList();
  //   return filteredEntries;
  // }
}
