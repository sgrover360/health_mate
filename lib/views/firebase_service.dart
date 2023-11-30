import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
/// A service class to abstract Firebase related functionalities.
class FirebaseService {
// Instance of FirebaseAuth for authentication tasks.
  final FirebaseAuth _auth = FirebaseAuth.instance;
// Instance of FirebaseFirestore to interact with Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  /// Getter to retrieve the current authenticated user.
  User? get currentUser => _auth.currentUser;
  /// Method to add a user to Firestore if they don't already exist.
  ///
  /// This method checks if a user with a given UID exists in the 'chat_users'
  /// collection in Firestore. If the user doesn't exist, it adds the user to the
  /// collection with the provided user details.
  ///
  /// [user]: Firebase authenticated user whose details need to be added/verified in Firesto
  Future<void> addUserIfNotExist(User user) async {
// Fetch the user's document from Firestore.
    final userDoc = await _firestore.collection('chat_users').doc(user.uid).get();
// If the document does not exist, add the user to Firestore.
    if (!userDoc.exists) {
      await _firestore.collection('chat_users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
      });
    }
  }
}