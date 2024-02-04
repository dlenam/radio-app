import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radio_app/features/splash_screen.dart';
import 'package:radio_app/infra/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Fixes CERTIFICATE_VERIFY_FAILED error while in development
  HttpOverrides.global = MyHttpOverrides();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
