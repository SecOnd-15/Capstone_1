import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../home/home_screen.dart';
import '../experiences/experiences_screen.dart';
import '../bookings/my_bookings_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExperiencesScreen(),
    MyBookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        backgroundColor: AppColors.surface,
        elevation: 8,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_rounded),
            selectedIcon: Icon(Icons.explore_rounded, color: AppColors.primary),
            label: 'Experiences',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded, color: AppColors.primary),
            label: 'My Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
