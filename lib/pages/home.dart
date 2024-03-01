import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:guillama/pages/chat.dart';
import 'package:guillama/pages/settings.dart';
import 'package:guillama/shared/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PlatformTabController tabController;
  bool connecting = true;

  @override
  void initState() {
    super.initState();
    tabController = PlatformTabController(initialIndex: 0);

    API.connect().then((value) {
      setState(() {
        connecting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      tabController: tabController,
      bodyBuilder: (context, index) => IndexedStack(
        index: index,
        children: const [
          Chat(),
          Settings(),
        ],
      ),
      items: [
        BottomNavigationBarItem(
            label: 'Chat',
            icon: Icon(context.platformIcons.conversationBubbleOutline),
            activeIcon: Icon(context.platformIcons.conversationBubble),
            tooltip: 'Chat with AI models'),
        BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(context.platformIcons.settings),
            activeIcon: Icon(context.platformIcons.settingsSolid),
            tooltip: 'Change settings'),
      ],
    );
  }
}
