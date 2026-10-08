import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';

class FarmCalendarScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final VoidCallback? onBack;
  const FarmCalendarScreen({super.key, this.scaffoldKey, this.onBack});

  @override
  State<FarmCalendarScreen> createState() => _FarmCalendarScreenState();
}

class _FarmCalendarScreenState extends State<FarmCalendarScreen> {
  DateTime _selectedDate = DateTime(2026, 10, 8);
  DateTime _displayedMonth = DateTime(2026, 10, 1);

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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Pre-configured and real booking metadata per calendar date
  final Map<DateTime, List<Map<String, dynamic>>> _dateBookings = {
    DateTime(2026, 10, 5): [
      {
        'name': 'Carlos Gomez',
        'email': 'carlos.g@gmail.com',
        'phone': '+63 917 222 3311',
        'package': 'Cacao Farm Tour',
        'time': '09:00 AM - 11:30 AM',
        'guests': 3,
        'capacityFilled': 14,
        'maxCapacity': 75,
        'status': 'Confirmed',
        'amount': 2250.0,
        'ref': 'GV-2026-105',
        'paymentMethod': 'GCash (Verified)',
      },
    ],
    DateTime(2026, 10, 8): [
      {
        'name': 'Juan dela Cruz',
        'email': 'juan.delacruz@email.com',
        'phone': '+63 917 555 0101',
        'package': 'Cacao Farm Tour',
        'time': '09:00 AM - 11:30 AM',
        'guests': 6,
        'capacityFilled': 6,
        'maxCapacity': 75,
        'status': 'Confirmed',
        'amount': 1500.0,
        'ref': 'GV-2026-108',
        'paymentMethod': 'GCash (Verified)',
      },
    ],
    DateTime(2026, 10, 12): [
      {
        'name': 'Maria Santos',
        'email': 'maria.santos@email.com',
        'phone': '+63 917 123 4567',
        'package': 'Chocolate Making Experience',
        'time': '01:00 PM - 03:30 PM',
        'guests': 45,
        'capacityFilled': 45,
        'maxCapacity': 75,
        'status': 'Pending Verification',
        'amount': 2000.0,
        'ref': 'GV-2026-112',
        'paymentMethod': 'Bank Transfer (Pending)',
      },
    ],
    DateTime(2026, 10, 15): [
      {
        'name': 'Pedro Reyes',
        'email': 'pedro.reyes@email.com',
        'phone': '+63 918 333 4444',
        'package': 'Farm to Table Experience',
        'time': '10:00 AM - 01:00 PM',
        'guests': 38,
        'capacityFilled': 38,
        'maxCapacity': 75,
        'status': 'Confirmed',
        'amount': 3500.0,
        'ref': 'GV-2026-115',
        'paymentMethod': 'GCash (Verified)',
      },
    ],
    DateTime(2026, 10, 18): [
      {
        'name': 'Ana Garcia',
        'email': 'ana.garcia@email.com',
        'phone': '+63 920 777 8888',
        'package': 'Cacao Farm Tour',
        'time': '09:00 AM - 11:30 AM',
        'guests': 12,
        'capacityFilled': 12,
        'maxCapacity': 75,
        'status': 'Confirmed',
        'amount': 2500.0,
        'ref': 'GV-2026-118',
        'paymentMethod': 'GCash (Verified)',
      },
    ],
    DateTime(2026, 10, 20): [
      {
        'name': 'Davao Academy Educational Batch',
        'email': 'tours@davaoacademy.edu.ph',
        'phone': '+63 917 999 1122',
        'package': 'Full Day Immersion & Chocolate Workshop',
        'time': '08:30 AM - 04:30 PM',
        'guests': 75,
        'capacityFilled': 75,
        'maxCapacity': 75,
        'status': 'Confirmed',
        'amount': 18500.0,
        'ref': 'GV-2026-120',
        'paymentMethod': 'Bank Transfer (Verified)',
      },
    ],
    DateTime(2026, 10, 22): [
      {
        'name': 'Luis Mendoza',
        'email': 'luis.mendoza@email.com',
        'phone': '+63 922 888 9900',
        'package': 'Full Day Farm Experience',
        'time': '09:00 AM - 04:00 PM',
        'guests': 60,
        'capacityFilled': 60,
        'maxCapacity': 75,
        'status': 'Confirmed',
        'amount': 1800.0,
        'ref': 'GV-2026-122',
        'paymentMethod': 'GCash (Verified)',
      },
    ],
    DateTime(2026, 10, 25): [
      {
        'name': 'Rosa Cruz',
        'email': 'rosa.cruz@email.com',
        'phone': '+63 919 666 5544',
        'package': 'Chocolate Making Workshop',
        'time': '02:00 PM - 04:30 PM',
        'guests': 22,
        'capacityFilled': 22,
        'maxCapacity': 75,
        'status': 'Confirmed',
        'amount': 2200.0,
        'ref': 'GV-2026-125',
        'paymentMethod': 'GCash (Verified)',
      },
    ],
    DateTime(2026, 10, 28): [
      {
        'name': 'Michael Chen',
        'email': 'michael.chen@gmail.com',
        'phone': '+63 915 444 3322',
        'package': 'Customized Agroforestry Tour',
        'time': '09:30 AM - 12:30 PM',
        'guests': 18,
        'capacityFilled': 18,
        'maxCapacity': 75,
        'status': 'Pending Verification',
        'amount': 3200.0,
        'ref': 'GV-2026-128',
        'paymentMethod': 'Bank Transfer (Pending)',
      },
    ],
  };

  List<Map<String, dynamic>> _getBookingsForDate(DateTime date) {
    for (final entry in _dateBookings.entries) {
      if (_isSameDay(entry.key, date)) {
        return entry.value;
      }
    }
    return [];
  }

  bool _hasBookings(DateTime date) {
    return _getBookingsForDate(date).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final selectedBookings = _getBookingsForDate(_selectedDate);

    final scheduleSlots = [
      {'date': 'Oct 8, 2026', 'slotsFilled': 6, 'maxSlots': 75, 'status': 'Available'},
      {'date': 'Oct 12, 2026', 'slotsFilled': 45, 'maxSlots': 75, 'status': 'Available'},
      {'date': 'Oct 15, 2026', 'slotsFilled': 38, 'maxSlots': 75, 'status': 'Available'},
      {'date': 'Oct 18, 2026', 'slotsFilled': 12, 'maxSlots': 75, 'status': 'Available'},
      {'date': 'Oct 20, 2026', 'slotsFilled': 75, 'maxSlots': 75, 'status': 'Fully Booked'},
      {'date': 'Oct 22, 2026', 'slotsFilled': 60, 'maxSlots': 75, 'status': 'Available'},
      {'date': 'Oct 25, 2026', 'slotsFilled': 22, 'maxSlots': 75, 'status': 'Available'},
      {'date': 'Oct 28, 2026', 'slotsFilled': 18, 'maxSlots': 75, 'status': 'Available'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: (widget.onBack != null || Navigator.canPop(context))
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                onPressed: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              )
            : null,
        title: const Text(
          'Master Farm Calendar',
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
            // Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B5E20).withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: Colors.white, size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Master Schedule & Slot Monitor',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tap dates with yellow dot indicators to inspect scheduled customer bookings and batch quotas.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Smart Interactive Calendar Card
            _buildSmartCalendarCard(),

            const SizedBox(height: 20),

            // Customer Booking Details on Selected Date
            _buildSelectedDateDetails(selectedBookings),

            const SizedBox(height: 24),

            // Daily Capacity Allotments Overview
            const Text(
              '📊 Daily Tour Batch Allotments',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
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
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                    ),
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
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isFull
                                ? AppColors.error.withValues(alpha: 0.1)
                                : AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            slot['status'] as String,
                            style: TextStyle(
                              fontFamily: 'Poppins',
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
                      '$filled / $max Guests Booked (${(ratio * 100).toInt()}% Capacity)',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isFull
                              ? AppColors.error
                              : ratio > 0.6
                                  ? AppColors.accent
                                  : AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
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

  Widget _buildSmartCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Header with Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('📅', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Text(
                    'Smart Calendar',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
                    onPressed: () {
                      setState(() {
                        _displayedMonth = DateTime(
                          _displayedMonth.year,
                          _displayedMonth.month - 1,
                        );
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMMM yyyy').format(_displayedMonth),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                    onPressed: () {
                      setState(() {
                        _displayedMonth = DateTime(
                          _displayedMonth.year,
                          _displayedMonth.month + 1,
                        );
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekday Grid Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => SizedBox(
                      width: 38,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Monthly Calendar Grid with Dot Indicators
          _buildCalendarDaysGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarDaysGrid() {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: List.generate((daysInMonth + firstWeekday + 6) ~/ 7, (weekIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox(width: 38, height: 38);
              }

              final date = DateTime(_displayedMonth.year, _displayedMonth.month, dayNumber);
              final isToday = _isSameDay(date, DateTime(2026, 10, 8)); // Demo sync
              final isSelected = _isSameDay(date, _selectedDate);
              final hasBookings = _hasBookings(date);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1B5E20)
                        : isToday
                            ? AppColors.primaryLight.withValues(alpha: 0.2)
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.5,
                          fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                        ),
                      ),
                      // Dot indicator for dates with bookings
                      if (hasBookings)
                        Container(
                          margin: const EdgeInsets.only(top: 1),
                          width: 4.5,
                          height: 4.5,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(height: 4.5),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildSelectedDateDetails(List<Map<String, dynamic>> bookings) {
    final dateStr = DateFormat('MMMM d, yyyy').format(_selectedDate);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: bookings.isNotEmpty
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.border.withValues(alpha: 0.6),
          width: bookings.isNotEmpty ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.event_note_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Bookings for $dateStr',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: bookings.isNotEmpty
                      ? AppColors.primaryLight.withValues(alpha: 0.2)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  bookings.isNotEmpty ? '${bookings.length} Booked' : 'Available',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: bookings.isNotEmpty ? AppColors.primaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (bookings.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.event_available_rounded, color: AppColors.primary, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'No bookings scheduled on this date',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Full farm capacity (75 slots) is available for walk-ins or reservations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...bookings.map((b) => _buildCustomerBookingCard(b)),
        ],
      ),
    );
  }

  Widget _buildCustomerBookingCard(Map<String, dynamic> b) {
    final int capacity = b['capacityFilled'] as int;
    final int max = b['maxCapacity'] as int;
    final double ratio = capacity / max;
    final String status = b['status'] as String;
    final bool isConfirmed = status == 'Confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer & Status row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  (b['name'] as String).substring(0, 1),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      b['name'] as String,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${b['email']} • ${b['phone']}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isConfirmed
                      ? AppColors.success.withValues(alpha: 0.12)
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: isConfirmed ? AppColors.success : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Tour Details & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.park_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    b['package'] as String,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                _formatPrice(b['amount'] as double),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    b['time'] as String,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                'Ref: ${b['ref']}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Capacity Bar
          Row(
            children: [
              Text(
                '$capacity / $max Capacity',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ratio >= 1.0
                          ? AppColors.error
                          : ratio >= 0.6
                              ? AppColors.accent
                              : AppColors.success,
                    ),
                    minHeight: 5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showCustomerFullDetails(context, b);
                  },
                  icon: const Icon(Icons.info_outline_rounded, size: 14),
                  label: const Text(
                    'Full Details',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Contact prompt sent to ${b['name']} (${b['phone']})'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone_rounded, size: 14),
                  label: const Text(
                    'Call / SMS',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCustomerFullDetails(BuildContext context, Map<String, dynamic> b) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Customer Booking: ${b['name']}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Package / Tour:', b['package'] as String),
            _buildDetailRow('Scheduled Time:', b['time'] as String),
            _buildDetailRow('Guests Count:', '${b['guests']} Guests'),
            _buildDetailRow('Total Amount:', _formatPrice(b['amount'] as double)),
            _buildDetailRow('Payment Info:', b['paymentMethod'] as String),
            _buildDetailRow('Reference No:', b['ref'] as String),
            _buildDetailRow('Contact Phone:', b['phone'] as String),
            _buildDetailRow('Email Address:', b['email'] as String),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
