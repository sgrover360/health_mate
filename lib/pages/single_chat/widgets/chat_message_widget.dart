import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final DateTime timestamp;
  final String content;
  final bool isLocalSender;
  final String avatarAsset; // URL or asset name for the avatar image
  final bool isImage; // New parameter to indicate if the message is an image

  const ChatMessageWidget({
    Key? key,
    required this.timestamp,
    required this.content,
    required this.isLocalSender,
    required this.avatarAsset,
    this.isImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.6;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: isLocalSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isLocalSender) avatarWidget(),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: isLocalSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (isImage)
                  Image.network(
                    content,
                    width: maxWidth,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return const Icon(Icons.error);
                    },
                  )
                else
                  messageBubble(maxWidth),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    formatTimestamp(timestamp),
                    style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget avatarWidget() {
    return avatarAsset.startsWith('http')
        ? CircleAvatar(backgroundImage: NetworkImage(avatarAsset))
        : CircleAvatar(backgroundImage: AssetImage(avatarAsset));
  }

  Widget messageBubble(double maxWidth) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: isLocalSender ? Colors.blue[300] : Colors.grey[200],
        borderRadius: isLocalSender
            ? BorderRadius.circular(16).subtract(const BorderRadius.only(bottomRight: Radius.circular(16)))
            : BorderRadius.circular(16).subtract(const BorderRadius.only(bottomLeft: Radius.circular(16))),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Text(
          content,
          style: TextStyle(
            color: isLocalSender ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
          softWrap: true,
        ),
      ),
    );
  }

  String formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
