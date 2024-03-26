import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_platform_widgets/flutter_platform_widgets.dart";

import "package:guillama/shared/data.dart";
import 'package:guillama/shared/api.dart';
import 'package:guillama/models/message.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.chatID});

  final String chatID;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageController = TextEditingController();

  late List<Message>? allMessages;

  String? recUserMsg;
  String? recModelMsg;

  Stream? msgStream;
  StreamSubscription? msgSub;
  dynamic msgEvent;

  bool loading = false, generating = false;

  @override
  void initState() {
    super.initState();

    allMessages = Prefs.messages[widget.chatID.replaceFirst('chat-', '')];
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Row(
          children: [
            const SizedBox(width: 20),
            Icon(context.platformIcons.accountCircle),
            const SizedBox(width: 10),
            PlatformText(widget.chatID.split('_')[1]),
          ],
        ),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.settings),
            onPressed: () {
              print('Settings for ${widget.chatID}');
            },
          ),
        ],
      ),
      body: allMessages == null
          ? Center(child: PlatformText('No messages'))
          : SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: allMessages!.length,
                      itemBuilder: (context, index) {
                        final message =
                            allMessages![allMessages!.length - (index + 1)];
                        if (message.content.isNotEmpty) {
                          return Row(
                            mainAxisAlignment: message.role == 'user'
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              message.role == 'user'
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          top: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      padding: const EdgeInsets.all(10),
                                      transformAlignment: Alignment.centerRight,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: PlatformText(
                                        message.content,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ))
                                  : Container(
                                      margin: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          top: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: PlatformText(
                                        message.content,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                              generating && index == 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(10),
                                      child:
                                          PlatformCircularProgressIndicator(),
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  loading
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: PlatformCircularProgressIndicator(),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: PlatformTextField(
                            controller: messageController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.send,
                            hintText: 'Message',
                            onSubmitted: (msg) {
                              sendMsg(msg);
                              messageController.clear();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        PlatformIconButton(
                          icon: Icon(context.platformIcons.upArrow),
                          onPressed: () {
                            sendMsg(messageController.text);
                            messageController.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void sendMsg(String msg) {
    final modelID = widget.chatID.split('_')[0].replaceFirst('chat-', '');

    final newMsg = Message(role: 'user', content: msg);
    setState(() {
      allMessages!.add(newMsg);
    });
    Prefs.messages[widget.chatID.replaceFirst('chat-', '')] = allMessages!;
    Prefs.saveChats();

    setState(() {
      recModelMsg = null;
      msgStream = API.sendChat(modelID, allMessages!).asBroadcastStream();
      loading = true;
      allMessages!.add(Message(role: 'assistant', content: ''));
    });
    msgSub = msgStream!.listen((event) {
      if (event['message']['content'] != null) {
        setState(() {
          allMessages!.last.content =
              allMessages!.last.content + event['message']['content'];
          if (loading) {
            loading = false;
            generating = true;
          }
        });
      }
    }, onError: (error) {
      debugPrint('Error: $error');
      setState(() {
        loading = false;
        generating = false;
        allMessages!.last.content = 'Error: $error';
      });
    }, onDone: () {
      setState(() {
        loading = false;
        generating = false;
      });
      Prefs.messages[widget.chatID.replaceFirst('chat-', '')] = allMessages!;
      Prefs.saveChats();
    });
  }

  @override
  void dispose() {
    msgSub?.cancel();
    super.dispose();
  }
}
