import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_mate/models/chat.dart';
import 'package:health_mate/models/chat_message.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/models/doctor_user.dart';

class NewChatController {
  Future<List<DoctorUser>> getAllPossibleChatPartners(ChatUser user) async {
    return (await FirebaseFirestore.instance
        .collection("doctors")
        .orderBy("id", descending: false)
        .orderBy("name", descending: false)
        .get())
        .docs
        .map((e) => DoctorUser.fromJson(e.data()))
        .toList();
  }

  Future<Chat?> getExistingChat(ChatUser local, ChatUser other) async {
    for (var chatId in local.chatIds) {
      if (other.chatIds.contains(chatId)) {
        var chatDoc = await FirebaseFirestore.instance.collection("chats").doc(chatId).get();
        if (chatDoc.exists) {
          return Chat.fromJson(chatDoc.data()!);
        }
      }
    }
    return null;
  }

  Future<Chat> createNewChat(ChatUser local, ChatUser other) async {
    // First, check if an existing chat is there
    var existingChat = await getExistingChat(local, other);
    if (existingChat != null) {
      return existingChat;
    }

    // If no existing chat, create a new one
    var newChatId = local.id + other.id;
    var chat = Chat(
        users: <ChatUser>[local, other],
        id: newChatId,
        messages: <ChatMessage>[]
    );
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(newChatId)
        .set(chat.toJson());

    // Add chatId to both users and update Firestore documents
    await _updateUserChatIds(local, newChatId);
    await _updateUserChatIds(other, newChatId);

    return chat;
  }

  Future<void> _updateUserChatIds(ChatUser user, String chatId) async {
    var userRef = FirebaseFirestore.instance.collection("users").doc(user.id);
    var userDoc = await userRef.get();

    if (!userDoc.exists) {
      userRef.set(user.toJson(), SetOptions(merge: true));
    } else {
      userRef.update({'chatIds': FieldValue.arrayUnion([chatId])});
    }
  }
}
