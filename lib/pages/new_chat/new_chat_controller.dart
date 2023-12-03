import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_mate/models/chat.dart';
import 'package:health_mate/models/chat_message.dart';
import 'package:health_mate/models/chat_user.dart';

class NewChatController {
  Future<List<ChatUser>> getAllPossibleChatPartners(ChatUser user) async {
    return (await FirebaseFirestore.instance
        .collection("users")
        .where("id", isNotEqualTo: user.id)
        .orderBy("id", descending: false)
        .orderBy("name", descending: false)
        .get())
        .docs
        .map((e) => ChatUser.fromJson(e.data()))
        .toList();
  }

  Future<Chat?> getExistingChat(ChatUser local, ChatUser other) async {
    var index = local.chatIds
        .indexWhere(((element) => other.chatIds.contains(element)));
    if (index == -1) {
      return null;
    }

    var chatId = local.chatIds[index];

    var chat =
    (await FirebaseFirestore.instance.collection("chats").doc(chatId).get())
        .data();
    return Chat.fromJson(chat!);
  }

  Future<Chat> createNewChat(ChatUser local, ChatUser other) async {
    var newChatId = local.id + other.id;
    var chat = Chat(
        users: <ChatUser>[local, other],
        id: newChatId,
        messages: <ChatMessage>[]);
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(newChatId)
        .set(chat.toJson());

    local.chatIds.add(newChatId);
    other.chatIds.add(newChatId);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(local.id)
        .update(local.toJson());

    await FirebaseFirestore.instance
        .collection("users")
        .doc(other.id)
        .update(other.toJson());

    return chat;
  }
}