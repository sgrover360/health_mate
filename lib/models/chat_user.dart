import 'package:firebase_auth/firebase_auth.dart';

class ChatUser {
  ChatUser({
    required this.id,
    required this.name,
    required this.chatIds,
  });

  final String id;
  final String name;
  final List<String> chatIds;

  factory ChatUser.fromFirebaseUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email?.split('@')[0] ?? 'Unknown User',
      chatIds: [], // Initialize with empty list or fetch from your database if needed
    );
  }

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      chatIds: json["chatIds"] == null
          ? []
          : List<String>.from(json["chatIds"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "chatIds": chatIds.map((x) => x).toList(),
      };
}
