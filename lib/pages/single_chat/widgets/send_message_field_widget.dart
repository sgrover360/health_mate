import 'package:flutter/material.dart';

class SendMessageFieldWidget extends StatefulWidget {
  final Function(String)? onPressed;
  const SendMessageFieldWidget({Key? key, this.onPressed}) : super(key: key);

  @override
  State<SendMessageFieldWidget> createState() => _SendMessageFieldWidgetState();
}

class _SendMessageFieldWidgetState extends State<SendMessageFieldWidget> {
  TextEditingController? _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        //color: Colors.blue.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0x0C0091A6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(
                  child: TextField(
                    maxLines: 1,
                    controller: _messageController,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    decoration: const InputDecoration(
                        hintText: "Write a message!",
                        hintStyle: TextStyle(color: Color(0x7F0091A6),
                          fontSize: 14,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          height: 0,
                          letterSpacing: -0.30,),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)))),
                  )),
              const SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    widget.onPressed == null
                        ? null
                        : widget.onPressed!(_messageController?.text ?? "");

                    setState(() {
                      _messageController!.text = "";
                    });
                  },
                  icon: const Icon(Icons.send, color: Colors.blueAccent))
            ])));
  }
}
