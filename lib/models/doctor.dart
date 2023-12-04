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
