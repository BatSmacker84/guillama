import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:guillama/shared/api.dart';
import 'package:guillama/shared/data.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  Map<String, Stream>? downloads;
  Map<Stream, StreamSubscription> subscriptions = {};
  Map<Stream, dynamic> events = {};

  @override
  void initState() {
    super.initState();
    downloads = Prefs.downloads;
    getSubs();
  }

  void getSubs() {
    for (final stream in downloads!.values) {
      setState(() {
        subscriptions[stream.asBroadcastStream()] = stream.listen(
          (event) => subEvent(stream, event),
          onError: subError,
          onDone: () => subDone(stream),
        );
      });
    }
  }

  void subEvent(stream, event) {
    setState(() {
      events[stream] = event;
    });
  }

  void subError(error) {
    print('Error: $error');
  }

  void subDone(stream) {
    Prefs.downloads.removeWhere((key, value) => value == stream);
    setState(() {
      downloads = Prefs.downloads;
      getSubs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Downloads'),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.add),
            onPressed: () {
              showPlatformDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController nameController =
                        TextEditingController();
                    TextEditingController tagController =
                        TextEditingController();
                    return PlatformAlertDialog(
                      title: PlatformText('Pull Model'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 5),
                          PlatformTextField(
                            controller: nameController,
                            hintText: 'Name',
                          ),
                          const SizedBox(height: 5),
                          PlatformTextField(
                            controller: tagController,
                            hintText: 'Tag (optional)',
                          ),
                        ],
                      ),
                      actions: [
                        PlatformDialogAction(
                          child: PlatformText('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        PlatformDialogAction(
                          child: PlatformText('Pull'),
                          onPressed: () {
                            if (nameController.text.isEmpty) {
                              print('Name cannot be empty');
                            } else {
                              if (tagController.text.isEmpty) {
                                tagController.text = 'latest';
                              }
                              final modelID =
                                  '${nameController.text}:${tagController.text}';
                              final stream =
                                  API.pullModel(modelID).asBroadcastStream();
                              Prefs.addDownload(modelID, stream);
                              setState(() {
                                downloads = Prefs.downloads;
                                getSubs();
                              });
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: downloads == null
          ? Center(child: PlatformCircularProgressIndicator())
          : downloads!.isEmpty
              ? Center(child: PlatformText('No Downloads'))
              : ListView.builder(
                  itemCount: downloads!.length,
                  itemBuilder: (context, index) {
                    final modelID = downloads!.keys.elementAt(index);
                    final event = events[downloads!.values.elementAt(index)];
                    return event != null
                        ? PlatformListTile(
                            title: PlatformText(modelID),
                            subtitle:
                                PlatformText(event['status'] ?? 'Unknown'),
                            trailing: event['completed'] != null &&
                                    event['total'] != null
                                ? CircularProgressIndicator(
                                    value: (event['completed'] ?? 0) /
                                        (event['total'] ?? 1),
                                  )
                                : null,
                          )
                        : PlatformListTile(
                            title: PlatformText(modelID),
                            subtitle: PlatformText('Unknown'),
                            trailing: PlatformCircularProgressIndicator(),
                          );
                  },
                ),
    );
  }

  @override
  void dispose() {
    for (final sub in subscriptions.values) {
      sub.cancel();
    }
    super.dispose();
  }
}
