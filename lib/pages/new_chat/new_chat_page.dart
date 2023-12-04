import 'package:flutter/material.dart';
import 'package:health_mate/models/chat.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/models/doctor_user.dart';
import 'package:health_mate/pages/new_chat/new_chat_controller.dart';
import 'package:health_mate/pages/single_chat/single_chat_page.dart';
import 'package:health_mate/widgets/exception_widget.dart';
import 'package:health_mate/widgets/loading_widget.dart';

class NewChatPage extends StatefulWidget {
  final ChatUser localUser;
  const NewChatPage(this.localUser, {Key? key}) : super(key: key);

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final NewChatController _controller = NewChatController();
  Future<List<DoctorUser>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _controller.getAllPossibleChatPartners(widget.localUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Select your doctor")),
        body: FutureBuilder<List<DoctorUser>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingWidget();
              } else if (snapshot.hasError) {
                // Log the error
                debugPrint('Error fetching doctors: ${snapshot.error}');
                return const ExceptionWidget(); // Show error widget
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(child: Text("No doctors found!"));
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].specialization),
                        onTap: () async => _startNewChat(snapshot.data![index]),
                      ),
                    ));
              } else {
                return const ExceptionWidget(); // Show error widget for any other case
              }
            }));
  }

  Future _startNewChat(DoctorUser doctorPartner) async {
    Chat? chat = await _controller.getExistingChat(widget.localUser, doctorPartner);
    chat ??= await _controller.createNewChat(widget.localUser, doctorPartner);
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SingleChatPage(chat!, widget.localUser)));
  }
}
