import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_mate/models/chat.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/pages/single_chat/single_chat_controller.dart';
import 'package:health_mate/pages/single_chat/widgets/chat_message_widget.dart';
import 'package:health_mate/pages/single_chat/widgets/send_message_field_widget.dart';
import 'package:health_mate/widgets/loading_widget.dart';

class SingleChatPage extends StatefulWidget {
  final Chat chat;
  final ChatUser user;
  const SingleChatPage(this.chat, this.user, {Key? key}) : super(key: key);

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final SingleChatController _controller = SingleChatController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: SendMessageFieldWidget(onPressed: _sendMessage),
        appBar: AppBar(
            title: Text(_controller.getChatName(widget.chat, widget.user))),
        body: _buildMessagesWidget());
  }

  Widget _buildMessagesWidget() {
    return widget.chat.messages.isEmpty
        ? const Center(child: Text("Start a conversation!"))
        : Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 68),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .doc(widget.chat.id)
              .snapshots(),
          builder: (context, snapshot) {
            var myChat = snapshot.hasData
                ? Chat.fromJson(snapshot.data!.data()!)
                : null;

            return myChat == null
                ? const LoadingWidget()
                : ListView.separated(
                separatorBuilder: (context, index) =>
                const SizedBox(height: 5),
                itemCount: myChat.messages.length,
                itemBuilder: (context, index) {
                  var message = myChat.messages[index];
                  var isLocal = message.sender.id == widget.user.id;

                  return ChatMessageWidget(
                      timestamp: message.timestamp,
                      content: message.content,
                      isLocalSender: isLocal);
                });
          }),
    );
  }

  Future _sendMessage(String message) async {
    await _controller.sendMessage(widget.chat.id, widget.user, message);

    setState(() {});
  }
}
//
//
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:health_mate/models/chat.dart';
// import 'package:health_mate/models/chat_user.dart';
// import 'package:health_mate/pages/single_chat/single_chat_controller.dart';
// import 'package:health_mate/pages/single_chat/widgets/chat_message_widget.dart';
// import 'package:health_mate/pages/single_chat/widgets/send_message_field_widget.dart';
// import 'package:health_mate/widgets/loading_widget.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart';
//
// class SingleChatPage extends StatefulWidget {
//   final Chat chat;
//   final ChatUser user;
//
//   const SingleChatPage(this.chat, this.user, {Key? key}) : super(key: key);
//
//   @override
//   State<SingleChatPage> createState() => _SingleChatPageState();
// }
//
// class _SingleChatPageState extends State<SingleChatPage> {
//   final SingleChatController _controller = SingleChatController();
//
//   Future<void> _pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       final imageUrl = await _uploadImage(image.path);
//       await _sendMessage(imageUrl, isImage: true);
//     }
//   }
//
//   Future<String> _uploadImage(String filePath) async {
//     File file = File(filePath);
//     String fileName = basename(filePath);
//     Reference ref = FirebaseStorage.instance.ref().child('chat_images/$fileName');
//     UploadTask task = ref.putFile(file);
//
//     TaskSnapshot snapshot = await task;
//     return await snapshot.ref.getDownloadURL();
//   }
//
//   Future _sendMessage(String message, {bool isImage = false}) async {
//     await _controller.sendMessage(widget.chat.id, widget.user, message, isImage);
//
//     setState(() {});
//   }
//
//   Widget _buildMessagesWidget() {
//     return widget.chat.messages.isEmpty
//         ? const Center(child: Text("Start a conversation!"))
//         : Padding(
//       padding: const EdgeInsets.fromLTRB(8, 8, 8, 68),
//       child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection("chats")
//               .doc(widget.chat.id)
//               .snapshots(),
//           builder: (context, snapshot) {
//             var myChat = snapshot.hasData
//                 ? Chat.fromJson(snapshot.data!.data()!)
//                 : null;
//
//             return myChat == null
//                 ? const LoadingWidget()
//                 : ListView.separated(
//                 separatorBuilder: (context, index) => const SizedBox(height: 5),
//                 itemCount: myChat.messages.length,
//                 itemBuilder: (context, index) {
//                   var message = myChat.messages[index];
//                   var isLocal = message.sender.id == widget.user.id;
//
//                   return ChatMessageWidget(
//                       timestamp: message.timestamp,
//                       content: message.content,
//                       isLocalSender: isLocal);
//                 });
//           }),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(_controller.getChatName(widget.chat, widget.user))),
//       body: _buildMessagesWidget(),
//       bottomSheet: SendMessageFieldWidget(onPressed: (message) => _sendMessage(message)),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _pickImage,
//         child: Icon(Icons.photo),
//       ),
//     );
//   }
// }
