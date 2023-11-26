import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_mate/models/chat.dart';
import 'package:health_mate/models/chat_message.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:intl/intl.dart';

class SingleChatController {
  String getChatName(Chat chat, ChatUser user) {
    return chat.users.firstWhere((element) => element.id != user.id).name;
  }

  Future sendMessage(String chatId, ChatUser sender, String message) async {
    final chat = Chat.fromJson(
        (await FirebaseFirestore.instance.collection("chats").doc(chatId).get())
            .data()!);
    chat.messages.add(ChatMessage(
        sender: sender, content: message, timestamp: DateTime.now()));

    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chat.id)
        .update(chat.toJson());
  }

  String formatDateTime(DateTime datetime) {
    final now = DateTime.now();
    if (datetime.year != now.year &&
        datetime.month == now.month &&
        datetime.day == now.day) {
      return DateFormat(DateFormat.HOUR24_MINUTE).format(datetime);
    } else {
      return DateFormat.yMMMd().add_Hm().format(datetime);
    }
  }
}


//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:health_mate/models/chat.dart';
// import 'package:health_mate/models/chat_message.dart';
// import 'package:health_mate/models/chat_user.dart';
//
// class SingleChatController {
//   String getChatName(Chat chat, ChatUser user) {
//     return chat.users.firstWhere((element) => element.id != user.id).name;
//   }
//
//   Future sendMessage(String chatId, ChatUser sender, String content, bool isImage) async {
//     final chatDoc = FirebaseFirestore.instance.collection("chats").doc(chatId);
//     final chatSnapshot = await chatDoc.get();
//     final chat = Chat.fromJson(chatSnapshot.data()!);
//
//     ChatMessage message = ChatMessage(
//       sender: sender,
//       content: content,
//       timestamp: DateTime.now(),
//       isImage: isImage, // This assumes your ChatMessage model has an 'isImage' field
//     );
//
//     chat.messages.add(message);
//
//     await chatDoc.update(chat.toJson());
//   }
// }
