import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_model.dart';

class FarmCalendarScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const FarmCalendarScreen({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final activeBookings = BookingStore.instance.upcomingAndPending;

    final scheduleSlots = [
      {'date': 'Oct 18, 2026', 'slotsFilled': 14, 'maxSlots': 20, 'status': 'Available'},
      {'date': 'Oct 20, 2026', 'slotsFilled': 20, 'maxSlots': 20, 'status': 'Fully Booked'},
      {'date': 'Oct 22, 2026', 'slotsFilled': 8, 'maxSlots': 20, 'status': 'Available'},
      {'date': 'Oct 25, 2026', 'slotsFilled': 4, 'maxSlots': 20, 'status': 'Available'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          onPressed: () => scaffoldKey?.currentState?.openDrawer(),
        ),
        title: const Text(
          'Master Farm Calendar',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
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
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF33691E)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule & Capacity Monitor',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        Text(
                          'Monitors daily visitor batches, farm zone occupancy, and slot allocations (Section 2.1.5.2.9).',
                          style: TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Daily Capacity Allotments
            const Text(
              'Upcoming Tour Batch Allotments',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...scheduleSlots.map((slot) {
              final int filled = slot['slotsFilled'] as int;
              final int max = slot['maxSlots'] as int;
              final double ratio = filled / max;
              final bool isFull = filled >= max;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          slot['date'] as String,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isFull ? AppColors.error.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            slot['status'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isFull ? AppColors.error : AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$filled / $max Guests Booked',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isFull ? AppColors.error : AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Confirmed Tour Attendees List
            const Text(
              'Confirmed Reservation Attendees',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            if (activeBookings.isEmpty)
              const Text('No active scheduled bookings.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))
            else
              ...activeBookings.map((b) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b.visitorName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          Text('${b.experience.title} • ${b.date}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                      Text('${b.guests} Pax', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
