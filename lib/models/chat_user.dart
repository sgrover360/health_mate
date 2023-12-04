import 'package:firebase_auth/firebase_auth.dart';

class ChatUser {
  final String? id;
  late final String name;
  final List<String> chatIds;
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
  final String email;
  String phone;
  String? photoUri;
  bool isDoctor;
  String signInMethod;

  ChatUser({
    this.id,
    this.name = 'da',
    this.chatIds = const [],
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
    required this.email,
    this.phone = '',
    this.photoUri,
    this.isDoctor = false,
    this.signInMethod = 'unknown',
  });

  factory ChatUser.fromFirebaseUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email?.split('@')[0] ?? 'Unknown User',
      chatIds: [],
      fname: '',
      lname: 'Guest',
      sex: 'Male',
      email: user.email ?? '',
      signInMethod: user.providerData.isNotEmpty
          ? user.providerData[0].providerId
          : 'unknown',
    );
  }

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      chatIds: json['chatIds'] == null
          ? []
          : List<String>.from(json['chatIds'].map((x) => x)),
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

  Map<String, dynamic> toJson() {
    return {
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
}
