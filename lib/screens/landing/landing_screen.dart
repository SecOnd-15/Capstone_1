import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/experience_model.dart';
import '../../models/user_session.dart';
import '../auth/login_screen.dart';
import '../auth/registration_screen.dart';
import '../booking/smart_concierge_screen.dart';
import '../booking/quick_booking_modal.dart';
import '../experiences/experience_detail_screen.dart';
import '../navigation/main_navigation.dart';
import '../admin/admin_main_navigation.dart';
import '../inquiry/inquiry_screen.dart';
import 'chatbot_sheet.dart';

class FarmProduct {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String unit;
  final String emoji;
  final List<Color> gradientColors;
  final String badge;
  final double rating;

  const FarmProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.unit,
    required this.emoji,
    required this.gradientColors,
    required this.badge,
    required this.rating,
  });
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedFilterIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<String> _filters = [
    '✨ All Offerings',
    '🌿 Cacao Tours & Packages',
    '🍫 Artisan Cacao Store',
    '🌱 Regenerative Farm Story',
  ];

  static const List<FarmProduct> farmProducts = [
    FarmProduct(
      id: 'prod_tablea',
      name: 'Gran Verde Pure Tablea (100% Cacao)',
      category: 'Artisan Store',
      description: 'Hand-roasted, stone-ground pure cacao rolls crafted from single-origin Davao beans. Zero additives or sugar.',
      price: 180.0,
      unit: '250g roll pack',
      emoji: '🍫',
      gradientColors: [Color(0xFF3E2723), Color(0xFF5D4037)],
      badge: 'Best Seller',
      rating: 4.9,
    ),
    FarmProduct(
      id: 'prod_dark_choco',
      name: 'Single-Origin 70% Dark Chocolate Bar',
      category: 'Artisan Store',
      description: 'Artisanal tree-to-bar dark chocolate with floral and fruity notes characteristic of Davao volcanic terroir.',
      price: 220.0,
      unit: '85g artisan bar',
      emoji: '🍫',
      gradientColors: [Color(0xFF4E342E), Color(0xFF6D4C41)],
      badge: 'Gold Medal',
      rating: 5.0,
    ),
    FarmProduct(
      id: 'prod_cacao_nibs',
      name: 'Roasted Organic Cacao Nibs',
      category: 'Artisan Store',
      description: 'Crushed raw roasted cacao beans rich in antioxidants, magnesium, and natural flavonoids for smoothies and snacking.',
      price: 160.0,
      unit: '200g pouch',
      emoji: '🌰',
      gradientColors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
      badge: 'Organic',
      rating: 4.8,
    ),
    FarmProduct(
      id: 'prod_cacao_tea',
      name: 'Regenerative Cacao Husk Herbal Tea',
      category: 'Artisan Store',
      description: 'Aromatic loose-leaf infusion brewed from roasted cacao shell husks. Zero calorie, rich in theobromine.',
      price: 140.0,
      unit: '150g eco-tin',
      emoji: '☕',
      gradientColors: [Color(0xFF8D6E63), Color(0xFFA1887F)],
      badge: 'Zero-Waste',
      rating: 4.7,
    ),
    FarmProduct(
      id: 'prod_cacao_butter',
      name: 'Raw Cold-Pressed Cacao Butter Balm',
      category: 'Farm Wellness',
      description: '100% virgin unrefined cacao butter moisturizing balm with a natural rich chocolate scent.',
      price: 250.0,
      unit: '100ml glass jar',
      emoji: '✨',
      gradientColors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
      badge: 'Farm Made',
      rating: 4.9,
    ),
    FarmProduct(
      id: 'prod_cacao_seedling',
      name: 'UF18 Grafted Cacao Seedling Kit',
      category: 'Agroforestry',
      description: 'High-yielding disease-resilient grafted cacao seedling with organic compost starter bag.',
      price: 120.0,
      unit: '1 pot + guide',
      emoji: '🌱',
      gradientColors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
      badge: 'Grow Your Own',
      rating: 4.9,
    ),
  ];

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

  void _navigateToAuth(BuildContext context, {bool isLogin = true}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => isLogin ? const LoginScreen() : const RegistrationScreen(),
      ),
    ).then((_) => setState(() {}));
  }

  void _handleBookExperience(BuildContext context, Experience exp) {
    QuickBookingModal.show(context, exp);
  }

  void _handleViewDetails(BuildContext context, Experience exp) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExperienceDetailScreen(experience: exp),
      ),
    );
  }

  void _handleStoreInquiry(BuildContext context, FarmProduct prod) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: prod.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(prod.emoji, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prod.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatPrice(prod.price)} / ${prod.unit}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              prod.description,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.eco_rounded, color: AppColors.primary, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'All products are harvested & produced on-site in Davao del Norte using zero-chemical regenerative practices.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Added "${prod.name}" to your quotation inquiries!',
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: AppColors.primary,
                          action: SnackBarAction(
                            label: 'View Concierge',
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SmartConciergeScreen()),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                    label: const Text(
                      'Add to Farm Inquiry',
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

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Top Navigation Bar
          SliverAppBar(
            backgroundColor: AppColors.surface,
            elevation: 1,
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.eco_rounded, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                const Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Gran Verde Cacao',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Regenerative Farm • Davao',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              if (session.isLoggedIn) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ActionChip(
                    avatar: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        session.initials.isNotEmpty ? session.initials : 'U',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                    label: Text(
                      session.isAdminOrStaff ? 'Portal (${session.roleDisplay})' : 'My Account',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    backgroundColor: AppColors.primaryLight.withValues(alpha: 0.15),
                    onPressed: () {
                      if (session.isAdminOrStaff) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminMainNavigation()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MainNavigation()),
                        );
                      }
                    },
                  ),
                ),
              ] else ...[
                TextButton(
                  onPressed: () => _navigateToAuth(context, isLogin: true),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ElevatedButton(
                    onPressed: () => _navigateToAuth(context, isLogin: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Scrollable Landing Page Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Showcase Section
                _buildHeroBanner(context),
                const SizedBox(height: 18),

                // 2. Farm Metric Highlights
                _buildMetricHighlights(),
                const SizedBox(height: 20),

                // 3. AI Smart Concierge Teaser Card (Overflow-proof)
                _buildConciergeFeatureCard(context),
                const SizedBox(height: 22),

                // 4. Offerings Filter Tabs
                _buildFilterTabs(),
                const SizedBox(height: 18),

                // 5. Dynamic Content Section based on selected filter
                if (_selectedFilterIndex == 0 || _selectedFilterIndex == 1) ...[
                  _buildSectionHeader(
                    title: '🌿 Farm Tours & Cacao Experiences',
                    subtitle: 'From tree-to-bar workshops to guided agroforestry canopy walks',
                  ),
                  _buildExperiencesList(context),
                  const SizedBox(height: 28),
                ],

                if (_selectedFilterIndex == 0 || _selectedFilterIndex == 2) ...[
                  _buildSectionHeader(
                    title: '🍫 Artisan Cacao & Farm Store',
                    subtitle: 'Pure single-origin Davao tablea, dark chocolate & farm wellness products',
                  ),
                  _buildFarmStoreGrid(context),
                  const SizedBox(height: 28),
                ],

                if (_selectedFilterIndex == 0 || _selectedFilterIndex == 3) ...[
                  _buildSectionHeader(
                    title: '🌱 The Gran Verde Regenerative Difference',
                    subtitle: 'Restoring soil vitality and empowering local cacao agroforestry',
                  ),
                  _buildRegenerativePillars(),
                  const SizedBox(height: 28),
                ],

                // 6. Featured Promotional Advertisement & Video Showcase
                _buildAdvertisementSection(context),
                const SizedBox(height: 28),

                // 7. Visitor Testimonials & Social Proof
                _buildTestimonialsSection(),
                const SizedBox(height: 28),

                // 8. Footer with Farm Details, Hours & Portal Link
                _buildLandingFooter(context),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ChatBotSheet.show(context),
        backgroundColor: const Color(0xFF0F4E31),
        elevation: 6,
        shape: const CircleBorder(),
        tooltip: 'Chat with Verde Bot',
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 28),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF004D40), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on_rounded, color: AppColors.accent, size: 13),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Davao del Norte • Regenerative Cacao Farm',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Immerse in Single-Origin\nCacao Agri-Tourism',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover heritage cacao farming, craft tree-to-bar chocolate, and explore sustainable agroforestry nestled in the lush valleys of Davao.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SmartConciergeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: const Text(
                        'Smart Concierge AI',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _selectedFilterIndex = 1);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.explore_outlined, size: 16),
                      label: const Text(
                        'Browse Experiences',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildMetricHighlights() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildMetricItem('15+', 'Hectares Canopy', Icons.forest_rounded),
          const SizedBox(width: 8),
          _buildMetricItem('100%', 'Single-Origin', Icons.verified_rounded),
          const SizedBox(width: 8),
          _buildMetricItem('4.9★', 'Visitor Rating', Icons.star_rounded),
          const SizedBox(width: 8),
          _buildMetricItem('0%', 'Chemicals Used', Icons.eco_rounded),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String val, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(height: 3),
            Text(
              val,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 8.5,
                color: AppColors.textSecondary,
                height: 1.15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConciergeFeatureCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, Color(0xFFFFB300)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.psychology_rounded, color: AppColors.primaryDark, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Wrap to prevent pixel overflow on any screen size
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Smart Agri-Tourism AI',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Cosine Matching',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Get tailored recommendations based on group size, budget, and learning preferences.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SmartConciergeScreen()),
              );
            },
            icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(8),
              minimumSize: const Size(36, 36),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return ChoiceChip(
            label: Text(
              _filters[index],
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onSelected: (val) {
              if (val) setState(() => _selectedFilterIndex = index);
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildExperiencesList(BuildContext context) {
    final experiences = ExperienceData.all;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: experiences.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final exp = experiences[index];
        return _buildExperienceCard(context, exp);
      },
    );
  }

  Widget _buildExperienceCard(BuildContext context, Experience exp) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: exp.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(exp.imageEmoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (exp.isCoreOffering)
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '🌟 Core Signature Tour',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      Text(
                        exp.title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        exp.subtitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatPrice(exp.price),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      '/ person',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9.5,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Card Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.description,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Inclusions Preview Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: exp.inclusions.take(3).map((inc) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 11, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            inc,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Card Action Buttons
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.accent, size: 15),
                        const SizedBox(width: 3),
                        Text(
                          '${exp.rating}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          ' (${exp.reviewCount})',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () => _handleViewDetails(context, exp),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _handleBookExperience(context, exp),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildFarmStoreGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemCount: farmProducts.length,
        itemBuilder: (context, index) {
          final prod = farmProducts[index];
          return _buildStoreProductCard(context, prod);
        },
      ),
    );
  }

  Widget _buildStoreProductCard(BuildContext context, FarmProduct prod) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
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
          Container(
            height: 85,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: prod.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(prod.emoji, style: const TextStyle(fontSize: 34)),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      prod.badge,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prod.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    prod.unit,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatPrice(prod.price),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      InkWell(
                        onTap: () => _handleStoreInquiry(context, prod),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 15,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegenerativePillars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildPillarCard(
            title: '1. Multi-Story Agroforestry Canopy',
            description: 'Our cacao trees thrive under native Davao hardwood shade trees, fostering natural bird habitats, humidity retention, and zero artificial shading.',
            icon: Icons.park_rounded,
            color: const Color(0xFF2E7D32),
          ),
          const SizedBox(height: 10),
          _buildPillarCard(
            title: '2. 100% Zero-Chemical Soil Vitality',
            description: 'Composted cacao husks, nitrogen-fixing cover crops, and microbial rich bio-fertilizers nourish the earth without synthetic pesticides.',
            icon: Icons.compost_rounded,
            color: const Color(0xFF689F38),
          ),
          const SizedBox(height: 10),
          _buildPillarCard(
            title: '3. Single-Origin Tree-to-Bar Purity',
            description: 'Every chocolate bar and tablea roll is fermented in wooden sweatboxes, sun-dried on bamboo beds, and stone-ground locally.',
            icon: Icons.breakfast_dining_rounded,
            color: const Color(0xFF8D6E63),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.rate_review_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Visitor Experiences & Feedback',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildReviewItem(
            name: 'Dr. Katherine V. (Agri-Sciences)',
            rating: 5,
            review: '"The Kakaw Lakaw walk gave our university research cohort deep insights into sustainable bio-intensive cacao farming. The fresh pulp tasting was unforgettable!"',
          ),
          const Divider(height: 18),
          _buildReviewItem(
            name: 'Marco & Elena S. (Tourists)',
            rating: 5,
            review: '"We crafted our own chocolate bars in the Bahandi workshop and brought home pure tablea. The Smart Concierge match was 100% spot on!"',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({required String name, required int rating, required String review}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: List.generate(
                rating,
                (index) => const Icon(Icons.star_rounded, size: 13, color: AppColors.accent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          review,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10.5,
            fontStyle: FontStyle.italic,
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildLandingFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 32),
      color: const Color(0xFF1E293B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.eco_rounded, color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Gran Verde Cacao Farm',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '📍 Davao del Norte, Philippines\n🕒 Visiting Hours: Mon - Sun (8:00 AM - 5:00 PM)\n📞 Inquiries: +63 917 545 1220\n📧 info@granverde.com',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10.5,
              color: Colors.white70,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '© 2026 Gran Verde Farm',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9.5,
                  color: Colors.white54,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToAuth(context, isLogin: true),
                child: const Text(
                  'Staff & Admin Portal →',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertisementSection(BuildContext context) {
    const promoTitle = 'Davao Harvest Season & Tree-to-Bar Immersion';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4E31), Color(0xFF003822), Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.campaign_rounded, size: 13, color: Color(0xFF451A03)),
                            SizedBox(width: 4),
                            Text(
                              'FEATURED ADVERTISEMENT',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF451A03),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Limited Season Offer',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  const Text(
                    '🎬 Experience the Full Heritage Cacao Journey',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Watch our farm documentary & promotional showcase. Discover artisanal processing, organic pods harvesting, and tree-to-bar workshops.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Promo Video / Image Showcase Box with Play Button
                  GestureDetector(
                    onTap: () => _showAdvertisementModal(context, promoTitle),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20), Color(0xFF332014)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.25,
                              child: const Center(
                                child: Text('🍫 🌿 🌰 ☀️', style: TextStyle(fontSize: 32)),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF0F4E31), size: 32),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tap to View Video & Promo Details',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Highlights row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _PromoHighlightPill(icon: '🎟️', text: '15% Group Off'),
                        _PromoHighlightPill(icon: '☕', text: 'Free Tablea Cup'),
                        _PromoHighlightPill(icon: '🌱', text: 'Canopy Walk'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Prominent CONTINUE Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InquiryScreen(
                              adTitle: promoTitle,
                              initialInterest: 'Tree-to-Bar Workshop',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0F4E31), size: 20),
                      label: const Text(
                        'Continue to Inquiry',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F4E31),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBBF24),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
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

  void _showAdvertisementModal(BuildContext context, String promoTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Promotional Showcase',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F4E31),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Player Mock
                    Container(
                      height: 190,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F4E31), Color(0xFF1B5E20), Color(0xFF26140B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF0F4E31), size: 36),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Gran Verde Cacao Documentary Preview',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Duration: 2 mins • 4K Agroforestry Immersion',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 10,
                            left: 12,
                            right: 12,
                            child: Row(
                              children: [
                                const Icon(Icons.pause_circle_outline_rounded, color: Colors.white70, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: 0.65,
                                      child: Container(
                                        color: const Color(0xFF22C55E),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('01:18 / 02:00', style: TextStyle(color: Colors.white70, fontSize: 9.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      promoTitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F4E31),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Immerse in the authentic Davao cacao agroforestry sanctuary. Learn fermentation, sun-drying techniques, and handcraft pure single-origin tablea chocolate in our heritage facility.',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 12.5, color: Color(0xFF4B5563), height: 1.45),
                    ),

                    const SizedBox(height: 16),

                    // Package Perks
                    const Text(
                      '✨ Featured Inclusions & Perks',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13.5, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    _buildPerkItem(Icons.verified_rounded, '15% Group Discount for 5+ registered participants'),
                    _buildPerkItem(Icons.local_cafe_rounded, 'Freshly batirol-whisked Tablea tasting cup + native snacks'),
                    _buildPerkItem(Icons.park_rounded, 'Guided agroforestry biodiversity & canopy walk'),
                    _buildPerkItem(Icons.card_giftcard_rounded, 'Complimentary 100g Gran Verde single-origin tablea pack'),

                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF5F0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF8BCFA5)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: Color(0xFF0F4E31), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Click Continue below to send an inquiry with your preferred schedule and group size. No upfront payment required!',
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Color(0xFF0F4E31)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Continue CTA
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx); // Close modal
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InquiryScreen(
                          adTitle: promoTitle,
                          initialInterest: 'Tree-to-Bar Workshop',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  label: const Text(
                    'Continue to Inquiry Page',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4E31),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerkItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: const Color(0xFF0F4E31)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoHighlightPill extends StatelessWidget {
  final String icon;
  final String text;

  const _PromoHighlightPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

