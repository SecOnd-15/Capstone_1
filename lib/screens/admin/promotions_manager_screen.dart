import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PromotionsManagerScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final VoidCallback? onBack;
  const PromotionsManagerScreen({super.key, this.scaffoldKey, this.onBack});

  @override
  State<PromotionsManagerScreen> createState() => _PromotionsManagerScreenState();
}

class _PromotionsManagerScreenState extends State<PromotionsManagerScreen> {
  final List<Map<String, dynamic>> _promotions = [
    {
      'title': 'Harvest Season Promo',
      'type': 'Banner Promo',
      'description': 'Book Bahandi sa Uma with 4+ guests for an exclusive tablea tasting sampler.',
      'status': 'Active',
    },
    {
      'title': 'Gran Verde Cacao Regenerative Story',
      'type': 'Promotional Video',
      'description': 'Short documentary on agroforest shade-grown cacao & soil restoration.',
      'status': 'Active',
    },
    {
      'title': 'School Agri-Tourism Discount',
      'type': 'Educational Discount',
      'description': '15% group discount for accredited academic institutions & field tours.',
      'status': 'Draft',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          'Ads & Media Management',
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFE65100), Color(0xFF00695C)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.campaign_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Manage promotional banners, promotional videos, and seasonal offers shown to visitors in the client mobile app (Section 2.1.5.2.10).',
                      style: TextStyle(fontSize: 11, color: Colors.white, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Promotional Content & Media',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('New promotional campaign draft added.')),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Promo', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ..._promotions.map((p) {
              final bool isActive = p['status'] == 'Active';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                          p['title'] as String,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.success.withValues(alpha: 0.1) : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            p['status'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isActive ? AppColors.success : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Type: ${p['type']}',
                      style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p['description'] as String,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
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
}
