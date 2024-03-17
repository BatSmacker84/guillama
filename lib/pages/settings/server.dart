import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:guillama/shared/api.dart';
import 'package:guillama/shared/data.dart';

class ServerSettings extends StatefulWidget {
  const ServerSettings({super.key});

  @override
  State<ServerSettings> createState() => _ServerSettingsState();
}

class _ServerSettingsState extends State<ServerSettings> {
  String? serverAddress;
  int? serverPort;
  bool? useHTTPS;

  bool connecting = false;
  String connButtonText = 'No Changes';

  @override
  void initState() {
    super.initState();

    serverAddress = Prefs.getString('serverAddress');
    serverPort = Prefs.getInt('serverPort');
    useHTTPS = Prefs.getBool('https');
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: PlatformText('Server Connection'),
      ),
      body: Column(
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
                  leading: Icon(context.platformIcons.home),
                  title: PlatformText('Address'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlatformText(serverAddress ?? 'Not set'),
                      const SizedBox(width: 10),
                      Icon(context.platformIcons.rightChevron),
                    ],
                  ),
                  onTap: () {
                    showPlatformDialog(
                        context: context,
                        builder: (_) {
                          TextEditingController controller =
                              TextEditingController(text: serverAddress ?? '');
                          return PlatformAlertDialog(
                            title: PlatformText('Server Address'),
                            content: PlatformTextField(controller: controller),
                            actions: [
                              PlatformDialogAction(
                                child: PlatformText('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              PlatformDialogAction(
                                child: PlatformText('Save'),
                                onPressed: () {
                                  setState(() {
                                    serverAddress = controller.text;
                                    connButtonText = 'Save Changes';
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                const Divider(
                  indent: 64,
                  height: 5,
                  thickness: 1,
                ),
                PlatformListTile(
                  leading: Icon(context.platformIcons.info),
                  title: PlatformText('Port'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlatformText(serverPort?.toString() ?? 'Not set'),
                      const SizedBox(width: 10),
                      Icon(context.platformIcons.rightChevron),
                    ],
                  ),
                  onTap: () {
                    showPlatformDialog(
                        context: context,
                        builder: (_) {
                          TextEditingController controller =
                              TextEditingController(
                                  text: serverPort?.toString() ?? '');
                          return PlatformAlertDialog(
                            title: PlatformText('Server Port'),
                            content: PlatformTextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                            ),
                            actions: [
                              PlatformDialogAction(
                                child: PlatformText('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              PlatformDialogAction(
                                child: PlatformText('Save'),
                                onPressed: () {
                                  setState(() {
                                    serverPort = int.parse(controller.text);
                                    connButtonText = 'Save Changes';
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                const Divider(
                  indent: 64,
                  height: 5,
                  thickness: 1,
                ),
                PlatformListTile(
                  leading: Icon(context.platformIcons.padlockOutline),
                  title: PlatformText('Use HTTPS'),
                  trailing: PlatformSwitch(
                    value: useHTTPS ?? false,
                    onChanged: (value) {
                      setState(() {
                        useHTTPS = value;
                        connButtonText = 'Save Changes';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PlatformText(
            'http${useHTTPS! ? 's' : ''}://${serverAddress!}:${serverPort!.toString()}',
          ),
          const Spacer(),
          PlatformTextButton(
            onPressed: connecting || connButtonText == 'No Changes'
                ? null
                : () {
                    testConnection();
                  },
            child: PlatformText(
              connecting ? 'Attempting Connection...' : connButtonText,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void testConnection() async {
    setState(() {
      connecting = true;
    });

    // Wait 200ms to show the connecting message
    await Future.delayed(const Duration(milliseconds: 200));

    // Test connection
    bool connected = false;
    try {
      connected = await API.testConnection(
          'http${useHTTPS! ? 's' : ''}://$serverAddress:$serverPort');
    } catch (e) {
      connected = false;
    }

    // Save changes
    if (connected) {
      Prefs.setString('serverAddress', serverAddress!);
      Prefs.setInt('serverPort', serverPort!);
      Prefs.setBool('https', useHTTPS!);
    }

    setState(() {
      connecting = false;
      connButtonText = connected
          ? 'Connection Successful and Saved Changes!'
          : 'Connection Failed';
    });
  }
}
