import 'package:flutter/material.dart';

class AddOnOption {
  final String id;
  final String name;
  final String description;
  final double price;

  const AddOnOption({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}

class Experience {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final double price;
  final String duration;
  final double rating;
  final int reviewCount;
  final List<String> inclusions;
  final List<String> availableDates;
  final List<AddOnOption> availableAddOns;
  final IconData icon;
  final List<Color> gradientColors;
  final String imageEmoji;
  final bool isCoreOffering; // Kakaw Lakaw, Bahandi sa Uma, Customized Options

  // 4 Feature vector dimensions for Content-Based Filtering with Cosine Similarity (Paper Section 2.2.2.1)
  // Dimensions: [Experience Type (0..1), Group Fit (0..1), Educational/Hands-on Depth (0..1), Budget/Value (0..1)]
  final List<double> featureVector;

  const Experience({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.price,
    required this.duration,
    required this.rating,
    required this.reviewCount,
    required this.inclusions,
    required this.availableDates,
    required this.availableAddOns,
    required this.icon,
    required this.gradientColors,
    required this.imageEmoji,
    this.isCoreOffering = false,
    required this.featureVector,
  });
}

class ExperienceData {
  ExperienceData._();

  static const List<AddOnOption> defaultAddOns = [
    AddOnOption(
      id: 'addon_tablea_cup',
      name: 'Fresh Tablea Tasting Cup',
      description: 'Single serving warm handcrafted artisan tablea brewed with native spices',
      price: 150.0,
    ),
    AddOnOption(
      id: 'addon_01',
      name: 'Artisan Tablea Box',
      description: 'Handcrafted pure cacao tablea gift box (250g)',
      price: 250.0,
    ),
    AddOnOption(
      id: 'addon_02',
      name: 'Farm-to-Table Lunch Upgrade',
      description: 'Organic 3-course heritage meal with farm-fresh ingredients',
      price: 350.0,
    ),
    AddOnOption(
      id: 'addon_03',
      name: 'Tree Planting & Named Plaque',
      description: 'Plant your own cacao tree with custom engraved eco-plaque',
      price: 500.0,
    ),
    AddOnOption(
      id: 'addon_04',
      name: 'Souvenir Photo & Guide Booklet',
      description: 'Printed keepsake photo with regenerative cacao guidebook',
      price: 200.0,
    ),
  ];

  static final List<Experience> all = [
    // ── CORE ACM PAPER & SCREENSHOT OFFERINGS ─────────────────────────
    const Experience(
      id: 'exp_morning_brew',
      title: 'Morning Brew & Birding Tour',
      subtitle: 'Dawn Cacao Forest & Bird Watching Tour',
      description:
          'Experience dawn amidst our cacao agroforest. Spot endemic Mindanao bird species, enjoy a fresh morning brew of farm-roasted cacao, and take a tranquil walk under the shade canopy.',
      category: 'Tours',
      price: 150.0,
      duration: '1.5 hours',
      rating: 4.9,
      reviewCount: 98,
      icon: Icons.wb_sunny_rounded,
      imageEmoji: '🦜',
      gradientColors: [Color(0xFF1B5E20), Color(0xFF004D40)],
      isCoreOffering: true,
      featureVector: [0.9, 0.8, 0.7, 0.95],
      availableAddOns: defaultAddOns,
      inclusions: [
        'Guided sunrise birdwatching agroforestry walk',
        'Binocular rental & Mindanao bird identification guide',
        'Morning cup of warm stone-ground native tablea',
        'Freshly baked cassava heritage snack',
      ],
      availableDates: [
        'Oct 10, 2026',
        'Oct 11, 2026',
        'Oct 12, 2026',
        'Oct 15, 2026',
        'Oct 18, 2026',
        'Oct 20, 2026',
      ],
    ),
    const Experience(
      id: 'exp_kakaw_lakaw',
      title: 'Kakaw Lakaw',
      subtitle: 'Living Cacao Forest Walk & Heritage Tour',
      description:
          'Walk the living cacao forest under the canopy of ancient shade trees. Learn regenerative agriculture methods, discover the life cycle of the cacao tree, crack open fresh cacao pods to taste the sweet pulp, and enjoy farm-fresh native refreshments at our open-air pavilion.',
      category: 'Tours',
      price: 750.0,
      duration: '2.5 hours',
      rating: 4.9,
      reviewCount: 142,
      icon: Icons.forest_rounded,
      imageEmoji: '🌿',
      gradientColors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
      isCoreOffering: true,
      featureVector: [0.9, 0.7, 0.6, 0.8], // [Nature Tour, Solo/Small/Group, Moderate Depth, Accessible Budget]
      availableAddOns: defaultAddOns,
      inclusions: [
        'Guided regenerative cacao agroforest walk',
        'Fresh cacao pod opening & pulp tasting',
        'Regenerative soil & biodiversity talk',
        'Farm-fresh herbal snack & refreshment',
        'Souvenir raw cacao bean sample',
      ],
      availableDates: [
        'Oct 10, 2026',
        'Oct 12, 2026',
        'Oct 15, 2026',
        'Oct 18, 2026',
        'Oct 20, 2026',
        'Oct 25, 2026',
      ],
    ),
    const Experience(
      id: 'exp_bahandi',
      title: 'Bahandi sa Uma',
      subtitle: 'Full Farm Heritage & Chocolate Making',
      description:
          'Gran Verde\'s signature immersion! Experience the complete journey from bean to bar. Harvest pods, roast fermented beans, grind your own artisan tablea, and indulge in a 3-course farm-to-table lunch prepared with heritage crops directly from our agroforest.',
      category: 'Workshops',
      price: 1450.0,
      duration: '4.5 hours',
      rating: 4.9,
      reviewCount: 118,
      icon: Icons.emoji_food_beverage_rounded,
      imageEmoji: '🍫',
      gradientColors: [Color(0xFF4E342E), Color(0xFF3E2723)],
      isCoreOffering: true,
      featureVector: [0.6, 0.8, 0.95, 0.5], // [Workshop/Gastronomy, Families/Groups, Deep Hands-on, Premium Value]
      availableAddOns: defaultAddOns,
      inclusions: [
        'Full guided plantation & heritage walk',
        'Hands-on roasting, shelling & tablea grinding',
        'Customized chocolate bar to take home',
        '3-course organic farm-to-table lunch',
        'Gran Verde recipe booklet & apron keepsake',
      ],
      availableDates: [
        'Oct 11, 2026',
        'Oct 14, 2026',
        'Oct 18, 2026',
        'Oct 22, 2026',
        'Oct 28, 2026',
      ],
    ),
    const Experience(
      id: 'exp_customized',
      title: 'Customized Options',
      subtitle: 'Bespoke Agri-Tourism & Group Experience',
      description:
          'Tailor your visit precisely to your group’s goals, budget, and schedule. Perfect for academic field study, corporate regenerative retreats, private family celebrations, and agricultural research delegations with selectable workshop modules.',
      category: 'Custom',
      price: 1200.0,
      duration: 'Flexible (3-6 hrs)',
      rating: 4.8,
      reviewCount: 64,
      icon: Icons.tune_rounded,
      imageEmoji: '✨',
      gradientColors: [Color(0xFF00695C), Color(0xFF004D40)],
      isCoreOffering: true,
      featureVector: [0.7, 0.95, 0.85, 0.6], // [Custom Itinerary, Large Groups/Retreats, Tailored Depth, Flexible]
      availableAddOns: defaultAddOns,
      inclusions: [
        'Personalized itinerary & dedicated coordinator',
        'Private agroforest zone allocation',
        'Selectable workshop modules (Planting / Roasting)',
        'Customized dining & dietary menu setup',
        'Certificate of participation (for schools/orgs)',
      ],
      availableDates: [
        'Oct 10, 2026',
        'Oct 13, 2026',
        'Oct 17, 2026',
        'Oct 20, 2026',
        'Oct 24, 2026',
        'Oct 27, 2026',
      ],
    ),

    // ── ADDITIONAL SPECIALIZED PACKAGES ──────────────────────────────
    const Experience(
      id: 'exp_eco_lodge',
      title: 'Overnight Eco-Lodge Stay',
      subtitle: 'Sleep among the cacao forest canopy',
      description:
          'Escape urban noise with an overnight stay in our solar-powered bamboo eco-cabin. Wake up to highland birdsong, night sky stargazing, evening campfire storytelling, and dawn cacao picking.',
      category: 'Accommodations',
      price: 3500.0,
      duration: '1 night',
      rating: 4.7,
      reviewCount: 42,
      icon: Icons.hotel_rounded,
      imageEmoji: '🌙',
      gradientColors: [Color(0xFF1A237E), Color(0xFF283593)],
      featureVector: [0.4, 0.6, 0.5, 0.2],
      availableAddOns: defaultAddOns,
      inclusions: [
        'Private solar eco-cabin accommodation',
        'Farm-fresh organic breakfast & dinner',
        'Evening bonfire with hot cacao tablea',
        'Early dawn birdwatching farm walk',
      ],
      availableDates: [
        'Oct 12, 2026',
        'Oct 16, 2026',
        'Oct 19, 2026',
        'Oct 23, 2026',
        'Oct 26, 2026',
      ],
    ),
    const Experience(
      id: 'exp_tasting',
      title: 'Coffee & Cacao Tasting Flight',
      subtitle: 'Highland terroir & single-origin flavors',
      description:
          'An intimate sensory masterclass comparing 5 micro-lot cacao origins and 3 shade-grown Batangas coffee beans with flavor wheel tasting notes guided by our farm sommelier.',
      category: 'Dining',
      price: 650.0,
      duration: '1.5 hours',
      rating: 4.6,
      reviewCount: 156,
      icon: Icons.coffee_rounded,
      imageEmoji: '☕',
      gradientColors: [Color(0xFF6D4C41), Color(0xFF3E2723)],
      featureVector: [0.5, 0.5, 0.7, 0.9],
      availableAddOns: defaultAddOns,
      inclusions: [
        '5 single-estate cacao tasting samples',
        '3 pour-over shade-grown coffee flights',
        'Interactive flavor wheel guide sheet',
        'Take-home mini sampler bag',
      ],
      availableDates: [
        'Oct 10, 2026',
        'Oct 11, 2026',
        'Oct 14, 2026',
        'Oct 18, 2026',
        'Oct 21, 2026',
      ],
    ),
  ];
}
