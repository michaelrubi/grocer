import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocer/services/models.dart';
import 'package:grocer/home/home.dart';
import 'package:grocer/shared/styles.dart';
import 'package:grocer/theme.dart';

void main() async {
  await initHive();
  runApp(const ProviderScope(child: App()));
  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor:
          Colors.transparent, // Blends with the gesture bar
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light));
//Setting SystemUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      title: 'Grocer',
      debugShowCheckedModeBanner: false,
      // home: const TestPage(),
      home: const HomePage(),
      color: Col.menu,
    );
  }
}
