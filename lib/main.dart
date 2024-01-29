import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:radio_app/features/radio_list/cubit/radio_list_cubit.dart';
import 'package:radio_app/features/radio_list/data/radio_station_api_client.dart';
import 'package:radio_app/features/radio_list/data/radio_station_repository.dart';
import 'package:radio_app/features/splash_screen.dart';

void main() {
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

void setupDependencies() {
  // Fixes CERTIFICATE_VERIFY_FAILED error while in development
  HttpOverrides.global = MyHttpOverrides();

  final getIt = GetIt.instance;
  final radioStationApiClient = RadioStationApiClient(http.Client());
  final radioStationRepository =
      RadioStationRepository(radioStationApiClient: radioStationApiClient);

  getIt.registerLazySingleton<RadioStationListCubit>(() =>
      RadioStationListCubit(radioStationRepository: radioStationRepository));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
