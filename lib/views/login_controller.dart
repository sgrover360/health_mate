/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_mate/models/chat_user.dart';

class LoginController {
  Future<ChatUser> login(String email, String password) async {
    var cred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    var user = (await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: cred.user?.uid ?? "")
        .get())
        .docs
        .map((e) => ChatUser.fromJson(e.data()))
        .toList()
        .single;

    return user;
  }

  Future register(String email, String password, String username) async {
    var cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    var user =
    ChatUser(id: cred.user?.uid ?? "", name: username, chatIds: <String>[]);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(cred.user?.uid ?? "")
        .set(user.toJson());
  }
}
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/models/doctor_user.dart';

class LoginController {
  // Email/Password Login
  login(String email, String password) async {
    UserCredential cred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    var userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(cred.user!.uid)
        .get();

    var doctorDoc = await FirebaseFirestore.instance
        .collection("doctors")
        .doc(email)
        .get();

    if (userDoc.exists) {
      return ChatUser.fromJson(userDoc.data() as Map<String, dynamic>);
    }
    else if (doctorDoc.exists) {
      return DoctorUser.fromJson(doctorDoc.data() as Map<String, dynamic>);
    }
    else {
      // Handle the case where user is authenticated but not in Firestore
      throw FirebaseAuthException(
        code: "USER_NOT_IN_FIRESTORE",
        message: "Authenticated user not found in Firestore",
      );
    }
  }

  // User Registration
  Future<void> register(String email, String password, String username) async {
    UserCredential cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    ChatUser newUser =
        ChatUser(id: cred.user!.uid, name: username, email: email, chatIds: []);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(cred.user!.uid)
        .set(newUser.toJson());
  }

  Future<void> registerDoctor(
      String email, String password, Map<String, dynamic> doctorData) async {
    // Assuming doctorData contains email and password for creating a Firebase user
    // String email = doctorData['email'];
    // String password = doctorData['password'];

    UserCredential cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Create a DoctorUser instance
    DoctorUser newDoctor = DoctorUser(
      id: cred.user!.uid,
      name: doctorData['name'],
      email: email,
      specialization: doctorData['specialization'],
      medicalId: doctorData['medicalId'],
      researchPaperURL: doctorData['researchPaperURL'],
      dateOfBirth: doctorData['dateOfBirth'],
      chatIds: [],
      appointments: [], // Initialize with empty list or as needed
    );

    // Save the new doctor to Firestore
    await FirebaseFirestore.instance
        .collection("doctors")
        .doc(email)
        .set(newDoctor.toJson());
  }

  // Google Sign-In
  Future<ChatUser> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: "ERROR_ABORTED_BY_USER",
        message: "Sign in aborted by user",
      );
    }

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        return ChatUser.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        // Create a new user in Firestore
        ChatUser newUser = ChatUser.fromFirebaseUser(firebaseUser);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .set(newUser.toJson());
        return newUser;
      }
    } else {
      throw FirebaseAuthException(
        code: "ERROR_NO_USER",
        message: "No user returned from Google Sign-In",
      );
    }
  }
}
