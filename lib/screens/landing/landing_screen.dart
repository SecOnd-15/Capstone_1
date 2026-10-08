import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../models/experience_model.dart';
import '../../models/user_session.dart';
import '../auth/login_screen.dart';
import '../auth/registration_screen.dart';
import '../booking/smart_concierge_screen.dart';
import '../booking/quick_booking_modal.dart';
import '../navigation/main_navigation.dart';
import '../admin/admin_main_navigation.dart';
import '../inquiry/inquiry_screen.dart';
import 'chatbot.dart';
import 'farm_map_viewer.dart';

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
  final String? imageUrl;

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
    this.imageUrl,
  });
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedCategoryIndex = 0; // 0 = Tours & Packages, 1 = Artisan Store
  late final PageController _toursCarouselController;
  late final PageController _storeCarouselController;
  int _toursCardIndex = 0;
  int _storeCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _toursCarouselController = PageController(viewportFraction: 0.88);
    _storeCarouselController = PageController(viewportFraction: 0.88);
    UserSession.instance.addListener(_onSessionChanged);
  }

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    UserSession.instance.removeListener(_onSessionChanged);
    _scrollController.dispose();
    _toursCarouselController.dispose();
    _storeCarouselController.dispose();
    super.dispose();
  }

  void _scrollToOfferings() {
    setState(() => _selectedCategoryIndex = 0);
    _scrollController.animateTo(
      420,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  static const List<FarmProduct> farmProducts = [
    FarmProduct(
      id: 'prod_tablea',
      name: 'Gran Verde Pure Tablea (100% Cacao)',
      category: 'Artisan Store',
      description: 'Hand-roasted, stone-ground pure cacao rolls crafted from single-origin Davao beans. Zero additives or sugar.',
      price: 180.0,
      unit: '250g roll pack',
      emoji: '🍫',
      imageUrl: 'https://images.unsplash.com/photo-1606312619070-d48b4c652a52?auto=format&fit=crop&w=800&q=80',
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
      imageUrl: 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?auto=format&fit=crop&w=800&q=80',
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
      imageUrl: 'https://images.unsplash.com/photo-1587132137056-bfbf0166836e?auto=format&fit=crop&w=800&q=80',
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
      imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?auto=format&fit=crop&w=800&q=80',
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
      imageUrl: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?auto=format&fit=crop&w=800&q=80',
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
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=800&q=80',
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

  // ── Pop-up Experience Detail Modal Sheet ────────────────────────
  void _handleViewExperienceDetails(BuildContext context, Experience exp) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (modalCtx) => _buildExperienceDetailModal(context, modalCtx, exp),
    );
  }

  Widget _buildExperienceDetailModal(BuildContext rootContext, BuildContext modalCtx, Experience exp) {
    return Container(
      height: MediaQuery.of(modalCtx).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Scrollable Body ───────────────────────────
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Modal Top Image Header
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (exp.imageUrl != null && exp.imageUrl!.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: exp.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (ctx, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: exp.gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(exp.imageEmoji, style: const TextStyle(fontSize: 48)),
                              ),
                            ),
                            errorWidget: (ctx, url, err) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: exp.gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(exp.imageEmoji, style: const TextStyle(fontSize: 48)),
                              ),
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: exp.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(exp.imageEmoji, style: const TextStyle(fontSize: 48)),
                            ),
                          ),

                        // Scrim
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.6),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.85),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),

                        // Drag indicator
                        Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),

                        // Close button
                        Positioned(
                          top: 14,
                          right: 14,
                          child: InkWell(
                            onTap: () => Navigator.pop(modalCtx),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ),

                        // Badge top-left
                        Positioned(
                          top: 18,
                          left: 16,
                          child: exp.isCoreOffering
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star_rounded, size: 14, color: AppColors.primaryDark),
                                      SizedBox(width: 4),
                                      Text(
                                        'Signature Tour',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    exp.category,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),

                        // Title & Price on bottom of image
                        Positioned(
                          bottom: 14,
                          left: 16,
                          right: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  exp.title,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark.withValues(alpha: 0.95),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content Details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subtitle
                        Text(
                          exp.subtitle,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Stats Row (Rating, Duration, Category)
                        Row(
                          children: [
                            _buildModalStatChip(
                              Icons.star_rounded,
                              '${exp.rating} (${exp.reviewCount})',
                              AppColors.accent,
                            ),
                            const SizedBox(width: 8),
                            _buildModalStatChip(
                              Icons.schedule_rounded,
                              exp.duration,
                              AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            _buildModalStatChip(
                              Icons.category_rounded,
                              exp.category,
                              AppColors.secondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // About Section
                        const Text(
                          'About This Experience',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exp.description,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),

                        // What's Included Section
                        const Text(
                          "What's Included",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...exp.inclusions.map((inc) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    inc,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 20),

                        // Available Dates Preview
                        if (exp.availableDates.isNotEmpty) ...[
                          const Text(
                            'Available Schedule',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: exp.availableDates.map((date) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.event_available_rounded, size: 13, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      date,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Available Add-ons Preview
                        if (exp.availableAddOns.isNotEmpty) ...[
                          const Text(
                            'Optional Enhancements & Add-ons',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...exp.availableAddOns.take(3).map((addon) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.add_circle_outline_rounded, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addon.name,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          addon.description,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 9.5,
                                            color: AppColors.textSecondary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+${_formatPrice(addon.price)}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky Bottom Action Bar ─────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.8))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Rate',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        _formatPrice(exp.price),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(modalCtx);
                        QuickBookingModal.show(rootContext, exp);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.calendar_month_rounded, size: 18),
                      label: const Text(
                        'Book This Experience',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pop-up Product Detail Modal Sheet (Artisan Store) ───────────
  void _handleViewProductDetails(BuildContext context, FarmProduct prod) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (modalCtx) => _buildProductDetailModal(context, modalCtx, prod),
    );
  }

  Widget _buildProductDetailModal(BuildContext rootContext, BuildContext modalCtx, FarmProduct prod) {
    return Container(
      height: MediaQuery.of(modalCtx).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Scrollable Body ───────────────────────────
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Modal Top Image Header
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (prod.imageUrl != null && prod.imageUrl!.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: prod.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (ctx, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: prod.gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(prod.emoji, style: const TextStyle(fontSize: 48)),
                              ),
                            ),
                            errorWidget: (ctx, url, err) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: prod.gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(prod.emoji, style: const TextStyle(fontSize: 48)),
                              ),
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: prod.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(prod.emoji, style: const TextStyle(fontSize: 48)),
                            ),
                          ),

                        // Scrim
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.6),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.85),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),

                        // Drag indicator
                        Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),

                        // Close button
                        Positioned(
                          top: 14,
                          right: 14,
                          child: InkWell(
                            onTap: () => Navigator.pop(modalCtx),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ),

                        // Badge top-left
                        Positioned(
                          top: 18,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              prod.badge,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),

                        // Title & Price on bottom of image
                        Positioned(
                          bottom: 14,
                          left: 16,
                          right: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  prod.name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark.withValues(alpha: 0.95),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _formatPrice(prod.price),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '/ ${prod.unit}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 9.5,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content Details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category & Unit
                        Row(
                          children: [
                            _buildModalStatChip(
                              Icons.star_rounded,
                              '${prod.rating} Rating',
                              AppColors.accent,
                            ),
                            const SizedBox(width: 8),
                            _buildModalStatChip(
                              Icons.inventory_2_outlined,
                              prod.unit,
                              AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            _buildModalStatChip(
                              Icons.storefront_rounded,
                              prod.category,
                              AppColors.secondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // About Section
                        const Text(
                          'Product Description',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          prod.description,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Regenerative Agriculture Quality Assurance
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.eco_rounded, color: AppColors.primary, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    '100% Single-Origin Davao Organic Terroir',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Crafted on-site at Gran Verde Agroforest without synthetic chemical additives or artificial flavorings. Sun-cured on natural bamboo racks and stone-ground to retain natural antioxidants.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: AppColors.primaryDark.withValues(alpha: 0.9),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Specs checklist
                        const Text(
                          'Farm Guarantee & Specs',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildProductSpecItem('Zero chemical preservatives or artificial sweeteners'),
                        _buildProductSpecItem('Harvested from regenerative shaded cacao canopy'),
                        _buildProductSpecItem('Biodegradable zero-waste farm packaging'),
                        _buildProductSpecItem('Supports fair-trade local Davao cacao farming families'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky Bottom Action Bar ─────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.8))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Item Price',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        _formatPrice(prod.price),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(modalCtx);
                        final exp = Experience(
                          id: prod.id,
                          title: prod.name,
                          subtitle: prod.unit,
                          description: prod.description,
                          price: prod.price,
                          duration: 'Farm Store Product',
                          category: 'Artisan Cacao Store',
                          rating: prod.rating,
                          reviewCount: 38,
                          imageEmoji: prod.emoji,
                          icon: Icons.storefront_rounded,
                          featureVector: const [0.5, 0.5, 0.5, 0.5],
                          gradientColors: prod.gradientColors,
                          inclusions: const [
                            '100% Single-Origin Pure Davao Cacao',
                            'Eco-friendly biodegradable packaging',
                            'Direct farm-fresh batch guarantee',
                          ],
                          availableDates: const ['Immediate Farm Fulfillment / Dispatch'],
                          availableAddOns: const [],
                          isCoreOffering: false,
                          imageUrl: prod.imageUrl,
                        );
                        QuickBookingModal.show(rootContext, exp);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.shopping_bag_rounded, size: 18),
                      label: const Text(
                        'Book / Order This Product',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSpecItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color == AppColors.accent ? AppColors.textPrimary : color,
            ),
          ),
        ],
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

          // Scrollable Landing Page Content (Centered with max width on PC)
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero Showcase Section
                    _buildHeroBanner(context),
                    const SizedBox(height: 16),

                    // 1.5 Interactive Farm Map Card (Between Hero & Smart Concierge)
                    _buildFarmMapPreviewCard(context),
                    const SizedBox(height: 16),

                    // 2. AI Smart Concierge Teaser Card (Overflow-proof)
                    _buildConciergeFeatureCard(context),
                    const SizedBox(height: 24),

                    // 3. Offerings Section (Action buttons + Inline Grid/Carousel)
                    _buildOfferingsSection(context),
                    const SizedBox(height: 28),

                    // 4. Featured Promotional Advertisement & Video Showcase
                    _buildAdvertisementSection(context),
                    const SizedBox(height: 28),

                    // 5. Visitor Testimonials & Social Proof
                    _buildTestimonialsSection(context),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ChatBot.show(context),
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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

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
            padding: EdgeInsets.all(isDesktop ? 32 : 22),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Column: Text & Buttons
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on_rounded, color: AppColors.accent, size: 14),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      'Davao del Norte • Regenerative Cacao Agroforest',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Immerse in Single-Origin\nCacao Agri-Tourism',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Discover heritage cacao farming, craft authentic tree-to-bar chocolate, and explore sustainable agroforestry nestled in the lush Davao valleys.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13.5,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Wrap(
                              spacing: 12,
                              runSpacing: 10,
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
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                                  label: const Text(
                                    'Smart Concierge AI',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _scrollToOfferings,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.explore_outlined, size: 18),
                                  label: const Text(
                                    'Browse Experiences',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 28),

                      // Right Column: Farm Highlights Glassmorphism Card
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildHeroPill(Icons.verified_rounded, 'RA 10816 Accredited Agri-Tourism', AppColors.accent),
                              const SizedBox(height: 12),
                              _buildHeroPill(Icons.eco_rounded, '100% Tree-to-Bar Single Origin', Colors.greenAccent),
                              const SizedBox(height: 12),
                              _buildHeroPill(Icons.star_rounded, '4.9/5 Rating • 350+ Global Visitors', Colors.amberAccent),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
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
                            onPressed: _scrollToOfferings,
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

  Widget _buildHeroPill(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFarmMapPreviewCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.09),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => FarmMapViewerScreen.show(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Image Window Preview with Hero
              Stack(
                children: [
                  SizedBox(
                    height: 145,
                    width: double.infinity,
                    child: Hero(
                      tag: 'gran_verde_farm_map_hero',
                      child: Image.asset(
                        'assets/images/farm_map.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFE8F5E9),
                            child: const Center(
                              child: Icon(Icons.map_rounded, size: 40, color: AppColors.primary),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Gradient Overlay for readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Top Left Badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B5E20).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map_rounded, color: AppColors.accent, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Agroforest Map & Layout',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom Tap Prompt on Image
                  Positioned(
                    bottom: 10,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Palm Oasis • Cacao Groves • Gardens • Trails',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.zoom_in_rounded, size: 13, color: AppColors.primaryDark),
                              SizedBox(width: 3),
                              Text(
                                'Explore Map',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Footer text bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app_rounded, color: AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Tap to inspect farm zones, cacao trail pathways, and facilities',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConciergeFeatureCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, Color(0xFFFFB300)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.psychology_rounded, color: AppColors.primaryDark, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Smart Agri-Tourism AI',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Cosine Matching',
                        style: TextStyle(
                          fontSize: 9,
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
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SmartConciergeScreen()),
              );
            },
            icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(10),
              minimumSize: const Size(40, 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferingsSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Our Offerings',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: isDesktop ? 22 : 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isDesktop
                    ? 'Curated cacao farm experiences and handcrafted single-origin cacao products'
                    : 'Select a category to browse in our interactive card carousel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: isDesktop ? 13 : 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Category Action Buttons (Constrained width on desktop)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Row(
              children: [
                Expanded(
                  child: _buildCategoryActionButton(
                    index: 0,
                    icon: Icons.eco_rounded,
                    label: 'Cacao Tours & Packages',
                    count: '${ExperienceData.all.length}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCategoryActionButton(
                    index: 1,
                    icon: Icons.storefront_rounded,
                    label: 'Artisan Cacao Store',
                    count: '${farmProducts.length}',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Adaptive Card Showcase: Multi-Column Grid on Desktop/Tablet, Carousel on Mobile
        _buildInlineCardCarousel(context),
      ],
    );
  }

  Widget _buildCategoryActionButton({
    required int index,
    required IconData icon,
    required String label,
    required String count,
  }) {
    final isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        if (_selectedCategoryIndex != index) {
          setState(() {
            _selectedCategoryIndex = index;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineCardCarousel(BuildContext context) {
    final isTours = _selectedCategoryIndex == 0;
    final int itemCount = isTours ? ExperienceData.all.length : farmProducts.length;
    final PageController controller = isTours ? _toursCarouselController : _storeCarouselController;
    final int activeIndex = isTours ? _toursCardIndex : _storeCardIndex;
    final width = MediaQuery.of(context).size.width;

    // Desktop & Tablet Grid Layout (width >= 768)
    if (width >= 768) {
      final int crossAxisCount = width >= 1050 ? 3 : 2;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 320,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return isTours
                ? _buildExperienceCard(context, ExperienceData.all[index])
                : _buildStoreCarouselCard(context, farmProducts[index]);
          },
        ),
      );
    }

    // Mobile Carousel Layout
    return Column(
      children: [
        SizedBox(
          height: 290,
          child: PageView.builder(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            itemCount: itemCount,
            onPageChanged: (i) {
              setState(() {
                if (isTours) {
                  _toursCardIndex = i;
                } else {
                  _storeCardIndex = i;
                }
              });
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  double page = activeIndex.toDouble();
                  if (controller.hasClients &&
                      controller.positions.length == 1 &&
                      controller.position.haveDimensions) {
                    page = controller.page ?? page;
                  }
                  final double value = page - index;

                  final scale = (1.0 - (value.abs() * 0.06)).clamp(0.92, 1.0);
                  final opacity = (1.0 - (value.abs() * 0.25)).clamp(0.75, 1.0);
                  final translateY = (value.abs() * 6).clamp(0.0, 14.0);

                  return Transform.translate(
                    offset: Offset(0, translateY),
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                  child: isTours
                      ? _buildExperienceCard(context, ExperienceData.all[index])
                      : _buildStoreCarouselCard(context, farmProducts[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Centered Carousel Dot Indicators
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(itemCount, (i) {
              final active = i == activeIndex;
              return GestureDetector(
                onTap: () {
                  if (controller.hasClients) {
                    controller.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreCarouselCard(BuildContext context, FarmProduct prod) {
    return GestureDetector(
      onTap: () => _handleViewProductDetails(context, prod),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6), width: 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Header with Scrim & Badges
            SizedBox(
              height: 130,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (prod.imageUrl != null && prod.imageUrl!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: prod.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: prod.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(prod.emoji, style: const TextStyle(fontSize: 36)),
                        ),
                      ),
                      errorWidget: (ctx, url, err) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: prod.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(prod.emoji, style: const TextStyle(fontSize: 36)),
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: prod.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(prod.emoji, style: const TextStyle(fontSize: 36)),
                      ),
                    ),

                  // Scrim
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),

                  // Badge top-left
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        prod.badge,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),

                  // Price bottom-right
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 0.8),
                      ),
                      child: Text(
                        _formatPrice(prod.price),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prod.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    prod.unit,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    prod.description,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.accent, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '${prod.rating}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => _handleViewProductDetails(context, prod),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.info_outline_rounded, size: 13),
                        label: const Text(
                          'View Details',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
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
      ),
    );
  }

  Widget _buildExperienceCard(BuildContext context, Experience exp) {
    return GestureDetector(
      onTap: () => _handleViewExperienceDetails(context, exp),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6), width: 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Photo Header with Scrim & Badges ───────────────────
            SizedBox(
              height: 130,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (exp.imageUrl != null && exp.imageUrl!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: exp.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: exp.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(exp.imageEmoji, style: const TextStyle(fontSize: 36)),
                        ),
                      ),
                      errorWidget: (ctx, url, err) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: exp.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(exp.imageEmoji, style: const TextStyle(fontSize: 36)),
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: exp.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(exp.imageEmoji, style: const TextStyle(fontSize: 36)),
                      ),
                    ),

                  // Gradient Scrim
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),

                  // Top-Left Badge: Signature Tour or Category
                  Positioned(
                    top: 10,
                    left: 10,
                    child: exp.isCoreOffering
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, size: 12, color: AppColors.primaryDark),
                                SizedBox(width: 3),
                                Text(
                                  'Signature Tour',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              exp.category,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),

                  // Top-Right Duration Pill
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time_rounded, size: 11, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            exp.duration,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom-Right Price Tag
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _formatPrice(exp.price),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            ' / person',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 8.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Card Body ───────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exp.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    exp.subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    exp.description,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Action Bar: Rating on left + View Details on right
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.accent, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '${exp.rating}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            ' (${exp.reviewCount})',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => _handleViewExperienceDetails(context, exp),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.info_outline_rounded, size: 13),
                        label: const Text(
                          'View Details',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
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
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.rate_review_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Visitor Experiences & Feedback',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildReviewCard(
                    'Maria Santos',
                    'Manila, PH',
                    '5.0',
                    'The tree-to-bar workshop was the highlight of our Davao trip. Tasting warm fermented tablea straight from the stone mill is unforgettable!',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildReviewCard(
                    'Dr. Carlos Gomez',
                    'UP Los Baños',
                    '5.0',
                    'Superb regenerative canopy management. Outstanding model of sustainable agri-tourism that honors Mindanao biodiversity.',
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildReviewItem(
                  'Maria Santos',
                  'Manila, PH',
                  '5.0',
                  'The tree-to-bar workshop was the highlight of our Davao trip. Tasting warm fermented tablea straight from the stone mill is unforgettable!',
                ),
                const Divider(height: 20),
                _buildReviewItem(
                  'Dr. Carlos Gomez',
                  'UP Los Baños',
                  '5.0',
                  'Superb regenerative canopy management. Outstanding model of sustainable agri-tourism that honors Mindanao biodiversity.',
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String author, String origin, String rating, String comment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: _buildReviewItem(author, origin, rating, comment),
    );
  }

  Widget _buildReviewItem(String author, String origin, String rating, String comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    origin,
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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, size: 11, color: AppColors.primaryDark),
                  const SizedBox(width: 2),
                  Text(
                    rating,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '"$comment"',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildAdvertisementSection(BuildContext context) {
    const promoTitle = 'Davao Harvest Season & Tree-to-Bar Immersion';
    const promoSubtitle = 'Limited Slot Promotional Package with Free Tablea Tasting';
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: isDesktop
          ? Row(
              children: [
                // Visual Poster
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF1B5E20), Color(0xFF3E2723)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Watch Harvest Promo Reel',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '🔥 Featured Campaign',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Details
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          promoTitle,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          promoSubtitle,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InquiryScreen(
                                  adTitle: 'Special Harvest Tour Promo & Video Showcase',
                                  initialInterest: 'Tree-to-Bar Workshop',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.send_rounded, size: 16),
                          label: const Text(
                            'Inquire About This Promo',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Visual Poster Header
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF1B5E20), Color(0xFF3E2723)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Watch Harvest Promo Reel',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '🔥 Featured Campaign',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        promoTitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        promoSubtitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InquiryScreen(
                                  adTitle: 'Special Harvest Tour Promo & Video Showcase',
                                  initialInterest: 'Tree-to-Bar Workshop',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.send_rounded, size: 16),
                          label: const Text(
                            'Inquire About This Promo',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
