import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offertree/ui/screens/auth/onboarding.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color((0xFF576bd6)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/svg/Logo/splashlogo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // App name
              const SizedBox(height: 10),
              // Subtitle
              Text(
                "Discover. Sell. Connect.",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
