import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? id;
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

  UserData(
      {this.id,
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
      this.photoUri = ''});

  get entries => null;

  Map<String, dynamic> toMap() {
    return {
      'fname': fname,
      'lname': lname,
      'dob': dob,
      'sex': sex,
      'address': addr,
      'postal_code': post,
      'city': city,
      'province': province,
      'hair_color': hairCol,
      'blood_type': bloodType,
      'eye_color': eyeCol,
      'skine_tone': skinTone,
      'email': email,
      'phone': phone,
      'profile_pic': photoUri,
    };
  }

  static UserData fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserData(
      id: doc.id,
      fname: map['fname'] ?? '',
      lname: map['lname'] ?? 'Guest',
      dob: map['dob'] ?? '',
      sex: map['sex'] ?? 'Male',
      addr: map['address'] ?? '',
      post: map['postal_code'] ?? '',
      city: map['city'] ?? '',
      province: map['province'] ?? '',
      hairCol: map['hair_color'] ?? '',
      bloodType: map['bloodType'] ?? '',
      eyeCol: map['eye_color'] ?? '',
      skinTone: map['skin_tone'] ?? '',
      email: map['email'],
      phone: map['phone'] ?? '',
      photoUri: map['photoUri'] ?? '',
    );
  }
}
