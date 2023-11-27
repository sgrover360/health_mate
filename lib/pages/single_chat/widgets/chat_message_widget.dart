import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final DateTime timestamp;
  final String content;
  final bool isLocalSender;
  final String avatarAsset; // URL or asset name for the avatar image

  const ChatMessageWidget({
    Key? key,
    required this.timestamp,
    required this.content,
    required this.isLocalSender,
    required this.avatarAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a maximum width for the message bubble
    final maxWidth = MediaQuery.of(context).size.width * 0.6;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment:
        isLocalSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isLocalSender) ...[
            CircleAvatar(
              backgroundImage: AssetImage(avatarAsset),
            ),
            const SizedBox(width: 10),
          ],
          Flexible( // Wrap the message container in a Flexible widget
            child: Column(
              crossAxisAlignment: isLocalSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isLocalSender ? Colors.blue[300] : Colors.grey[200],
                    borderRadius: isLocalSender
                        ? BorderRadius.circular(16).subtract(const BorderRadius.only(bottomRight: Radius.circular(16)))
                        : BorderRadius.circular(16).subtract(const BorderRadius.only(bottomLeft: Radius.circular(16))),
                  ),
                  child: ConstrainedBox( // Constrain the width of the message
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Text(
                      content,
                      style: TextStyle(
                        color: isLocalSender ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                      softWrap: true, // Ensure text wraps
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    formatTimestamp(timestamp),
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatTimestamp(DateTime timestamp) {
    // Placeholder for your timestamp formatting logic
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
