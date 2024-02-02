import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:radio_app/common_ui/custom_page_routes.dart';
import 'package:radio_app/features/radio_home/view/radio_home_screen.dart';
import 'package:radio_app/infra/theme.dart';

const _fadeInLogoTime = Duration(seconds: 2);
const _splashTime = Duration(seconds: 4);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController =
      AnimationController(duration: _fadeInLogoTime, vsync: this);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    animationController.animateTo(1);
    Future.delayed(_splashTime, () {
      Navigator.pushReplacement(
        context,
        FadeInPageRouteTransition((const RadioHomeScreen())),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              appTheme.primaryColor,
              appTheme.secondaryColor,
              appTheme.primaryColor,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie-splash.json',
              width: 100,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
