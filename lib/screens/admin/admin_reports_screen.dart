import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AdminReportsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final VoidCallback? onBack;
  const AdminReportsScreen({super.key, this.scaffoldKey, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: (onBack != null || Navigator.canPop(context))
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                onPressed: () {
                  if (onBack != null) {
                    onBack!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              )
            : null,
        title: const Text(
          'Descriptive Reports',
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
            // Header Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00695C), Color(0xFF004D40)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.analytics_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descriptive Analytics Engine',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Aggregated visitor tracking & service selection data for Gran Verde management reporting.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
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

            // Report 1: Most Frequently Selected Packages (Paper Section 2.1.5.2.8)
            _buildReportCard(
              title: '1. Most Frequently Selected Packages',
              subtitle: 'Distribution of visitor bookings across offerings',
              children: [
                _buildProgressRow('Kakaw Lakaw (Living Cacao Walk)', 0.48, '48% (142 visits)', const Color(0xFF2E7D32)),
                _buildProgressRow('Bahandi sa Uma (Heritage Workshop)', 0.36, '36% (118 visits)', const Color(0xFF5D4037)),
                _buildProgressRow('Customized Options (Group Retreats)', 0.16, '16% (64 visits)', const Color(0xFF00695C)),
              ],
            ),

            const SizedBox(height: 16),

            // Report 2: Visitor Place of Origin Breakdown
            _buildReportCard(
              title: '2. Visitor Place of Origin Patterns',
              subtitle: 'Regional distribution of farm tourists',
              children: [
                _buildProgressRow('Davao Region (Local & Regional)', 0.54, '54%', AppColors.primary),
                _buildProgressRow('Metro Manila & Luzon', 0.26, '26%', Colors.indigo),
                _buildProgressRow('Visayas (Cebu / Iloilo)', 0.14, '14%', Colors.teal),
                _buildProgressRow('International Visitors', 0.06, '6%', Colors.amber.shade800),
              ],
            ),

            const SizedBox(height: 16),

            // Report 3: Purpose of Visit
            _buildReportCard(
              title: '3. Purpose of Visit Analysis',
              subtitle: 'Motivation factors for agri-tourism visits',
              children: [
                _buildProgressRow('Educational & Leisure', 0.42, '42%', Colors.green),
                _buildProgressRow('Family Recreation', 0.30, '30%', Colors.orange),
                _buildProgressRow('Academic Field Study', 0.18, '18%', Colors.blue),
                _buildProgressRow('Agri-Business & Research', 0.10, '10%', Colors.purple),
              ],
            ),

            const SizedBox(height: 16),

            // Report 4: Referral Channels
            _buildReportCard(
              title: '4. Visitor Discovery Channels',
              subtitle: 'How visitors learned about Gran Verde Farm',
              children: [
                _buildProgressRow('Social Media (FB/IG)', 0.52, '52%', Colors.blue.shade700),
                _buildProgressRow('Word of Mouth / Referral', 0.28, '28%', Colors.green.shade700),
                _buildProgressRow('Official Website', 0.12, '12%', Colors.orange.shade700),
                _buildProgressRow('Tourism / Agriculture Expo', 0.08, '8%', Colors.pink.shade700),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, double progress, String valueStr, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                valueStr,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
