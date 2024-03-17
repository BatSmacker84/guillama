import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:beamer/beamer.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? serverAddress;
  int? serverPort;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? const Color.fromARGB(255, 240, 240, 240)
                      : const Color.fromARGB(255, 32, 32, 32),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                PlatformListTile(
                  leading: Icon(context.platformIcons.cloud),
                  title: PlatformText('Server Connection'),
                  trailing: Icon(context.platformIcons.rightChevron),
                  onTap: () {
                    Beamer.of(context).beamToNamed('/settings/server');
                  },
                ),
                const Divider(
                  indent: 64,
                  height: 5,
                  thickness: 1,
                ),
                PlatformListTile(
                  leading: Icon(context.platformIcons.star),
                  title: PlatformText('Models'),
                  trailing: Icon(context.platformIcons.rightChevron),
                  onTap: () {
                    Beamer.of(context).beamToNamed('/settings/models');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
