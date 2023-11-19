import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? id;
  final String name;
  final String email;
  late String phone;
  late String photoUri;

  UserData(
      {this.id,
      this.name = 'Guest',
      required this.email,
      this.phone = '',
      this.photoUri = ''});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUri': photoUri,
    };
  }

  static UserData fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserData(
      id: doc.id,
      name: map['name'] ?? 'Guest',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUri: map['photoUri'] ?? '',
    );
  }
}
