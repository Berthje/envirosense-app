// main_screen.dart

import 'package:envirosense/presentation/widgets/layout/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/views/home_screen.dart';
import 'package:envirosense/presentation/views/statistics_screen.dart';
import 'package:envirosense/presentation/views/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages to navigate
  final List<Widget> _pages = [
    const HomeScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
