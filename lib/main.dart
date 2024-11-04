import 'package:envirosense/colors/colors.dart';
import 'package:envirosense/views/home_screen.dart';
import 'package:envirosense/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(EnviroSenseApp(isFirstTime: isFirstTime));
}

class EnviroSenseApp extends StatelessWidget {
  final bool isFirstTime;

  const EnviroSenseApp({required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnviroSense',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.whiteColor,
        appBarTheme: const AppBarTheme(
          color: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.whiteColor),
          toolbarTextStyle:
              TextStyle(color: AppColors.whiteColor, fontSize: 20),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.secondaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
        ),
      ),
      home: isFirstTime ? OnboardingScreen() : HomeScreen(),
    );
  }
}
