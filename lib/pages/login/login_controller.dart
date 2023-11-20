import 'package:cloud_firestore/cloud_firestore.dart';
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
