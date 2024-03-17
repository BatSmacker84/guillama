import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:beamer/beamer.dart';

import 'package:guillama/shared/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool connected = false;

  List<String>? models;

  @override
  void initState() {
    super.initState();

    API.connect().then((value) {
      setState(() {
        connected = value;
      });
    });

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
        title: PlatformText('Chats'),
        leading: PlatformIconButton(
          icon: Icon(context.platformIcons.checkMarkCircledOutline),
          onPressed: () {
            print('Select');
          },
        ),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.add),
            onPressed: () {
              Beamer.of(context).beamToNamed('/new');
            },
          ),
          PlatformIconButton(
            icon: Icon(context.platformIcons.settings),
            onPressed: () {
              Beamer.of(context).beamToNamed('/settings');
            },
          ),
        ],
      ),
      body: !connected
          ? Center(child: PlatformCircularProgressIndicator())
          : Center(child: PlatformText('Chats')),
    );
  }
}
