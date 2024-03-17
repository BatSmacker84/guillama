import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:beamer/beamer.dart';

import 'package:guillama/shared/api.dart';
import 'package:guillama/shared/data.dart';
import 'package:guillama/models/model.dart';

class ModelsSettings extends StatefulWidget {
  const ModelsSettings({super.key});

  @override
  State<ModelsSettings> createState() => _ModelsSettingsState();
}

class _ModelsSettingsState extends State<ModelsSettings> {
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
        title: PlatformText('Models'),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.add),
            onPressed: () {
              print('Add');
            },
          ),
        ],
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
                  Beamer.of(context).beamToNamed('/settings/models/$name:$tag');
                },
              ),
              const Divider(height: 0),
            ],
          ),
      ],
    );
  }
}

class ModelInfo extends StatefulWidget {
  const ModelInfo({super.key, required this.modelID});

  final String modelID;

  @override
  State<ModelInfo> createState() => _ModelInfoState();
}

class _ModelInfoState extends State<ModelInfo> {
  Model? model;

  @override
  void initState() {
    super.initState();

    API.showModel(widget.modelID).then((value) {
      setState(() {
        model = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: PlatformText(widget.modelID),
      ),
      body: model == null
          ? Center(
              child: PlatformCircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  PlatformText('Name: ${model!.name}'),
                  const SizedBox(height: 10),
                  PlatformText('Tag: ${model!.tag}'),
                  const SizedBox(height: 10),
                  PlatformText('Format: ${model!.format}'),
                  const SizedBox(height: 10),
                  PlatformText('Family: ${model!.family}'),
                  const SizedBox(height: 10),
                  if (model!.families != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlatformText(
                            'Families: ${model!.families!.join(', ')}'),
                        const SizedBox(height: 10),
                      ],
                    ),
                  PlatformText('Parameter Size: ${model!.parameter_size}'),
                  const SizedBox(height: 10),
                  PlatformText(
                      'Quantization Level: ${model!.quantization_level}'),
                ],
              ),
            ),
    );
  }
}
