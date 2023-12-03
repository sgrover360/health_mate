// import 'package:firebase_auth/firebase_auth.dart';
//
// class ChatUser {
//   ChatUser({
//     required this.id,
//     required this.name,
//     required this.chatIds,
//   });
//
//   final String id;
//   late final String name;
//   final List<String> chatIds;
//
//   factory ChatUser.fromFirebaseUser(User user) {
//     return ChatUser(
//       id: user.uid,
//       name: user.displayName ?? user.email?.split('@')[0] ?? 'Unknown User',
//       chatIds: [], // Initialize with empty list or fetch from your database if needed
//     );
//   }
//
//   factory ChatUser.fromJson(Map<String, dynamic> json) {
//     return ChatUser(
//       id: json["id"] ?? "",
//       name: json["name"] ?? "",
//       chatIds: json["chatIds"] == null
//           ? []
//           : List<String>.from(json["chatIds"]!.map((x) => x)),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "chatIds": chatIds.map((x) => x).toList(),
//   };
// }
//

import 'package:firebase_auth/firebase_auth.dart';

class ChatUser {
  final String id;
  late final String name;
  final List<String> chatIds;

  // Fields from UserData
  String fname;
  String lname;
  DateTime? dob;
  String sex;
  String addr;
  String post;
  String city;
  String province;
  String hairCol;
  String bloodType;
  String eyeCol;
  String skinTone;
  String email;
  String phone;
  String? photoUri;
  bool isDoctor;
  String signInMethod;

  ChatUser({
    required this.id,
    required this.name,
    required this.chatIds,
    this.fname = '',
    this.lname = 'Guest',
    this.dob,
    this.sex = 'Male',
    this.addr = '',
    this.post = '',
    this.city = '',
    this.province = '',
    this.hairCol = '',
    this.bloodType = '',
    this.eyeCol = '',
    this.skinTone = '',
    this.email = '',
    this.phone = '',
    this.photoUri,
    this.isDoctor = false,
    this.signInMethod = 'unknown',
  });

  factory ChatUser.fromFirebaseUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email?.split('@')[0] ?? 'Unknown User',
      chatIds: [], // Initialize with empty list or fetch from your database if needed
      // Additional fields initialized with default values
      fname: '',
      lname: 'Guest',
      sex: 'Male',
      email: user.email ?? '',
      signInMethod: user.providerData.isNotEmpty ? user.providerData[0].providerId : 'unknown',
      photoUri: user.photoURL,
      // ... Other fields initialized similarly
    );
  }

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      chatIds: json['chatIds'] == null ? [] : List<String>.from(json['chatIds'].map((x) => x)),
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? 'Guest',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      sex: json['sex'] ?? 'Male',
      addr: json['addr'] ?? '',
      post: json['post'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      hairCol: json['hairCol'] ?? '',
      bloodType: json['bloodType'] ?? '',
      eyeCol: json['eyeCol'] ?? '',
      skinTone: json['skinTone'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photoUri: json['photoUri'],
      isDoctor: json['isDoctor'] ?? false,
      signInMethod: json['signInMethod'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'chatIds': chatIds.map((x) => x).toList(),
    'fname': fname,
    'lname': lname,
    'dob': dob?.toIso8601String(),
    'sex': sex,
    'addr': addr,
    'post': post,
    'city': city,
    'province': province,
    'hairCol': hairCol,
    'bloodType': bloodType,
    'eyeCol': eyeCol,
    'skinTone': skinTone,
    'email': email,
    'phone': phone,
    'photoUri': photoUri,
    'isDoctor': isDoctor,
    'signInMethod': signInMethod,
  };
}
