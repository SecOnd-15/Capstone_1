import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FeedbackReviewsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const FeedbackReviewsScreen({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    // Weighted criteria averages (Paper Section 2.1.5.2.7)
    final criteriaScores = [
      {'name': 'Satisfaction with Guides & Trail', 'score': 4.9, 'weight': '35%'},
      {'name': 'Experience Quality & Roasting Workshop', 'score': 4.8, 'weight': '35%'},
      {'name': 'Overall Value & Cacao Product Tasting', 'score': 4.9, 'weight': '30%'},
    ];

    final sampleReviews = [
      {
        'author': 'Emerson Latog',
        'date': 'Oct 01, 2026',
        'package': 'Kakaw Lakaw (Living Forest Walk)',
        'rating': 5.0,
        'comment':
            'Superb agroforest trail! Tasting fresh cacao straight from the pod was an unforgettable highlight. Highly recommended for students and families.',
      },
      {
        'author': 'Juan Dela Cruz',
        'date': 'Sep 28, 2026',
        'package': 'Bahandi sa Uma (Full Workshop)',
        'rating': 5.0,
        'comment':
            'The hands-on bean roasting and tablea grinding were very educational. The farm lunch was organic and delicious.',
      },
      {
        'author': 'Clara Reyes',
        'date': 'Sep 20, 2026',
        'package': 'Customized Options (Research Group)',
        'rating': 4.8,
        'comment':
            'Great regenerative farming briefing and hospitable farm staff. Very clean facilities and well-organized schedule.',
      },
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
          'Customer Feedback & Reviews',
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
            // Overall Weighted Score Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE65100), Color(0xFFBF360C)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weighted Score',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      const Row(
                        children: [
                          Text(
                            '4.88',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text('★', style: TextStyle(fontSize: 26, color: Colors.amberAccent)),
                        ],
                      ),
                      const Text(
                        'Based on 142 completed visits',
                        style: TextStyle(fontSize: 10, color: Colors.white70),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'EXCELLENT',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Weighted Criteria Breakdown
            const Text(
              'Weighted Statistical Criteria (Paper Section 2.1.5.2.7)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...criteriaScores.map((c) {
              final double score = c['score'] as double;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['name'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text('Factor weight: ${c['weight']}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Text(
                      '${score.toStringAsFixed(1)} ★',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 22),

            // Recent Reviews List
            const Text(
              'Recent Guest Feedback',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...sampleReviews.map((r) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
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
                          r['author'] as String,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${r['rating']} ★',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.amber),
                        ),
                      ],
                    ),
                    Text(
                      '${r['package']} • ${r['date']}',
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      r['comment'] as String,
                      style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4),
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
