import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_model.dart';
import '../../models/user_session.dart';
import 'payment_verification_screen.dart';
import 'quotations_pricing_screen.dart';
import 'feedback_reviews_screen.dart';
import 'farm_calendar_screen.dart';
import 'promotions_manager_screen.dart';
import 'admin_inquiries_screen.dart';
import '../../models/inquiry_store.dart';

class AdminDashboardScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const AdminDashboardScreen({super.key, this.scaffoldKey});

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

  @override
  Widget build(BuildContext context) {
    final allBookings = BookingStore.instance.all;
    final pendingList = BookingStore.instance.getByStatus(BookingStatus.pendingVerification);
    final confirmedList = BookingStore.instance.getByStatus(BookingStatus.confirmed);
    
    double totalRevenue = 0.0;
    for (var b in confirmedList) {
      totalRevenue += b.totalPrice;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          onPressed: () => scaffoldKey?.currentState?.openDrawer(),
        ),
        title: const Text(
          'Admin Operations Console',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Greeting Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF004D40)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      UserSession.instance.initials.isNotEmpty
                          ? UserSession.instance.initials
                          : (UserSession.instance.isAdmin ? 'MS' : 'RP'),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserSession.instance.isAdmin
                              ? 'Farm Operations Manager'
                              : 'Farm Operations Staff',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          UserSession.instance.fullName.isNotEmpty
                              ? UserSession.instance.fullName
                              : (UserSession.instance.isAdmin ? 'Maria Santos' : 'Razel Ponce'),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Gran Verde Cacao Regenerative Farm',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      UserSession.instance.isAdmin ? 'ADMIN' : 'STAFF',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pending Verification Alert Banner
            if (pendingList.isNotEmpty) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentVerificationScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.pending_actions_rounded,
                            color: Colors.orange.shade900, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pendingList.length} Payment Verification${pendingList.length > 1 ? 's' : ''} Pending',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange.shade900,
                              ),
                            ),
                            const Text(
                              'Review visitor-uploaded GCash & bank receipts.',
                              style: TextStyle(fontSize: 11, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.orange.shade900, size: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Visitor Inquiries Alert Banner
            if (InquiryStore.instance.pendingCount > 0) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminInquiriesScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF93C5FD)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDBEAFE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mark_email_unread_rounded,
                            color: Color(0xFF1D4ED8), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${InquiryStore.instance.pendingCount} New Visitor Inquir${InquiryStore.instance.pendingCount > 1 ? 'ies' : 'y'} Pending',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                            const Text(
                              'Review advertisement inquiries & follow up with quotations.',
                              style: TextStyle(fontSize: 11, color: Color(0xFF1F2937)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF1D4ED8), size: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // KPI Grid
            const Text(
              'Operational Metrics (Paper KPIs)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                _buildKpiCard(
                  title: 'Total Bookings',
                  value: '${allBookings.length}',
                  subtitle: '${confirmedList.length} Confirmed',
                  icon: Icons.event_available_rounded,
                  color: const Color(0xFF2E7D32),
                ),
                _buildKpiCard(
                  title: 'Pending Proofs',
                  value: '${pendingList.length}',
                  subtitle: 'Action needed',
                  icon: Icons.receipt_long_rounded,
                  color: Colors.orange.shade800,
                ),
                _buildKpiCard(
                  title: 'Confirmed Sales',
                  value: _formatPrice(totalRevenue),
                  subtitle: 'Verified payments',
                  icon: Icons.payments_rounded,
                  color: const Color(0xFF00695C),
                ),
                _buildKpiCard(
                  title: 'Weighted Rating',
                  value: '4.9 ★',
                  subtitle: '128+ Reviews',
                  icon: Icons.star_rounded,
                  color: const Color(0xFFE65100),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ── ACM Administrative Modules (Section 2.1.5.2) ────────
            const Text(
              'Administrative Management Modules',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.1,
              children: [
                _buildModuleTile(
                  context,
                  title: 'Quotation Rules',
                  subtitle: 'Kakaw / Bahandi pricing',
                  icon: Icons.tune_rounded,
                  color: const Color(0xFF4E342E),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuotationsPricingScreen()),
                  ),
                ),
                _buildModuleTile(
                  context,
                  title: 'Farm Calendar',
                  subtitle: 'Batch allocations & slots',
                  icon: Icons.calendar_month_rounded,
                  color: const Color(0xFF1B5E20),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FarmCalendarScreen()),
                  ),
                ),
                _buildModuleTile(
                  context,
                  title: 'Feedback Analytics',
                  subtitle: 'Weighted 1-5★ reviews',
                  icon: Icons.rate_review_outlined,
                  color: const Color(0xFFE65100),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackReviewsScreen()),
                  ),
                ),
                _buildModuleTile(
                  context,
                  title: 'Ads & Promotions',
                  subtitle: 'Promo media & videos',
                  icon: Icons.campaign_rounded,
                  color: const Color(0xFF00695C),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PromotionsManagerScreen()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Master Booking Schedule
            const Text(
              'Recent Inquiries & Reservations',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...allBookings.map((b) => _buildBookingAdminTile(context, b)),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingAdminTile(BuildContext context, Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            booking.experience.imageEmoji,
            style: const TextStyle(fontSize: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      booking.visitorName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${booking.bookingRef})',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${booking.experience.title} • ${booking.date} (${booking.guests} pax)',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: booking.statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              booking.statusDisplay,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: booking.statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
