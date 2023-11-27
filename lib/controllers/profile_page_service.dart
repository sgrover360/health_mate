import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/user_data.dart';
import '../views/auth_gate.dart';

class UserDataService {
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference userDataCollection;

  UserDataService()
      : userDataCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userData');

  Future<DocumentReference<Object?>> addNewProfile(UserData profile) async {
    if (await profileExists(profile.id)) {
      throw Exception('User data already exists for this user');
    }
    return await userDataCollection.add(profile.toMap());
  }

  // Stream<List<UserData>> getAllProfiles() {
  //   return userDataCollection.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return UserData.fromMap(doc);
  //     }).toList();
  //   });
  // }

  Future<void> updateProfile(String id, UserData profile) async {
    if (await profileExists(profile.id)) {
      throw Exception('User profile already exists');
    }
    return await userDataCollection.doc(id).update(profile.toMap());
  }

  Future<void> deleteProfile(UserData profile) async {
    if (!await profileExists(profile.id)) {
      throw Exception('User profile not found');
    }
    return await userDataCollection.doc(profile.id).delete();
  }

  Future<bool> profileExists(String? id) async {
    var profiles = [];
    await userDataCollection.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        var profile = doc.data();
        profiles.add(profile);
      });
    });
    if (profiles.length > 1) {
      return true;
    }
    return false;
  }

  Future<String?> uploadProfilePic(XFile? image) async {
    if (image == null) return null;
    if (user == null) return null;
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('images/${user!.uid}/${image.name}');
    try {
      final uploadTask = await firebaseStorageRef.putFile(File(image.path));
      if (uploadTask.state == TaskState.success) {
        final downloadURL = await firebaseStorageRef.getDownloadURL();
        print("Uploaded to: $downloadURL");
        return downloadURL;
      }
    } catch (e) {
      throw Exception("$e: Failed to upload image");
    }
    return null;
  }
}
