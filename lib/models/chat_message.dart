import 'package:health_mate/models/chat_user.dart';

class ChatMessage {
  final ChatUser sender;
  final String content;
  final DateTime timestamp;

  ChatMessage(
      {required this.sender, required this.content, required this.timestamp});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        sender: ChatUser.fromJson(json["sender"]),
        content: json["content"],
        timestamp: DateTime.parse(json["timestamp"]));
  }

  Map<String, dynamic> toJson() => {
    "sender": sender.toJson(),
    "content": content,
    "timestamp": timestamp.toIso8601String()
  };
}
