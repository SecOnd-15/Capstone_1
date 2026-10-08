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

class _AdminNavItem {
  final Widget Function(GlobalKey<ScaffoldState> scaffoldKey, void Function(int index)? onNavigate) builder;
  final IconData icon;
  final String label;
  final String subtitle;
  final String category;
  final bool adminOnly;
  final int Function()? badgeCount;

  const _AdminNavItem({
    required this.builder,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.category,
    this.adminOnly = false,
    this.badgeCount,
  });
}

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

  void _navigateToIndex(int index) {
    if (index >= 0 && index < _activeNavItems.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  List<_AdminNavItem> get _allNavItems => [
    _AdminNavItem(
      builder: (key, onNav) => AdminDashboardScreen(scaffoldKey: key, onNavigateTab: onNav),
      icon: Icons.dashboard_rounded,
      label: 'Operations Dashboard',
      subtitle: UserSession.instance.isAdmin
          ? 'Farm KPI metrics & revenue'
          : 'Daily visitor & tour schedule',
      category: 'Core Operations',
    ),
    _AdminNavItem(
      builder: (key, onNav) => FarmCalendarScreen(scaffoldKey: key, onBack: () => onNav?.call(0)),
      icon: Icons.calendar_month_rounded,
      label: 'Master Farm Calendar',
      subtitle: UserSession.instance.isAdmin
          ? 'Daily capacity & slot limits'
          : 'Tour batch schedule & capacity',
      category: 'Core Operations',
    ),
    _AdminNavItem(
      builder: (key, onNav) => PaymentVerificationScreen(scaffoldKey: key, onBack: () => onNav?.call(0)),
      icon: Icons.verified_rounded,
      label: 'Payment Verification',
      subtitle: 'GCash & Bank receipt audits',
      category: 'Core Operations',
      badgeCount: () => BookingStore.instance
          .getByStatus(BookingStatus.pendingVerification)
          .length,
    ),
    _AdminNavItem(
      builder: (key, onNav) => AdminInquiriesScreen(scaffoldKey: key, onBack: () => onNav?.call(0)),
      icon: Icons.mark_email_unread_rounded,
      label: 'Visitor Inquiries & Leads',
      subtitle: 'Advertisement responses & quotes',
      category: 'Core Operations',
      badgeCount: () => InquiryStore.instance.pendingCount,
    ),
    _AdminNavItem(
      builder: (key, onNav) => VisitorDatabaseScreen(scaffoldKey: key, onBack: () => onNav?.call(0)),
      icon: Icons.people_rounded,
      label: 'Visitor Database',
      subtitle: 'Demographics & booking history',
      category: 'Core Operations',
    ),
    _AdminNavItem(
      builder: (key, onNav) => AdminReportsScreen(scaffoldKey: key, onBack: () => onNav?.call(0)),
      icon: Icons.bar_chart_rounded,
      label: 'Descriptive Reports',
      subtitle: 'Monthly visits & ratings',
      category: 'Analytics & Rules',
      adminOnly: true,
    ),
    _AdminNavItem(
      builder: (key, onNav) => QuotationsPricingScreen(scaffoldKey: key, onBack: () => onNav?.call(0)),
      icon: Icons.request_quote_rounded,
      label: 'Pricing & Quotations',
      subtitle: 'Base rates & add-on rules',
      category: 'Analytics & Rules',
      adminOnly: true,
    ),
    _AdminNavItem(
      builder: (key, onNav) => PromotionsManagerScreen(scaffoldKey: key, onBack: () => onNav?.call(0)),
      icon: Icons.campaign_rounded,
      label: 'Promotions Manager',
      subtitle: 'Hero videos & highlights',
      category: 'Analytics & Rules',
      adminOnly: true,
    ),
    _AdminNavItem(
      builder: (key, onNav) => FeedbackReviewsScreen(scaffoldKey: key, onBack: () => onNav?.call(0)),
      icon: Icons.star_rounded,
      label: 'Feedback & Quality',
      subtitle: '5-factor survey ratings',
      category: 'Analytics & Rules',
    ),
    _AdminNavItem(
      builder: (key, onNav) => AdminProfileScreen(scaffoldKey: key, onBack: () => onNav?.call(0)),
      icon: Icons.person_rounded,
      label: UserSession.instance.isAdmin
          ? 'Admin Profile & Settings'
          : 'Staff Profile & Support',
      subtitle: UserSession.instance.isAdmin
          ? 'Security, hours & preferences'
          : 'Shift guidelines & profile',
      category: 'Account & System',
    ),
  ];

  List<_AdminNavItem> get _activeNavItems {
    final isAdmin = UserSession.instance.isAdmin;
    return _allNavItems.where((item) => !item.adminOnly || isAdmin).toList();
  }

  int _getBottomNavIndex(int currentItemIndex, List<_AdminNavItem> items) {
    if (currentItemIndex >= items.length) return 0;
    final currentLabel = items[currentItemIndex].label;
    if (currentLabel == 'Operations Dashboard') return 0;
    if (currentLabel == 'Master Farm Calendar') return 1;
    if (currentLabel == 'Payment Verification') return 2;
    if (currentLabel == 'Visitor Inquiries & Leads') return 3;
    return 4; // 'All Tools'
  }

  void _handleBottomNavSelection(int destIndex, List<_AdminNavItem> items) {
    switch (destIndex) {
      case 0:
        final idx = items.indexWhere((it) => it.label == 'Operations Dashboard');
        if (idx != -1) setState(() => _currentIndex = idx);
        break;
      case 1:
        final idx = items.indexWhere((it) => it.label == 'Master Farm Calendar');
        if (idx != -1) setState(() => _currentIndex = idx);
        break;
      case 2:
        final idx = items.indexWhere((it) => it.label == 'Payment Verification');
        if (idx != -1) setState(() => _currentIndex = idx);
        break;
      case 3:
        final idx = items.indexWhere((it) => it.label == 'Visitor Inquiries & Leads');
        if (idx != -1) setState(() => _currentIndex = idx);
        break;
      case 4:
        _scaffoldKey.currentState?.openDrawer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _activeNavItems;
    final safeIndex = _currentIndex < items.length ? _currentIndex : 0;
    final pendingPaymentCount = BookingStore.instance.getByStatus(BookingStatus.pendingVerification).length;
    final pendingInquiryCount = InquiryStore.instance.pendingCount;

    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawer: _buildAdminSideDrawer(context, items),
      body: items[safeIndex].builder(_scaffoldKey, _navigateToIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: AppColors.border.withValues(alpha: 0.6),
              width: 0.8,
            ),
          ),
        ),
        child: NavigationBar(
          height: 64,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIndex: _getBottomNavIndex(safeIndex, items),
          onDestinationSelected: (destIndex) => _handleBottomNavSelection(destIndex, items),
          indicatorColor: AppColors.primaryLight.withValues(alpha: 0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, size: 22),
              selectedIcon: Icon(Icons.dashboard_rounded, size: 22, color: AppColors.primary),
              label: 'Dashboard',
            ),
            const NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined, size: 22),
              selectedIcon: Icon(Icons.calendar_month_rounded, size: 22, color: AppColors.primary),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: pendingPaymentCount > 0,
                label: Text('$pendingPaymentCount'),
                child: const Icon(Icons.verified_outlined, size: 22),
              ),
              selectedIcon: Badge(
                isLabelVisible: pendingPaymentCount > 0,
                label: Text('$pendingPaymentCount'),
                child: const Icon(Icons.verified_rounded, size: 22, color: AppColors.primary),
              ),
              label: 'Payments',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: pendingInquiryCount > 0,
                label: Text('$pendingInquiryCount'),
                child: const Icon(Icons.mark_email_unread_outlined, size: 22),
              ),
              selectedIcon: Badge(
                isLabelVisible: pendingInquiryCount > 0,
                label: Text('$pendingInquiryCount'),
                child: const Icon(Icons.mark_email_unread_rounded, size: 22, color: AppColors.primary),
              ),
              label: 'Inquiries',
            ),
            const NavigationDestination(
              icon: Icon(Icons.grid_view_rounded, size: 22),
              selectedIcon: Icon(Icons.grid_view_rounded, size: 22, color: AppColors.primary),
              label: 'All Tools',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminSideDrawer(BuildContext context, List<_AdminNavItem> items) {
    final session = UserSession.instance;
    final userName = session.fullName.isNotEmpty ? session.fullName : (session.isAdmin ? 'Maria Santos' : 'Razel Ponce');
    final userEmail = session.email.isNotEmpty ? session.email : (session.isAdmin ? 'maria@gmail.com' : 'staff@gmail.com');
    final initials = session.initials.isNotEmpty ? session.initials : (session.isAdmin ? 'MS' : 'RP');

    // Group items by category
    final Map<String, List<_AdminNavItem>> categorizedItems = {};
    for (var item in items) {
      categorizedItems.putIfAbsent(item.category, () => []).add(item);
    }

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Admin Drawer Header
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
                      IconButton(
                        onPressed: () => _scaffoldKey.currentState?.closeDrawer(),
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

            // Administrative Modules List (Grouped by Category)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: categorizedItems.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
                        child: Text(
                          entry.key.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      ...entry.value.map((item) {
                        final index = items.indexOf(item);
                        final badge = item.badgeCount != null ? item.badgeCount!() : 0;
                        return _buildNavTile(
                          index: index,
                          icon: item.icon,
                          label: item.label,
                          subtitle: item.subtitle,
                          badgeCount: badge,
                        );
                      }),
                      const SizedBox(height: 4),
                    ],
                  );
                }).toList(),
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
                        Navigator.pushNamedAndRemoveUntil(context, '/landing', (route) => false);
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
                        'Log out',
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
              _scaffoldKey.currentState?.closeDrawer();
            },
          ),
        ),
      ),
    );
  }
}
