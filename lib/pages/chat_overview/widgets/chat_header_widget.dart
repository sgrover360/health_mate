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

  const ChatHeaderWidget({
    required this.chatName,
    required this.stream,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            var chat = Chat.fromJson(snapshot.data!.data()!);
            var lastMessage = chat.messages.isNotEmpty
                ? chat.messages.last.content
                : "No messages yet";
            var lastTimestamp = chat.messages.isNotEmpty
                ? chat.messages.last.timestamp.toNicerTime()
                : " - ";

            return _buildChatTile(context, chat, lastMessage, lastTimestamp);
          } else if (snapshot.hasError) {
            return const ListTile(
              leading: Icon(Icons.error),
              title: Text('Error loading chat'),
            );
          } else {
            return const ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Loading...'),
            );
          }
        },
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, Chat chat, String lastMessage, String lastTimestamp) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.person, color: Colors.white),
      ),
      title: Text(chatName),
      subtitle: Text(
        lastMessage,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
      ),
      trailing: Text(
        lastTimestamp,
        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
      ),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SingleChatPage(chat, user),
        ));
      },
    );
  }
}
