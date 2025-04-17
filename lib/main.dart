import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minecraft_controller/src/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return SafeArea(
      child: MaterialApp(
        title: 'Minecraft Controller',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Minecraft Seven v2",
        ),
        home: SplashScreen(),
      ),
    );
  }
}
