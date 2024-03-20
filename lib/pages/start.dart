import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:beamer/beamer.dart';

import 'package:guillama/shared/data.dart';
import 'package:guillama/shared/api.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  late bool https;
  late String serverAddress;
  late int serverPort;

  String url = '';
  bool connecting = false;

  @override
  void initState() {
    super.initState();

    https = Prefs.getBool('https') ?? false;
    serverAddress = Prefs.getString('serverAddress') ?? 'localhost';
    serverPort = Prefs.getInt('serverPort') ?? 11434;

    url = getURL();
  }

  String getURL() {
    return '${https ? 'https' : 'http'}://$serverAddress:$serverPort';
  }

  Future<void> connect() async {
    setState(() {
      connecting = true;
    });

    Prefs.setBool('https', https);
    Prefs.setString('serverAddress', serverAddress);
    Prefs.setInt('serverPort', serverPort);

    final result = await API.connect();

    setState(() {
      connecting = false;
    });

    if (result) {
      toHome();
    } else {
      connectionError();
    }
  }

  void toHome() {
    Prefs.setBool('firstStart', false);
    Beamer.of(context).beamToNamed('/');
  }

  void connectionError() {
    showPlatformDialog(
      context: context,
      builder: (context) {
        return PlatformAlertDialog(
          title: PlatformText('Error'),
          content: PlatformText('Could not connect to the server'),
          actions: [
            PlatformDialogAction(
              child: PlatformText('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: connecting
          ? Center(
              child: PlatformCircularProgressIndicator(),
            )
          : Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      PlatformText('Use HTTPS'),
                      const SizedBox(width: 8),
                      PlatformSwitch(
                        value: https,
                        onChanged: (value) {
                          setState(() {
                            https = value;
                            url = getURL();
                          });
                        },
                      ),
                    ],
                  ),
                  PlatformTextFormField(
                    initialValue: serverAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() {
                        serverAddress = value;
                        url = getURL();
                      });
                    },
                    material: (_, __) => MaterialTextFormFieldData(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    cupertino: (_, __) => CupertinoTextFormFieldData(
                      prefix: const Icon(CupertinoIcons.location),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  PlatformTextFormField(
                    initialValue: serverPort.toString(),
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      setState(() {
                        serverPort = int.parse(value);
                        url = getURL();
                      });
                    },
                    material: (_, __) => MaterialTextFormFieldData(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    cupertino: (_, __) => CupertinoTextFormFieldData(
                      prefix: const Icon(CupertinoIcons.location),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  PlatformText(url, textAlign: TextAlign.center),
                  PlatformTextButton(
                    child: PlatformText('Connect'),
                    onPressed: () {
                      connect();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
