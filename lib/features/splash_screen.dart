import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:radio_app/features/radios_list/view/radio_list_view.dart';
import 'package:radio_app/routes/custom_page_routes.dart';

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
        FadeInPageRouteTransition((const RadioListScreen())),
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
    final fadeAnimator =
        CurvedAnimation(parent: animationController, curve: Curves.easeInCubic);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.white, Colors.purple],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FadeTransition(
            //   opacity: fadeAnimator,
            //   child: const Icon(
            //     Icons.radio,
            //     color: Colors.white,
            //     size: 80,
            //   ),
            // ),
            Lottie.asset(
              // 'https://lottie.host/895bcb52-118e-4e03-ab29-c1bc5853c3fc/sT6tafrvpd.json',
              'assets/lottie-splash.json',
              width: 100,
              // height: 200,
              fit: BoxFit.fill,
            ),

            // SizedBox(height: 30),
            // const Text(
            //   'Radio Station',
            //   style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 30,
            //       fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
