import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:guillama/shared/data.dart';

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

    serverAddress = Prefs.getString('serverAddress');
    serverPort = Prefs.getInt('serverPort');
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Settings'),
      ),
      body: ListView(
        children: [
          PlatformListTile(
            title: PlatformText('Server Address'),
            subtitle: Text(serverAddress!),
            onTap: () async {
              final result = await showPlatformDialog<String>(
                context: context,
                builder: (context) {
                  return _serverAddressDialog(serverAddress!);
                },
              );

              if (result != null) {
                await Prefs.setString('serverAddress', result);
                setState(() {
                  serverAddress = result;
                });
              }
            },
          ),
          PlatformListTile(
            title: PlatformText('Server Port'),
            subtitle: Text(serverPort.toString()),
            onTap: () async {
              final result = await showPlatformDialog<String>(
                context: context,
                builder: (context) {
                  return _serverPortDialog(serverPort.toString());
                },
              );

              if (result != null) {
                await Prefs.setInt('serverPort', int.parse(result));
                setState(() {
                  serverPort = int.parse(result);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _serverAddressDialog(String initial) {
    TextEditingController controller = TextEditingController(text: initial);
    String? serverAddress;

    return PlatformAlertDialog(
      title: PlatformText('Server Address'),
      content: PlatformTextField(
        controller: controller,
        keyboardType: TextInputType.url,
        onChanged: (value) {
          serverAddress = value;
        },
        onSubmitted: (value) {
          if (serverAddress != null) {
            controller.text = serverAddress!;
          }
        },
      ),
      actions: [
        PlatformDialogAction(
          child: PlatformText('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        PlatformDialogAction(
          child: PlatformText('OK'),
          onPressed: () {
            Navigator.pop(context, serverAddress);
          },
        ),
      ],
    );
  }

  Widget _serverPortDialog(String initial) {
    TextEditingController controller = TextEditingController(text: initial);
    String? serverPort;

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
          child: PlatformText('OK'),
          onPressed: () {
            Navigator.pop(context, serverPort);
          },
        ),
      ],
    );
  }
}
