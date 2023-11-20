import 'package:flutter/material.dart';
import 'package:health_mate/extensions/datetime_extensions.dart';

class ChatMessageWidget extends StatelessWidget {
  final DateTime timestamp;
  final String content;
  final bool isLocalSender;

  const ChatMessageWidget(
      {Key? key,
        required this.timestamp,
        required this.content,
        required this.isLocalSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isLocalSender
          ? const EdgeInsets.only(left: 100)
          : const EdgeInsets.only(right: 100),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isLocalSender ? const Color(0x2623B855) : const Color(0xFFF1F4F9),
        leading: !isLocalSender
            ? const CircleAvatar(child: Icon(Icons.person))
            : null,
        title: Text(content,
          style: const TextStyle(
            color: Color(0xFF0C1E25),
            fontSize: 16,
            fontFamily: 'Rale way',
            fontWeight: FontWeight.w400,
            height: 0,
            letterSpacing: 0.28,
          ),),
        subtitle: Text(
          timestamp.toNicerTime(),
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
        ),
        // Removed the trailing property
      ),
    );
  }

}
