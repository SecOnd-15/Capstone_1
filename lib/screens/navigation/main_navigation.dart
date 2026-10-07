import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_session.dart';
import '../home/home_screen.dart';
import '../experiences/experiences_screen.dart';
import '../bookings/my_bookings_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/smart_concierge_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  List<Widget> get _screens => [
    HomeScreen(scaffoldKey: _scaffoldKey),
    ExperiencesScreen(scaffoldKey: _scaffoldKey),
    MyBookingsScreen(scaffoldKey: _scaffoldKey),
    ProfileScreen(scaffoldKey: _scaffoldKey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawer: _buildSideDrawer(context),
      body: _screens[_currentIndex],
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    final session = UserSession.instance;
    final userName = session.fullName.isNotEmpty ? session.fullName : 'Visitor';
    final userEmail = session.email.isNotEmpty ? session.email : 'visitor@gmail.com';
    final initials = session.initials.isNotEmpty ? session.initials : 'V';

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Drawer Header with Hide/Close button
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 20,
                left: 20,
                right: 16,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      // Hide Side Navigation Button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Hide Menu',
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '🌿 Registered Visitor',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation List Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                children: [
                  _buildNavTile(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: 'Home',
                    subtitle: 'Farm overview & highlights',
                  ),
                  _buildNavTile(
                    index: 1,
                    icon: Icons.explore_rounded,
                    label: 'Cacao Experiences',
                    subtitle: 'Kakaw Lakaw, Bahandi & Tours',
                  ),
                  _buildNavTile(
                    index: 2,
                    icon: Icons.bookmark_rounded,
                    label: 'My Bookings',
                    subtitle: 'Track reservations & status',
                  ),
                  _buildNavTile(
                    index: 3,
                    icon: Icons.person_rounded,
                    label: 'Visitor Profile',
                    subtitle: 'Account details & preferences',
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1),
                  ),

                  // Smart Concierge Direct Shortcut
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.15),
                          AppColors.primary.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.accent,
                        size: 22,
                      ),
                      title: const Text(
                        'Smart Concierge AI',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: const Text(
                        'Recommendation Engine',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.accent,
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SmartConciergeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Drawer Footer / Logout
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        UserSession.instance.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gran Verde Cacao Farm • v1.0.0',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required int index,
    required IconData icon,
    required String label,
    required String subtitle,
  }) {
    final isSelected = _currentIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 6,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              )
            : null,
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pop(context); // Hide side drawer
        },
      ),
    );
  }
}
