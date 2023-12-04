import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_mate/models/chat.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/models/doctor_user.dart'; // Import DoctorUser model
import 'package:intl/intl.dart';

class ChatOverviewController {
  String getChatName(Chat chat, ChatUser user) {
    // Updated to handle doctor's name if the chat partner is a doctor
    var chatPartner = chat.users.firstWhere((element) => element.id != user.id);
    if (chatPartner is DoctorUser) {
      return chatPartner.name + ' (Doctor)';
    } else {
      return chatPartner.name;
    }
  }

  Future<List<Chat>> getAllChatsOfUser(ChatUser user) async {
    final res = <Chat>[];

    for (var chatId in user.chatIds) {
      var chatData = await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatId)
          .get();
      if (chatData.exists) {
        res.add(Chat.fromJson(chatData.data()!));
      }
    }

    return res;
  }

  String formatDateTime(DateTime datetime) {
    final now = DateTime.now();
    if (datetime.year == now.year &&
        datetime.month == now.month &&
        datetime.day == now.day) {
      return DateFormat(DateFormat.HOUR24_MINUTE).format(datetime);
    } else {
      return DateFormat.yMd().format(datetime);
    }
  }
}
