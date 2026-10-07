import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_session.dart';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const ProfileScreen({super.key, this.scaffoldKey});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile header with gradient
            _buildProfileHeader(context),
            const SizedBox(height: 16),

            // Stats row
            _buildStatsRow(),
            const SizedBox(height: 16),

            // Account section
            _buildSection(
              'Account',
              [
                _buildListTile(
                  Icons.person_outline_rounded,
                  'Personal Information',
                  () {},
                ),
                _buildListTile(
                  Icons.credit_card_outlined,
                  'Payment Methods',
                  () {},
                ),
                _buildListTileWithSwitch(
                  Icons.notifications_outlined,
                  'Notifications',
                  _notificationsEnabled,
                  (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Preferences section
            _buildSection(
              'Preferences',
              [
                _buildListTileWithTrailing(
                  Icons.language_outlined,
                  'Language',
                  'English',
                  () {},
                ),
                _buildListTileWithTrailing(
                  Icons.attach_money_outlined,
                  'Currency',
                  'PHP (₱)',
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Support section
            _buildSection(
              'Support',
              [
                _buildListTile(
                  Icons.help_outline_rounded,
                  'Help Center',
                  () {},
                ),
                _buildListTile(
                  Icons.chat_bubble_outline_rounded,
                  'Contact Us',
                  () {},
                ),
                _buildListTile(
                  Icons.privacy_tip_outlined,
                  'Privacy Policy',
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 32,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                UserSession.instance.initials,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            UserSession.instance.fullName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            UserSession.instance.email,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),

          // Member since
          const Text(
            'Member since October 2026',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 16),

          // Edit Profile button
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 1.5),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Trips', '3'),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          _buildStatItem('Reviews', '2'),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          _buildStatItem('Points', '850'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        leading: Icon(icon, color: AppColors.textSecondary, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildListTileWithTrailing(
    IconData icon,
    String title,
    String trailing,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        leading: Icon(icon, color: AppColors.textSecondary, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trailing,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTileWithSwitch(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        leading: Icon(icon, color: AppColors.textSecondary, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary,
        ),
      ),
    );
  }
}
