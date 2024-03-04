import "package:flutter/material.dart";
import "package:flutter_platform_widgets/flutter_platform_widgets.dart";

import "package:guillama/shared/data.dart";
import 'package:guillama/shared/api.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.chatID});

  final int chatID;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Chat ${widget.chatID}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: PlatformText('Chat ${widget.chatID}'),
            ),
          ),
        ],
      ),
    );
  }
}
