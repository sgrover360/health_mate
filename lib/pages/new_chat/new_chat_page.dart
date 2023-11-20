import 'package:flutter/material.dart';
import 'package:health_mate/models/chat.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/pages/new_chat/new_chat_controller.dart';
import 'package:health_mate/pages/single_chat/single_chat_page.dart';
import 'package:health_mate/widgets/loading_widget.dart';

import 'package:health_mate/widgets/exception_widget.dart';

class NewChatPage extends StatefulWidget {
  final ChatUser localUser;
  const NewChatPage(this.localUser, {Key? key}) : super(key: key);

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final NewChatController _controller = NewChatController();
  Future<List<ChatUser>>? _future;

  @override
  void initState() {
    super.initState();

    _future = _controller.getAllPossibleChatPartners(widget.localUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Select your partner")),
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingWidget();
              } else if (snapshot.hasData) {
                return snapshot.data!.isEmpty
                    ? const Center(child: Text("No chat users found!"))
                    : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const CircleAvatar(
                            child: Icon(Icons.person)),
                        title: Text(snapshot.data![index].name),
                        onTap: () async =>
                            _startNewChat(snapshot.data![index]),
                      ),
                    ));
              }

              return const ExceptionWidget();
            }));
  }

  Future _startNewChat(ChatUser chatPartner) async {
    Chat? chat =
    await _controller.getExistingChat(widget.localUser, chatPartner);

    chat ??= await _controller.createNewChat(widget.localUser, chatPartner);

    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SingleChatPage(chat!, widget.localUser)));
  }
}
