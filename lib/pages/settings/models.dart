import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:guillama/shared/api.dart';
import 'package:guillama/shared/data.dart';

class ModelsSettings extends StatefulWidget {
  const ModelsSettings({super.key});

  @override
  State<ModelsSettings> createState() => _ModelsSettingsState();
}

class _ModelsSettingsState extends State<ModelsSettings> {
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
        title: PlatformText('Models'),
      ),
      body: ListView.separated(
        itemCount: models?.length ?? 0,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return PlatformListTile(
            title: PlatformText(models?[index] ?? 'Loading...'),
          );
        },
      ),
    );
  }
}
