import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_mate/extensions/datetime_extensions.dart';
import 'package:health_mate/models/chat.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/pages/single_chat/single_chat_page.dart';

class ChatHeaderWidget extends StatelessWidget {
  final String chatName;
  final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  final ChatUser user;

  const ChatHeaderWidget(
      {required this.chatName,
        required this.stream,
        required this.user,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              var chat = snapshot.hasData
                  ? Chat.fromJson(snapshot.data!.data()!)
                  : null;
              var lastMessage = chat?.messages.last.content ?? " - ";
              var lastTimestamp =
                  chat?.messages.last.timestamp.toNicerTime() ?? " - ";

              return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(chatName),
                  subtitle: Text(lastMessage,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.blueGrey)),
                  trailing: Text(lastTimestamp,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.blueGrey)),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingleChatPage(chat!, user)));
                  });
            }));
  }
}
