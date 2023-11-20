import 'package:health_mate/models/chat_message.dart';
import 'package:health_mate/models/chat_user.dart';

class Chat {
  final List<ChatUser> users;
  final String id;
  final List<ChatMessage> messages;

  Chat({required this.users, required this.id, required this.messages});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        id: json["id"] ?? "",
        users: json["users"] == null
            ? <ChatUser>[]
            : List<ChatUser>.from(
            json["users"].map((e) => ChatUser.fromJson(e))),
        messages: json["messages"] == null
            ? <ChatMessage>[]
            : List<ChatMessage>.from(
            json["messages"].map((e) => ChatMessage.fromJson(e))));
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "users": List<dynamic>.from(users.map((e) => e.toJson())),
    "messages": List<dynamic>.from(messages.map((e) => e.toJson()))
  };
}
