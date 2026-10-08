import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_model.dart';
import '../../models/user_session.dart';
import '../../models/inquiry_store.dart';
import 'payment_verification_screen.dart';
import 'farm_calendar_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final void Function(int index)? onNavigateTab;

  const AdminDashboardScreen({
    super.key,
    this.scaffoldKey,
    this.onNavigateTab,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _unreadNotificationCount = 3;

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

  String _formatPrice(double price) {
    final parts = price.toStringAsFixed(0).split('.');
    final intPart = parts[0];
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(intPart[i]);
    }
    return '₱$buffer';
  }

  void _navigateToTab(int tabIndex, Widget fallbackScreen) {
    if (widget.onNavigateTab != null) {
      widget.onNavigateTab!(tabIndex);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => fallbackScreen),
      );
    }
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          final notifications = [
            {
              'title': 'New Payment Proof Uploaded',
              'desc': 'Juan dela Cruz submitted GCash reference GC-20261008-001 for Cacao Farm Tour (₱1,500).',
              'time': '5 mins ago',
              'icon': Icons.receipt_long_rounded,
              'color': AppColors.primary,
              'unread': true,
            },
            {
              'title': 'High Slot Occupancy Alert',
              'desc': 'Chocolate Making Experience on Oct 20 has reached 90% (68/75 guests filled).',
              'time': '1 hour ago',
              'icon': Icons.warning_amber_rounded,
              'color': Colors.orange.shade700,
              'unread': true,
            },
            {
              'title': 'New Visitor Ad Inquiry',
              'desc': 'Carlos Mendoza inquired about Tree-to-Bar Workshop for a group of 12.',
              'time': '3 hours ago',
              'icon': Icons.mark_email_unread_rounded,
              'color': const Color(0xFF0284C7),
              'unread': true,
            },
            {
              'title': '5-Star Feedback Submitted',
              'desc': 'Maria Santos rated 5.0★: "Best single-origin cacao immersion in Davao!"',
              'time': '6 hours ago',
              'icon': Icons.star_rounded,
              'color': AppColors.accent,
              'unread': false,
            },
            {
              'title': 'Tour Batch Check-out Completed',
              'desc': 'Batch of 14 guests finished Kakaw Lakaw Agroforestry Walk.',
              'time': '1 day ago',
              'icon': Icons.check_circle_outline_rounded,
              'color': AppColors.success,
              'unread': false,
            },
          ];

          return Container(
            height: MediaQuery.of(context).size.height * 0.72,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Sheet Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          const Text(
                            'Farm Notifications',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (_unreadNotificationCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$_unreadNotificationCount new',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (_unreadNotificationCount > 0)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _unreadNotificationCount = 0;
                            });
                            setSheetState(() {});
                          },
                          child: const Text(
                            'Mark all read',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Notifications List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      final isUnread = item['unread'] as bool && _unreadNotificationCount > 0;

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUnread
                              ? AppColors.primaryLight.withValues(alpha: 0.08)
                              : AppColors.surfaceVariant.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isUnread
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : AppColors.border.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (item['color'] as Color).withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['color'] as Color,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'] as String,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12.5,
                                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item['time'] as String,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['desc'] as String,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBookingDetailsModal(BuildContext context, Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.event_note_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        booking['package'] as String,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking['date'] as String,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
              ),
              child: Column(
                children: [
                  _buildModalInfoRow('Batch Capacity', '${booking['capacity']}/${booking['max']} Guests'),
                  const Divider(height: 16),
                  _buildModalInfoRow('Occupancy Rate', '${((booking['capacity'] as int) / (booking['max'] as int) * 100).toStringAsFixed(1)}% Filled'),
                  const Divider(height: 16),
                  _buildModalInfoRow('Farm Status', 'Active & Scheduled'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const Text('Close', style: TextStyle(fontFamily: 'Poppins')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _navigateToTab(1, FarmCalendarScreen(scaffoldKey: widget.scaffoldKey));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.calendar_month_rounded, size: 18),
                    label: const Text(
                      'Open in Calendar',
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final allBookings = BookingStore.instance.all;
    final pendingList = BookingStore.instance.getByStatus(BookingStatus.pendingVerification);
    final confirmedList = BookingStore.instance.getByStatus(BookingStatus.confirmed);
    final pendingInquiries = InquiryStore.instance.pendingCount;

    double totalRevenue = 0.0;
    for (var b in confirmedList) {
      totalRevenue += b.totalPrice;
    }

    final session = UserSession.instance;
    final userName = session.fullName.isNotEmpty ? session.fullName : (session.isAdmin ? 'Maria Santos' : 'Razel Ponce');
    final initials = session.initials.isNotEmpty ? session.initials : (session.isAdmin ? 'MS' : 'RP');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Operations Hub',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Gran Verde Agroforest • Davao',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Notification Bell
          IconButton(
            tooltip: 'Farm Notifications',
            onPressed: () => _showNotificationsBottomSheet(context),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
                if (_unreadNotificationCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3.5),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$_unreadNotificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Executive Welcome & Farm Status Banner ────────────────
                _buildExecutiveBanner(userName, initials, session.isAdmin),

                const SizedBox(height: 18),

                // ── Key Operational KPI Metric Cards (2x2 / 4-card desktop) ───
                _buildKpiMetricsGrid(
                  allBookingsCount: allBookings.length,
                  totalRevenue: totalRevenue,
                  pendingCount: pendingList.length,
                  confirmedCount: confirmedList.length,
                ),

                const SizedBox(height: 22),

                // ── ⚡ Quick Operations Hub (1-Tap Fast Access) ───────────
                _buildQuickOperationsHub(
                  pendingPayments: pendingList.length,
                  pendingInquiries: pendingInquiries,
                ),

                const SizedBox(height: 24),

                // ── Upcoming Tour Bookings (Interactive Schedule) ────────
                _buildUpcomingSlotsSection(context),

                const SizedBox(height: 24),

                // ── Recent Payments & Proof Verification ─────────────────
                _buildRecentPaymentsSection(context),

                const SizedBox(height: 24),

                // ── Weekly Tour Occupancy & Visitor Analytics ────────────
                _buildWeeklyInsightsSection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExecutiveBanner(String userName, String initials, bool isAdmin) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F4E31), Color(0xFF1B5E20), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4E31).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppColors.accent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAdmin ? 'Lead Farm Administrator' : 'Farm Operations Staff',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_outlined, size: 12, color: AppColors.accent),
                    SizedBox(width: 4),
                    Text(
                      'Portal Active',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Live Farm Status Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.accent),
                    SizedBox(width: 6),
                    Text(
                      'Friday, Oct 9, 2026',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.eco_rounded, size: 13, color: AppColors.accent),
                    SizedBox(width: 4),
                    Text(
                      '75 Max Daily Slots',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetricsGrid({
    required int allBookingsCount,
    required double totalRevenue,
    required int pendingCount,
    required int confirmedCount,
  }) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    final card1 = _buildMetricCard(
      icon: Icons.event_available_rounded,
      value: '$allBookingsCount',
      label: 'Total Bookings',
      trendText: '+15% this week',
      accentColor: AppColors.primary,
      bgGradient: const [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
      onTap: () => _navigateToTab(1, FarmCalendarScreen(scaffoldKey: widget.scaffoldKey)),
    );

    final card2 = _buildMetricCard(
      icon: Icons.payments_rounded,
      value: _formatPrice(totalRevenue),
      label: 'Verified Revenue',
      trendText: '100% collected',
      accentColor: const Color(0xFFD97706),
      bgGradient: const [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
      onTap: () => _navigateToTab(2, PaymentVerificationScreen(scaffoldKey: widget.scaffoldKey)),
    );

    final card3 = _buildMetricCard(
      icon: Icons.pending_actions_rounded,
      value: '$pendingCount',
      label: 'Pending Audit',
      trendText: pendingCount > 0 ? 'Action needed' : 'All clear',
      accentColor: Colors.orange.shade800,
      bgGradient: const [Color(0xFFFFEDD5), Color(0xFFFED7AA)],
      isAlert: pendingCount > 0,
      onTap: () => _navigateToTab(2, PaymentVerificationScreen(scaffoldKey: widget.scaffoldKey)),
    );

    final card4 = _buildMetricCard(
      icon: Icons.verified_user_rounded,
      value: '$confirmedCount',
      label: 'Confirmed Slots',
      trendText: 'Ready for tour',
      accentColor: const Color(0xFF0F766E),
      bgGradient: const [Color(0xFFCCFBF1), Color(0xFF99F6E4)],
      onTap: () => _navigateToTab(1, FarmCalendarScreen(scaffoldKey: widget.scaffoldKey)),
    );

    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: card1),
          const SizedBox(width: 12),
          Expanded(child: card2),
          const SizedBox(width: 12),
          Expanded(child: card3),
          const SizedBox(width: 12),
          Expanded(child: card4),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: card1),
            const SizedBox(width: 12),
            Expanded(child: card2),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: card3),
            const SizedBox(width: 12),
            Expanded(child: card4),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required String trendText,
    required Color accentColor,
    required List<Color> bgGradient,
    required VoidCallback onTap,
    bool isAlert = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAlert ? Colors.orange.shade400 : AppColors.border.withValues(alpha: 0.8),
            width: isAlert ? 1.4 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: bgGradient),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: accentColor,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: bgGradient[0],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                trendText,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickOperationsHub({
    required int pendingPayments,
    required int pendingInquiries,
  }) {
    final quickActions = [
      {
        'title': 'Payments',
        'subtitle': 'Audit receipts',
        'icon': Icons.receipt_long_rounded,
        'color': const Color(0xFFD97706),
        'tab': 2,
        'badge': pendingPayments > 0 ? '$pendingPayments' : null,
      },
      {
        'title': 'Calendar',
        'subtitle': 'Tour batches',
        'icon': Icons.calendar_month_rounded,
        'color': AppColors.primary,
        'tab': 1,
        'badge': null,
      },
      {
        'title': 'Inquiries',
        'subtitle': 'Visitor leads',
        'icon': Icons.mark_email_unread_rounded,
        'color': const Color(0xFF0284C7),
        'tab': 3,
        'badge': pendingInquiries > 0 ? '$pendingInquiries' : null,
      },
      {
        'title': 'Visitors',
        'subtitle': 'Guest directory',
        'icon': Icons.people_alt_rounded,
        'color': const Color(0xFF7C3AED),
        'tab': 4,
        'badge': null,
      },
      {
        'title': 'Reports',
        'subtitle': 'Analytics & KPIs',
        'icon': Icons.bar_chart_rounded,
        'color': const Color(0xFF059669),
        'tab': 5,
        'badge': null,
      },
      {
        'title': 'Pricing',
        'subtitle': 'Rates & rules',
        'icon': Icons.request_quote_rounded,
        'color': const Color(0xFFEA580C),
        'tab': 6,
        'badge': null,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.bolt_rounded, color: AppColors.accent, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Quick Operations',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '1-Tap Access',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quickActions.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width >= 768 ? 6 : 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: MediaQuery.of(context).size.width >= 768 ? 1.25 : 1.05,
            ),
            itemBuilder: (context, index) {
              final action = quickActions[index];
              final tabIndex = action['tab'] as int;
              final color = action['color'] as Color;
              final badge = action['badge'] as String?;

              return InkWell(
                onTap: () {
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(tabIndex);
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(action['icon'] as IconData, color: color, size: 24),
                          const SizedBox(height: 6),
                          Text(
                            action['title'] as String,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            action['subtitle'] as String,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 8.5,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      if (badge != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSlotsSection(BuildContext context) {
    final upcomingSlots = [
      {'date': 'OCT 8', 'name': 'Juan dela Cruz', 'package': 'Cacao Farm Tour', 'capacity': 6, 'max': 75},
      {'date': 'OCT 12', 'name': 'Maria Santos', 'package': 'Chocolate Making Experience', 'capacity': 45, 'max': 75},
      {'date': 'OCT 15', 'name': 'Pedro Reyes', 'package': 'Farm to Table Experience', 'capacity': 38, 'max': 75},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Upcoming Bookings',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _navigateToTab(1, FarmCalendarScreen(scaffoldKey: widget.scaffoldKey)),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  child: Row(
                    children: [
                      Text(
                        'Full Calendar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...upcomingSlots.map((slot) {
            final capacity = slot['capacity'] as int;
            final max = slot['max'] as int;
            final percentage = capacity / max;
            final progressColor = percentage < 0.5
                ? AppColors.success
                : percentage < 0.8
                    ? const Color(0xFFD97706)
                    : AppColors.error;

            return InkWell(
              onTap: () => _showBookingDetailsModal(context, slot),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    // Styled Date Pill
                    Container(
                      width: 52,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF0F4E31), Color(0xFF1B5E20)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (slot['date'] as String).split(' ')[0],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                          Text(
                            (slot['date'] as String).split(' ')[1],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slot['name'] as String,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            slot['package'] as String,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                '$capacity/$max (${(percentage * 100).toStringAsFixed(0)}%)',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: percentage,
                                    backgroundColor: Colors.grey.shade300,
                                    color: progressColor,
                                    minHeight: 5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentPaymentsSection(BuildContext context) {
    final recentPayments = [
      {
        'name': 'Juan dela Cruz',
        'ref': 'GC-20241008-001',
        'package': 'Cacao Farm Tour',
        'amount': 1500.0,
        'date': 'Oct 8, 2026',
        'status': 'Verified',
      },
      {
        'name': 'Maria Santos',
        'ref': 'GC-20241009-002',
        'package': 'Chocolate Making',
        'amount': 2000.0,
        'date': 'Oct 9, 2026',
        'status': 'Pending',
      },
      {
        'name': 'Pedro Reyes',
        'ref': 'GC-20241010-003',
        'package': 'Full Day Experience',
        'amount': 3500.0,
        'date': 'Oct 10, 2026',
        'status': 'Verified',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.payment_rounded, color: Color(0xFFD97706), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Recent Payments',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _navigateToTab(2, PaymentVerificationScreen(scaffoldKey: widget.scaffoldKey)),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  child: Row(
                    children: [
                      Text(
                        'Audit All',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...recentPayments.map((payment) {
            final isVerified = payment['status'] == 'Verified';
            final statusColor = isVerified ? AppColors.success : const Color(0xFFD97706);
            final statusBg = isVerified
                ? AppColors.success.withValues(alpha: 0.12)
                : const Color(0xFFD97706).withValues(alpha: 0.12);

            return InkWell(
              onTap: () => _navigateToTab(2, PaymentVerificationScreen(scaffoldKey: widget.scaffoldKey)),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: statusColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment['name'] as String,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${payment['ref']} • ${payment['package']}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _formatPrice(payment['amount'] as double),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '• ${payment['date']}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        payment['status'] as String,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeeklyInsightsSection() {
    final weeklyData = [
      {'day': 'Mon', 'count': 3},
      {'day': 'Tue', 'count': 7},
      {'day': 'Wed', 'count': 5},
      {'day': 'Thu', 'count': 12},
      {'day': 'Fri', 'count': 8},
      {'day': 'Sat', 'count': 15},
      {'day': 'Sun', 'count': 6},
    ];

    final maxCount = weeklyData.map((d) => d['count'] as int).reduce((a, b) => a > b ? a : b);
    final today = DateTime.now().weekday; // 1 = Monday, 7 = Sunday

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.insert_chart_outlined_rounded, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Weekly Tour Activity',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Peak: Sat (15 tours)',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: weeklyData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              final count = data['count'] as int;
              final dayIndex = index + 1; // 1 = Mon, 7 = Sun
              final isToday = (today == 7 ? 0 : today) == dayIndex % 7;
              final barHeight = (count / maxCount) * 105;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$count',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: isToday ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 28,
                    height: barHeight.clamp(16.0, 105.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isToday
                            ? [AppColors.accent, const Color(0xFFF59E0B)]
                            : [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data['day'] as String,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.5,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      color: isToday ? AppColors.primaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
