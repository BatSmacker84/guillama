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
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('New Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: PlatformText('New Chat'),
            ),
          ),
        ],
      ),
    );
  }
}
