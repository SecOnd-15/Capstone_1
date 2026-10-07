import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_session.dart';

class AdminProfileScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const AdminProfileScreen({super.key, this.scaffoldKey});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool _notificationAlerts = true;
  bool _paymentAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Admin Profile Header
            _buildHeader(context),
            const SizedBox(height: 16),

            // Farm Info Card
            _buildFarmInfoCard(),
            const SizedBox(height: 16),

            // Administrative Preferences
            _buildSection(
              'Notification & Verification Alerts',
              [
                _buildSwitchTile(
                  Icons.notifications_active_outlined,
                  'New Booking & Inquiry Alerts',
                  'Receive instant notifications when visitors book',
                  _notificationAlerts,
                  (val) => setState(() => _notificationAlerts = val),
                ),
                _buildSwitchTile(
                  Icons.verified_user_outlined,
                  'Payment Verification Alerts',
                  'Alert when new GCash/Bank receipts are uploaded',
                  _paymentAlerts,
                  (val) => setState(() => _paymentAlerts = val),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Security & Operations
            _buildSection(
              'Security & System Settings',
              [
                _buildActionTile(
                  Icons.lock_outline_rounded,
                  'Change Password',
                  'Update admin master password credentials',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password management dialog.')),
                    );
                  },
                ),
                _buildActionTile(
                  Icons.storefront_outlined,
                  'Farm Operating Hours & Schedule',
                  'Mon - Sun (8:00 AM - 5:00 PM)',
                  () {},
                ),
                _buildActionTile(
                  Icons.security_outlined,
                  'Role-Based Access Logs',
                  'Supabase audit trail & access history',
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    UserSession.instance.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text(
                    'Log out',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 28,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF004D40), Color(0xFF1B5E20)],
        ),
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                UserSession.instance.initials.isNotEmpty
                    ? UserSession.instance.initials
                    : (UserSession.instance.isAdmin ? 'MS' : 'RP'),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF004D40),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            UserSession.instance.fullName.isNotEmpty
                ? UserSession.instance.fullName
                : (UserSession.instance.isAdmin ? 'Maria Santos' : 'Razel Ponce'),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            '${UserSession.instance.email.isNotEmpty ? UserSession.instance.email : (UserSession.instance.isAdmin ? "maria@gmail.com" : "staff@gmail.com")} • ${UserSession.instance.contactNumber.isNotEmpty ? UserSession.instance.contactNumber : "+63 917 777 3344"}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              UserSession.instance.isAdmin
                  ? '🛡️ Operations Administrator'
                  : '🧑‍💼 Farm Operations Staff',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.nature_people_rounded, color: AppColors.primary, size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gran Verde Cacao Regenerative Farm',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Davao del Norte, Philippines • RA 10816 Accredited',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
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
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        leading: Icon(icon, color: AppColors.textSecondary, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        leading: Icon(icon, color: AppColors.textSecondary, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      ),
    );
  }
}
