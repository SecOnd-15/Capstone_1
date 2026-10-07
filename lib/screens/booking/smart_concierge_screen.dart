import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../models/experience_model.dart';
import 'booking_screen.dart';

class SmartConciergeScreen extends StatefulWidget {
  const SmartConciergeScreen({super.key});

  @override
  State<SmartConciergeScreen> createState() => _SmartConciergeScreenState();
}

class _SmartConciergeScreenState extends State<SmartConciergeScreen> {
  // Visitor Preference Inputs (Paper Section 1.2 & 2.2.2.1)
  int _selectedActivityType = 0; // 0: Nature & Walk, 1: Hands-on Workshop, 2: Custom Group/Event
  int _selectedGroupSize = 1;    // 0: Solo/Couple (1-2), 1: Family/Friends (3-6), 2: Large Group/Org (7+)
  int _selectedInterest = 1;     // 0: Cacao Farming & Ecology, 1: Chocolate Making & Culinary, 2: Relaxation/Custom
  int _selectedBudget = 1;       // 0: Budget Friendly (<₱1000), 1: Standard (₱1000-₱2000), 2: Premium (₱2000+)

  bool _isCalculated = false;
  List<Map<String, dynamic>> _recommendations = [];

  // Cosine Similarity Computation (Formula from Paper Section 2.2.2.1)
  double _calculateCosineSimilarity(List<double> userVec, List<double> itemVec) {
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < userVec.length; i++) {
      dotProduct += userVec[i] * itemVec[i];
      normA += userVec[i] * userVec[i];
      normB += itemVec[i] * itemVec[i];
    }

    if (normA == 0 || normB == 0) return 0.0;
    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }

  void _runContentBasedFiltering() {
    // Construct normalized visitor feature vector [Type, Group, Interest, Budget] (0..1)
    final userVector = [
      _selectedActivityType == 0 ? 0.9 : (_selectedActivityType == 1 ? 0.6 : 0.7),
      _selectedGroupSize == 0 ? 0.6 : (_selectedGroupSize == 1 ? 0.8 : 0.95),
      _selectedInterest == 0 ? 0.6 : (_selectedInterest == 1 ? 0.95 : 0.85),
      _selectedBudget == 0 ? 0.9 : (_selectedBudget == 1 ? 0.65 : 0.4),
    ];

    final coreOfferings = ExperienceData.all.where((e) => e.isCoreOffering).toList();
    final results = <Map<String, dynamic>>[];

    for (var exp in coreOfferings) {
      final similarity = _calculateCosineSimilarity(userVector, exp.featureVector);
      final matchPercentage = (similarity * 100).clamp(50.0, 99.4);
      results.add({
        'experience': exp,
        'similarity': similarity,
        'matchPercentage': matchPercentage.toStringAsFixed(1),
      });
    }

    // Rank highest cosine similarity first
    results.sort((a, b) => (b['similarity'] as double).compareTo(a['similarity'] as double));

    setState(() {
      _recommendations = results;
      _isCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Smart Concierge Matching',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Text('✨', style: TextStyle(fontSize: 32)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personalized Experience Matcher',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Using Content-Based Filtering & Cosine Similarity to find your ideal Gran Verde agri-tourism package.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Question 1: Activity Type
            _buildSectionHeader('1. Preferred Experience Style'),
            const SizedBox(height: 8),
            _buildChoiceChips(
              options: ['🌿 Nature Trail & Agroforest Walk', '🍫 Hands-on Chocolate Making', '✨ Bespoke Custom Package'],
              selectedIndex: _selectedActivityType,
              onSelected: (idx) => setState(() => _selectedActivityType = idx),
            ),

            const SizedBox(height: 18),

            // Question 2: Group Size
            _buildSectionHeader('2. Group Size & Visitor Type'),
            const SizedBox(height: 8),
            _buildChoiceChips(
              options: ['Solo / Couple (1–2 guests)', 'Family & Friends (3–6 guests)', 'Corporate / Academic Group (7+ guests)'],
              selectedIndex: _selectedGroupSize,
              onSelected: (idx) => setState(() => _selectedGroupSize = idx),
            ),

            const SizedBox(height: 18),

            // Question 3: Primary Interest
            _buildSectionHeader('3. Main Interest / Focus'),
            const SizedBox(height: 8),
            _buildChoiceChips(
              options: ['Regenerative Farming & Biodiversity', 'Gastronomy, Roasting & Tasting', 'Private Retreat & Tailored Activities'],
              selectedIndex: _selectedInterest,
              onSelected: (idx) => setState(() => _selectedInterest = idx),
            ),

            const SizedBox(height: 18),

            // Question 4: Budget Range
            _buildSectionHeader('4. Target Budget Range per Guest'),
            const SizedBox(height: 8),
            _buildChoiceChips(
              options: ['₱500 – ₱900 (Value)', '₱1,000 – ₱1,800 (Standard Immersion)', '₱2,000+ (Comprehensive/Retreat)'],
              selectedIndex: _selectedBudget,
              onSelected: (idx) => setState(() => _selectedBudget = idx),
            ),

            const SizedBox(height: 24),

            // Compute Matching Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _runContentBasedFiltering,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const Text(
                  'Calculate Best Matches',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            if (_isCalculated) ...[
              const SizedBox(height: 32),
              const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Recommended Packages (Ranked)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ..._recommendations.map((item) {
                final Experience exp = item['experience'];
                final String match = item['matchPercentage'];
                final bool isTop = _recommendations.first == item;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isTop ? AppColors.primary : Colors.grey.shade200,
                      width: isTop ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: exp.gradientColors),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(exp.imageEmoji, style: const TextStyle(fontSize: 24)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        exp.title,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      if (isTop) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'BEST FIT',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    exp.subtitle,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Match badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isTop ? AppColors.success.withValues(alpha: 0.15) : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$match% Match',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isTop ? AppColors.success : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          exp.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₱${exp.price.toStringAsFixed(0)} / person',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookingScreen(experience: exp),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Book This Package'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildChoiceChips({
    required List<String> options,
    required int selectedIndex,
    required Function(int) onSelected,
  }) {
    return Column(
      children: List.generate(options.length, (idx) {
        final isSelected = selectedIndex == idx;
        return GestureDetector(
          onTap: () => onSelected(idx),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? AppColors.primary : Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    options[idx],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
