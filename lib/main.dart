import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:beamer/beamer.dart';

import 'package:guillama/shared/api.dart';
import 'package:guillama/shared/data.dart';
import 'package:guillama/pages/start.dart';
import 'package:guillama/pages/home.dart';
import 'package:guillama/pages/settings/settings.dart';
import 'package:guillama/pages/settings/server.dart';
import 'package:guillama/pages/settings/models.dart';
import 'package:guillama/pages/chat/chat.dart';
import 'package:guillama/pages/chat/new.dart';

// Main function is async so we can await the initialization
// of the persistent data before running the app
Future<void> main() async {
  // Ensure the widgets binding is initialized for splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Ensure the app is in portrait mode
  // This shouldn't affect tablets, as they are usually in landscape mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize the persistent data
  await Prefs.init();

  // Check if first start
  if (Prefs.getString('serverAddress') == null ||
      Prefs.getInt('serverPort') == null) {
    Prefs.setBool('firstStart', true);
  }

  // Remove the splash screen
  FlutterNativeSplash.remove();

  // Run the app
  runApp(const GUILlama());
}

class GUILlama extends StatefulWidget {
  const GUILlama({super.key});

  @override
  State<GUILlama> createState() => _GUILlamaState();
}

class _GUILlamaState extends State<GUILlama> {
  final routerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => const Home(key: ValueKey('home')),
        '/start': (context, state, data) => const Start(key: ValueKey('start')),
        '/settings': (context, state, data) =>
            const Settings(key: ValueKey('settings')),
        '/settings/server': (context, state, data) => const ServerSettings(
              key: ValueKey('server'),
            ),
        '/settings/models': (context, state, data) => const ModelsSettings(
              key: ValueKey('models'),
            ),
        '/new': (context, state, data) => const New(key: ValueKey('new')),
        '/chats/:chatID': (context, state, data) {
          final chatID = state.pathParameters['chatID'];
          return BeamPage(
            key: ValueKey('chat-$chatID'),
            popToNamed: '/',
            child: Chat(chatID: int.parse(chatID!)),
          );
        }
      },
    ).call,
    guards: [
      BeamGuard(
        pathPatterns: ['/start'],
        guardNonMatching: true,
        check: (context, state) => Prefs.getBool('firstStart') ?? true,
        beamToNamed: (origin, target) => '/start',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      builder: (context) => PlatformTheme(
        themeMode: ThemeMode.system,
        materialLightTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        materialDarkTheme: ThemeData.dark(),
        cupertinoLightTheme:
            const CupertinoThemeData(primaryColor: Colors.deepPurple),
        cupertinoDarkTheme:
            const CupertinoThemeData(brightness: Brightness.dark),
        builder: (context) => PlatformApp.router(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          title: 'GUILlama',
          routerDelegate: routerDelegate,
          routeInformationParser: BeamerParser(),
        ),
      ),
    );
  }
}
