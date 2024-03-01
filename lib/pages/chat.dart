import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_platform_widgets/flutter_platform_widgets.dart";

import "package:guillama/shared/data.dart";
import 'package:guillama/shared/api.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<String>? models;

  @override
  void initState() {
    super.initState();

    API.listModels().then((value) {
      setState(() {
        models = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Chat'),
      ),
      body: models == null
          ? Center(child: PlatformCircularProgressIndicator())
          : ListView.builder(
              itemCount: models?.length ?? 0,
              itemBuilder: (context, index) {
                return PlatformText(models![index],
                    textAlign: TextAlign.center);
              },
            ),
    );
  }
}
