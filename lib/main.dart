import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:radio_app/features/radio_list/cubit/radio_list_cubit.dart';
import 'package:radio_app/features/radio_list/data/radio_station_api_data_source.dart';
import 'package:radio_app/features/radio_list/data/radio_station_repository.dart';
import 'package:radio_app/features/radio_player/cubit/radio_player_cubit.dart';
import 'package:radio_app/features/radio_player/data/radio_volume_repository.dart';
import 'package:radio_app/features/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Fixes CERTIFICATE_VERIFY_FAILED error while in development
  HttpOverrides.global = MyHttpOverrides();
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

void setupDependencies() async {
  final getIt = GetIt.instance;
  final radioStationApiClient = RadioStationApiDataSource(http.Client());
  final radioStationRepository =
      RadioStationRepository(radioStationApiClient: radioStationApiClient);
  final sharedPreferences = await SharedPreferences.getInstance();
  final radioVolumeRepository = RadioVolumeRepository(sharedPreferences);
  final audioSession = await AudioSession.instance;

  getIt.registerLazySingleton<RadioStationListCubit>(() =>
      RadioStationListCubit(radioStationRepository: radioStationRepository));

  getIt.registerFactory<RadioPlayerCubit>(
    () => RadioPlayerCubit(
      audioSession: audioSession,
      audioPlayer: AudioPlayer(),
      radioVolumeRepository: radioVolumeRepository,
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
