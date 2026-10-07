import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_model.dart';

class VisitorDatabaseScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const VisitorDatabaseScreen({super.key, this.scaffoldKey});

  @override
  State<VisitorDatabaseScreen> createState() => _VisitorDatabaseScreenState();
}

class _VisitorDatabaseScreenState extends State<VisitorDatabaseScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final bookings = BookingStore.instance.all;

    // Aggregate unique visitor records from bookings
    final visitorsMap = <String, Map<String, dynamic>>{};
    for (var b in bookings) {
      if (!visitorsMap.containsKey(b.email)) {
        visitorsMap[b.email] = {
          'name': b.visitorName,
          'email': b.email,
          'phone': b.phone,
          'origin': b.placeOfOrigin,
          'purpose': b.purposeOfVisit,
          'howLearned': b.howLearned,
          'totalBookings': 1,
          'lastBooking': b.date,
        };
      } else {
        visitorsMap[b.email]!['totalBookings'] =
            (visitorsMap[b.email]!['totalBookings'] as int) + 1;
      }
    }

    // Add extra sample visitor entries for full database view
    if (!visitorsMap.containsKey('juan.delacruz@email.com')) {
      visitorsMap['juan.delacruz@email.com'] = {
        'name': 'Juan Dela Cruz',
        'email': 'juan.delacruz@email.com',
        'phone': '+63 918 222 3344',
        'origin': 'Tagum City',
        'purpose': 'Academic Field Study',
        'howLearned': 'Friend / Referral',
        'totalBookings': 2,
        'lastBooking': 'Oct 12, 2026',
      };
    }
    if (!visitorsMap.containsKey('clara.reyes@email.com')) {
      visitorsMap['clara.reyes@email.com'] = {
        'name': 'Clara Reyes',
        'email': 'clara.reyes@email.com',
        'phone': '+63 920 555 7890',
        'origin': 'Cebu City',
        'purpose': 'Agri-Business & Research',
        'howLearned': 'Tourism Expo',
        'totalBookings': 1,
        'lastBooking': 'Oct 05, 2026',
      };
    }

    final visitorList = visitorsMap.values.where((v) {
      final name = (v['name'] as String).toLowerCase();
      final origin = (v['origin'] as String).toLowerCase();
      final q = _searchQuery.toLowerCase();
      return name.contains(q) || origin.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
        ),
        title: const Text(
          'Visitor Tracking Database',
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
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search visitors by name or origin...',
                prefixIcon: const Icon(Icons.search_rounded),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),

          // Visitor count badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${visitorList.length} Registered Visitors',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Text(
                  'Centralized Firestore Mock',
                  style: TextStyle(fontSize: 10, color: AppColors.primary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Visitor List
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: visitorList.length,
              itemBuilder: (context, index) {
                final v = visitorList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                            child: Text(
                              (v['name'] as String).substring(0, 1),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v['name'],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${v['email']} • ${v['phone']}',
                                  style: const TextStyle(
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
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${v['totalBookings']} Visits',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey.shade200),
                      const SizedBox(height: 6),
                      _buildRow('📍 Origin', v['origin']),
                      _buildRow('🎯 Purpose', v['purpose']),
                      _buildRow('📢 Referral', v['howLearned']),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
