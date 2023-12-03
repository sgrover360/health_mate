import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_mate/models/chat.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/pages/single_chat/single_chat_controller.dart';
import 'package:health_mate/pages/single_chat/widgets/chat_message_widget.dart';
import 'package:health_mate/pages/single_chat/widgets/send_message_field_widget.dart';
import 'package:health_mate/widgets/loading_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class SingleChatPage extends StatefulWidget {
  final Chat chat;
  final ChatUser user;
  const SingleChatPage(this.chat, this.user, {Key? key}) : super(key: key);

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final SingleChatController _controller = SingleChatController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SendMessageFieldWidget(
        onSendMessage: _sendMessage,
        onSendImage: _sendImage,
      ),
      appBar: AppBar(
        title: Text(_controller.getChatName(widget.chat, widget.user)),
      ),
      body: _buildMessagesWidget(),
    );
  }

  Widget _buildMessagesWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 68),
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .doc(widget.chat.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var myChat = Chat.fromJson(snapshot.data!.data() as Map<String, dynamic>);
              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
              return ListView.separated(
                  controller: _scrollController,
                  separatorBuilder: (context, index) => const SizedBox(height: 5),
                  itemCount: myChat.messages.length,
                  itemBuilder: (context, index) {
                    var message = myChat.messages[index];
                    var isLocal = message.sender.id == widget.user.id;
                    bool isImage = message.content.startsWith('http'); // Example check for image URL

                    return ChatMessageWidget(
                        timestamp: message.timestamp,
                        content: message.content,
                        avatarAsset: 'assets/doctor.png',
                        isLocalSender: isLocal,
                        isImage: isImage); // Pass the isImage flag
                  });
            } else {
              return const LoadingWidget();
            }
          }),
    );
  }

  Future<void> _sendMessage(String message) async {
    await _controller.sendMessage(widget.chat.id, widget.user, message);
    _scrollToBottom();
  }

  Future<void> _sendImage(XFile imageFile) async {
    String imageUrl = await _uploadImageToFirebase(imageFile.path);
    await _controller.sendMessage(widget.chat.id, widget.user, imageUrl);
    _scrollToBottom();
  }

  Future<String> _uploadImageToFirebase(String imagePath) async {
    File file = File(imagePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${widget.user.id}';
    Reference ref = FirebaseStorage.instance.ref().child('chat_images/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
