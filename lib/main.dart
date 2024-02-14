import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:guillama/shared/data.dart';
import 'package:guillama/pages/home.dart';

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
  bool starting = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUILlama',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const Home(),
    );
  }
}
