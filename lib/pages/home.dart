import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:beamer/beamer.dart';

import 'package:guillama/shared/api.dart';
import 'package:guillama/shared/data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String>? chats;

  @override
  void initState() {
    super.initState();

    chats = Prefs.getStringList('chats');
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
      body: chats == null || chats!.isEmpty
          ? Center(child: PlatformText('No chats'))
          : ListView.builder(
              itemCount: chats!.length,
              itemBuilder: (context, index) {
                return PlatformListTile(
                  title: PlatformText(chats![index].split('_')[1]),
                  onTap: () {
                    Beamer.of(context)
                        .beamToNamed('/chats/chat-${chats![index]}');
                  },
                );
              },
            ),
    );
  }
}
