// import 'package:hive/hive.dart';
//
// part 'diary_entry.g.dart'; // Name of the generated file
//
// @HiveType(typeId: 0) // Unique typeId for Hive
// class DiaryEntry {
//   @HiveField(0)
//   final DateTime date;
//   @HiveField(1)
//   final String description;
//   @HiveField(2)
//   final int rating;
//
//   DiaryEntry(this.date, this.description, this.rating);
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String firstName;
  final String lastName;
  final String type;
  final String description;
  final double rating;
  final double goodReviews;
  final double totalScore;
  final double satisfaction;
  final bool isFavourite;
  final String image;
  final String location;
  final String id;

  Doctor(
      {required this.firstName,
        required this.lastName,
        required this.type,
        required this.description,
        required this.rating,
        required this.goodReviews,
        required this.totalScore,
        required this.satisfaction,
        required this.isFavourite,
        required this.image,
        required this.location,
        required this.id});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'type': type,
      'description': description,
      'rating': rating,
      'goodReviews': goodReviews,
      'totalScore': totalScore,
      'satisfaction': satisfaction,
      'isFavourite': isFavourite,
      'image': image,
      'location': location,
    };
  }

  static Doctor fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Doctor(
      firstName: map['firstName'],
      lastName: map['lastName'],
      type: map['type'],
      description: map['description'],
      rating: map['rating'],
      goodReviews: map['goodReviews'],
      totalScore: map['totalScore'],
      satisfaction: map['satisfaction'],
      isFavourite: map['isFavourite'],
      image: map['image'],
      location: map['location'],
      id: doc.id,
    );
  }

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    firstName: json["firstName"],
    lastName: json["lastName"],
    type: json["type"],
    description: json["description"],
    rating: json["rating"].toDouble(),
    goodReviews: json["goodReviews"].toDouble(),
    totalScore: json["totalScore"].toDouble(),
    satisfaction: json["satisfaction"].toDouble(),
    isFavourite: json["isFavourite"],
    image: json["image"],
    location: json["location"],
    id: json["id"],
  );
}
