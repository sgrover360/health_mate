import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/chat_user.dart';

class UserDataService {
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference userDataCollection;

  UserDataService()
      : userDataCollection = FirebaseFirestore.instance.collection('users');

  // Future<DocumentReference<Object?>> addNewProfile(UserData profile) async {
  //   if (profile.fname.isEmpty && profile.lname.isEmpty) {
  //     throw Exception('Please update name');
  //   } else if (await profileExists(profile.id)) {
  //     throw Exception('User profile already exists for this email');
  //   }
  //   return await userDataCollection.add(profile.toMap());
  // }

  // Stream<List<UserData>> getAllProfiles() {
  //   return userDataCollection.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return UserData.fromMap(doc);
  //     }).toList();
  //   });
  // }

  Future<void> updateProfile(String id, ChatUser profile) async {
    if (!await profileExists(profile.id)) {
      throw Exception('User profile already exists');
    }
    return await userDataCollection.doc(id).update(profile.toJson());
  }

  Future<void> deleteProfile(ChatUser profile) async {
    if (!await profileExists(profile.id)) {
      throw Exception('User profile not found');
    }
    return await userDataCollection.doc(profile.id).delete();
  }

  Future<bool> profileExists(String? id) async {
    var check = await userDataCollection.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc.id == FirebaseAuth.instance.currentUser!.uid) {
          return true;
        }
      }
    });
    return check == true ? true : false;
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
