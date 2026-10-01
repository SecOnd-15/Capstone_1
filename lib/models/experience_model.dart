import 'package:flutter/material.dart';

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
  final IconData icon;
  final List<Color> gradientColors;
  final String imageEmoji;

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
    required this.icon,
    required this.gradientColors,
    required this.imageEmoji,
  });
}

class ExperienceData {
  ExperienceData._();

  static final List<Experience> all = [
    const Experience(
      id: 'exp_001',
      title: 'Cacao Plantation Tour',
      subtitle: 'Walk the living cacao forest',
      description:
          'Immerse yourself in the lush cacao plantation where ancient trees thrive in harmony with nature. Learn about regenerative farming practices and the journey from cacao pod to chocolate bar. Your expert guide will share stories of the land, introduce you to the diverse flora and fauna, and let you taste fresh cacao straight from the tree.',
      category: 'Tours',
      price: 850.0,
      duration: '3 hours',
      rating: 4.9,
      reviewCount: 128,
      icon: Icons.forest_rounded,
      imageEmoji: '🌿',
      gradientColors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
      inclusions: [
        'Expert guide',
        'Cacao tasting',
        'Farm-fresh snacks',
        'Souvenir cacao pod',
      ],
      availableDates: [
        'Dec 20',
        'Dec 21',
        'Dec 22',
        'Dec 23',
        'Dec 24',
        'Dec 27',
        'Dec 28',
      ],
    ),
    const Experience(
      id: 'exp_002',
      title: 'Chocolate Making Workshop',
      subtitle: 'Bean to bar experience',
      description:
          'Roll up your sleeves and dive into the art of chocolate making. From roasting cacao beans to tempering chocolate, you\'ll create your own artisan chocolate bar to take home. Our chocolatier will guide you through each step, teaching you the science and craft behind great chocolate. Perfect for food enthusiasts and curious minds!',
      category: 'Workshops',
      price: 1200.0,
      duration: '4 hours',
      rating: 4.8,
      reviewCount: 95,
      icon: Icons.emoji_food_beverage_rounded,
      imageEmoji: '🍫',
      gradientColors: [Color(0xFF5D4037), Color(0xFF3E2723)],
      inclusions: [
        'All materials',
        'Recipe booklet',
        'Your chocolate bar to take home',
        'Refreshments',
      ],
      availableDates: [
        'Dec 20',
        'Dec 22',
        'Dec 24',
        'Dec 27',
        'Dec 29',
      ],
    ),
    const Experience(
      id: 'exp_003',
      title: 'Farm-to-Table Dinner',
      subtitle: 'Sunset dinner under the stars',
      description:
          'Savor a five-course gourmet dinner prepared with ingredients harvested directly from our farm. As the sun sets over the cacao forest, enjoy expertly paired wines and dishes that celebrate the flavors of Batangas. Meet our chef, hear the story behind each course, and dine under a canopy of stars.',
      category: 'Dining',
      price: 1500.0,
      duration: '2.5 hours',
      rating: 4.9,
      reviewCount: 73,
      icon: Icons.restaurant_rounded,
      imageEmoji: '🌅',
      gradientColors: [Color(0xFFE65100), Color(0xFFBF360C)],
      inclusions: [
        '5-course meal',
        'Wine pairing',
        'Farm tour',
        'Chef meet & greet',
      ],
      availableDates: [
        'Dec 21',
        'Dec 23',
        'Dec 25',
        'Dec 28',
        'Dec 30',
      ],
    ),
    const Experience(
      id: 'exp_004',
      title: 'Overnight Eco-Lodge Stay',
      subtitle: 'Sleep among the cacao trees',
      description:
          'Escape to nature with an overnight stay in our private eco-lodge nestled in the heart of the cacao forest. Wake up to birdsong, enjoy a farm-fresh breakfast, and experience the magic of the forest at dawn. Your stay includes an evening bonfire with storytelling and a guided morning walk through the plantation.',
      category: 'Accommodations',
      price: 3500.0,
      duration: '1 night',
      rating: 4.7,
      reviewCount: 42,
      icon: Icons.cabin_rounded,
      imageEmoji: '🌙',
      gradientColors: [Color(0xFF1A237E), Color(0xFF283593)],
      inclusions: [
        'Private eco-cabin',
        'Breakfast',
        'Evening bonfire',
        'Morning farm walk',
      ],
      availableDates: [
        'Dec 20',
        'Dec 21',
        'Dec 22',
        'Dec 23',
        'Dec 24',
        'Dec 25',
        'Dec 26',
        'Dec 27',
        'Dec 28',
        'Dec 29',
        'Dec 30',
      ],
    ),
    const Experience(
      id: 'exp_005',
      title: 'Coffee & Cacao Tasting',
      subtitle: 'Sip and savor the highlands',
      description:
          'A sensory journey through the flavors of Batangas. Sample six varieties of cacao and three coffee origins while learning to identify tasting notes and appreciate the nuances of each. Take home a curated sampler to share with friends and family. Perfect for beginners and connoisseurs alike.',
      category: 'Dining',
      price: 650.0,
      duration: '1.5 hours',
      rating: 4.6,
      reviewCount: 156,
      icon: Icons.coffee_rounded,
      imageEmoji: '☕',
      gradientColors: [Color(0xFF4E342E), Color(0xFF3E2723)],
      inclusions: [
        '6 cacao varieties',
        '3 coffee origins',
        'Flavor notes guide',
        'Take-home sampler',
      ],
      availableDates: [
        'Dec 20',
        'Dec 21',
        'Dec 22',
        'Dec 23',
        'Dec 24',
        'Dec 27',
        'Dec 28',
        'Dec 29',
        'Dec 30',
      ],
    ),
    const Experience(
      id: 'exp_006',
      title: 'Sustainable Farming Workshop',
      subtitle: 'Learn regenerative practices',
      description:
          'Discover the principles of regenerative agriculture and how we restore soil health, increase biodiversity, and grow food sustainably. Get your hands dirty with practical planting and composting demonstrations. Leave with a seed kit and the knowledge to start your own regenerative garden at home.',
      category: 'Workshops',
      price: 950.0,
      duration: '5 hours',
      rating: 4.8,
      reviewCount: 61,
      icon: Icons.agriculture_rounded,
      imageEmoji: '🌱',
      gradientColors: [Color(0xFF33691E), Color(0xFF1B5E20)],
      inclusions: [
        'Hands-on planting',
        'Composting demo',
        'Seed kit to take home',
        'Lunch',
      ],
      availableDates: [
        'Dec 21',
        'Dec 23',
        'Dec 27',
        'Dec 28',
        'Dec 30',
      ],
    ),
  ];
}
