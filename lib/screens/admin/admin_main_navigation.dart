import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_model.dart';
import '../../models/user_session.dart';
import 'admin_dashboard_screen.dart';
import 'payment_verification_screen.dart';
import 'visitor_database_screen.dart';
import 'admin_reports_screen.dart';
import 'farm_calendar_screen.dart';
import 'quotations_pricing_screen.dart';
import 'promotions_manager_screen.dart';
import 'feedback_reviews_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_inquiries_screen.dart';
import '../../models/inquiry_store.dart';

class AdminMainNavigation extends StatefulWidget {
  const AdminMainNavigation({super.key});

  @override
  State<AdminMainNavigation> createState() => _AdminMainNavigationState();
}

class _AdminMainNavigationState extends State<AdminMainNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    BookingStore.instance.addListener(_refresh);
    InquiryStore.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    BookingStore.instance.removeListener(_refresh);
    InquiryStore.instance.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  List<Widget> get _screens => [
    AdminDashboardScreen(scaffoldKey: _scaffoldKey),
    PaymentVerificationScreen(scaffoldKey: _scaffoldKey),
    AdminInquiriesScreen(scaffoldKey: _scaffoldKey),
    VisitorDatabaseScreen(scaffoldKey: _scaffoldKey),
    AdminReportsScreen(scaffoldKey: _scaffoldKey),
    FarmCalendarScreen(scaffoldKey: _scaffoldKey),
    QuotationsPricingScreen(scaffoldKey: _scaffoldKey),
    PromotionsManagerScreen(scaffoldKey: _scaffoldKey),
    FeedbackReviewsScreen(scaffoldKey: _scaffoldKey),
    AdminProfileScreen(scaffoldKey: _scaffoldKey),
  ];

  @override
  Widget build(BuildContext context) {
    final pendingCount = BookingStore.instance
        .getByStatus(BookingStatus.pendingVerification)
        .length;

    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawer: _buildAdminSideDrawer(context, pendingCount),
      body: _screens[_currentIndex],
    );
  }

  Widget _buildAdminSideDrawer(BuildContext context, int pendingCount) {
    final session = UserSession.instance;
    final userName = session.fullName.isNotEmpty ? session.fullName : (session.isAdmin ? 'Maria Santos' : 'Razel Ponce');
    final userEmail = session.email.isNotEmpty ? session.email : (session.isAdmin ? 'maria@gmail.com' : 'staff@gmail.com');
    final initials = session.initials.isNotEmpty ? session.initials : (session.isAdmin ? 'MS' : 'RP');

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Admin Drawer Header with Hide/Close Button
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
                  colors: [Color(0xFF004D40), Color(0xFF1B5E20)],
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
                              color: Color(0xFF004D40),
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
                    child: Text(
                      session.isAdmin
                          ? '🛡️ System Administrator'
                          : '🧑‍💼 Operations Staff',
                      style: const TextStyle(
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

            // Administrative Modules List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  _buildNavTile(
                    index: 0,
                    icon: Icons.dashboard_rounded,
                    label: 'Operations Dashboard',
                    subtitle: 'Farm KPI metrics & revenue',
                  ),
                  _buildNavTile(
                    index: 1,
                    icon: Icons.verified_rounded,
                    label: 'Payment Verification',
                    subtitle: 'GCash & Bank receipt audits',
                    badgeCount: pendingCount,
                  ),
                  _buildNavTile(
                    index: 2,
                    icon: Icons.mark_email_unread_rounded,
                    label: 'Visitor Inquiries & Leads',
                    subtitle: 'Advertisement responses & quotes',
                    badgeCount: InquiryStore.instance.pendingCount,
                  ),
                  _buildNavTile(
                    index: 3,
                    icon: Icons.people_rounded,
                    label: 'Visitor Database',
                    subtitle: 'Demographics & booking history',
                  ),
                  _buildNavTile(
                    index: 4,
                    icon: Icons.bar_chart_rounded,
                    label: 'Descriptive Reports',
                    subtitle: 'Monthly visits & ratings',
                  ),
                  _buildNavTile(
                    index: 5,
                    icon: Icons.calendar_month_rounded,
                    label: 'Master Farm Calendar',
                    subtitle: 'Daily capacity & slot limits',
                  ),
                  _buildNavTile(
                    index: 6,
                    icon: Icons.request_quote_rounded,
                    label: 'Pricing & Quotations',
                    subtitle: 'Base rates & add-on rules',
                  ),
                  _buildNavTile(
                    index: 7,
                    icon: Icons.campaign_rounded,
                    label: 'Promotions Manager',
                    subtitle: 'Hero videos & highlights',
                  ),
                  _buildNavTile(
                    index: 8,
                    icon: Icons.star_rounded,
                    label: 'Feedback & Quality',
                    subtitle: '5-factor survey ratings',
                  ),
                  _buildNavTile(
                    index: 9,
                    icon: Icons.person_rounded,
                    label: 'Admin Profile & Settings',
                    subtitle: 'Security, hours & preferences',
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
                        'Logout Admin Session',
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
                    'Gran Verde Admin Console • RA 10816 Accredited',
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
    int badgeCount = 0,
  }) {
    final isSelected = _currentIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isSelected
            ? const Color(0xFF004D40).withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: const Color(0xFF004D40).withValues(alpha: 0.3))
                : null,
          ),
          child: ListTile(
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Icon(
              icon,
              color: isSelected ? const Color(0xFF004D40) : AppColors.textSecondary,
              size: 22,
            ),
            title: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF004D40) : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? const Color(0xFF004D40) : AppColors.textSecondary,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badgeCount > 0)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF004D40),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
            onTap: () {
              setState(() {
                _currentIndex = index;
              });
              Navigator.pop(context); // Hide side drawer
            },
          ),
        ),
      ),
    );
  }
}
