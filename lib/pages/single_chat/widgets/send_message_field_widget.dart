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
      width: 375,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C0091A6),
            blurRadius: 5,
            offset: Offset(0, -1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Color(0xFF0091A6)),
            onPressed: () {
              // Handle attachment
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Color(0xFF0091A6)),
            onPressed: () {
              // Handle camera
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: ShapeDecoration(
                color: const Color(0x140090A6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: TextField(
                controller: _messageController,
                keyboardType: TextInputType.multiline,
                maxLines: null, // Allows the input to wrap to a new line
                style: const TextStyle(
                  color: Color(0xFF0091A6),
                  fontSize: 14,
                  fontFamily: 'Raleway',
                ),
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    color: Color(0x7F0091A6),
                    fontSize: 14,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.30,
                  ),
                  border: InputBorder.none, // No border
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Adjust padding
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF0091A6)),
            onPressed: () {
              widget.onPressed?.call(_messageController?.text ?? "");
              _messageController?.clear();
            },
          ),
        ],
      ),
    );
  }
}
