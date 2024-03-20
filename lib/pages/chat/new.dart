import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:guillama/shared/api.dart';
import 'package:guillama/shared/data.dart';

class New extends StatefulWidget {
  const New({super.key});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  List<String>? models;
  Map<String, List<String>>? sortedModels;

  @override
  void initState() {
    super.initState();

    API.listModels().then((value) {
      setState(() {
        models = value;
      });
      sortModels();
    });
  }

  void sortModels() {
    final Map<String, List<String>> sorted = {};
    for (final model in models ?? []) {
      final name = model.split(':')[0];
      final tag = model.split(':')[1];
      if (sorted.containsKey(name)) {
        sorted[name]!.add(tag);
      } else {
        sorted[name] = [tag];
      }
    }
    setState(() {
      sortedModels = sorted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Select Model'),
      ),
      body: sortedModels == null
          ? Center(
              child: PlatformCircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  setState(() {
                    sortedModels = null;
                  });
                  await API.listModels().then((value) {
                    setState(() {
                      models = value;
                    });
                    sortModels();
                  });
                },
                child: ListView.builder(
                  itemCount: sortedModels?.length ?? 0,
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildModelName(sortedModels!.keys.elementAt(index)),
                      buildModelTags(sortedModels!.keys.elementAt(index)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildModelName(String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlatformText(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Divider(height: 0),
        ],
      ),
    );
  }

  Widget buildModelTags(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final tag in sortedModels![name]!)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlatformListTile(
                title: PlatformText(tag),
                trailing: Icon(context.platformIcons.rightChevron),
                onTap: () {
                  Beamer.of(context).beamToNamed('/new/$name:$tag');
                },
              ),
              const Divider(height: 0),
            ],
          ),
      ],
    );
  }
}

class NewChat extends StatefulWidget {
  const NewChat({super.key, required this.modelID});

  final String modelID;

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  TextEditingController chatNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: PlatformText('New Chat with ${widget.modelID}'),
        trailingActions: [
          PlatformTextButton(
            child: PlatformText('Create'),
            onPressed: () {
              if (chatNameController.text.isNotEmpty) {
                Prefs.createChat(widget.modelID, chatNameController.text);
                Beamer.of(context).beamToReplacementNamed(
                    '/chats/chat-${widget.modelID}_${chatNameController.text}');
              } else {
                showPlatformDialog(
                  context: context,
                  builder: (_) => PlatformAlertDialog(
                    title: PlatformText('Error'),
                    content: PlatformText('Chat Name cannot be empty'),
                    actions: [
                      PlatformDialogAction(
                        child: PlatformText('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? const Color.fromARGB(255, 200, 200, 200)
                            : const Color.fromARGB(255, 55, 55, 55),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: PlatformIconButton(
                      icon: Icon(context.platformIcons.photoCamera),
                      onPressed: () {
                        print('Add Chat Picture');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PlatformTextField(
                      controller: chatNameController,
                      material: (_, __) => MaterialTextFieldData(
                        decoration: const InputDecoration(
                          hintText: 'Chat Name',
                          border: InputBorder.none,
                        ),
                      ),
                      cupertino: (_, __) => CupertinoTextFieldData(
                        placeholder: 'Chat Name',
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? const Color.fromARGB(255, 200, 200, 200)
                                : const Color.fromARGB(255, 55, 55, 55),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
