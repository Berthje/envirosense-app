import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Settings Page',
        style: TextStyle(
          fontSize: 24,
          color: AppColors.accentColor,
        ),
      ),
    );
  }
}
