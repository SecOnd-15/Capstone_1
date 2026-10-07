import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/experience_model.dart';

class QuotationsPricingScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const QuotationsPricingScreen({super.key, this.scaffoldKey});

  @override
  State<QuotationsPricingScreen> createState() => _QuotationsPricingScreenState();
}

class _QuotationsPricingScreenState extends State<QuotationsPricingScreen> {
  // In-memory editable package rates (Paper Section 2.1.5.2.4)
  final Map<String, double> _packageRates = {
    'exp_kakaw_lakaw': 750.0,
    'exp_bahandi': 1450.0,
    'exp_customized': 1200.0,
  };

  final Map<String, double> _addOnRates = {
    'Artisan Tablea Gift Box': 250.0,
    'Organic Farm Lunch Upgrade': 350.0,
    'Cacao Tree Planting & Plaque': 500.0,
    'Keepsake Photo & Guide': 200.0,
  };

  final double _serviceFeeRate = 10.0; // 10%

  String _formatPrice(double price) {
    return '₱${price.toStringAsFixed(0)}';
  }

  void _editPriceDialog(String title, double currentPrice, Function(double) onSaved) {
    final controller = TextEditingController(text: currentPrice.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Adjust Rate for $title', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dynamic quotation formulas will update automatically for all new visitor inquiries.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price per Person / Unit (PHP ₱)',
                prefixText: '₱ ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(controller.text.trim());
              if (newPrice != null && newPrice > 0) {
                onSaved(newPrice);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Updated $title rate to ${_formatPrice(newPrice)}'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save Rate', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final core = ExperienceData.all.where((e) => e.isCoreOffering).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
        ),
        title: const Text(
          'Quotation & Pricing Rules',
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
            // Banner description
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF4E342E), Color(0xFF2E7D32)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tune_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Manage official package base rates, optional add-ons, and dynamic quotation business rules (Section 2.1.5.2.4).',
                      style: TextStyle(fontSize: 11, color: Colors.white, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 1: Core Packages
            _buildSectionHeader('1. Core Agri-Tourism Packages'),
            const SizedBox(height: 8),
            ...core.map((exp) {
              final price = _packageRates[exp.id] ?? exp.price;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
                  ],
                ),
                child: Row(
                  children: [
                    Text(exp.imageEmoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exp.title,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${exp.duration} • ${_formatPrice(price)} / person',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                      onPressed: () {
                        _editPriceDialog(exp.title, price, (newVal) {
                          setState(() => _packageRates[exp.id] = newVal);
                        });
                      },
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Section 2: Optional Add-on Packages
            _buildSectionHeader('2. Optional Add-on Inclusions'),
            const SizedBox(height: 8),
            ..._addOnRates.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Text(
                          _formatPrice(entry.value),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                          onPressed: () {
                            _editPriceDialog(entry.key, entry.value, (newVal) {
                              setState(() => _addOnRates[entry.key] = newVal);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Section 3: Platform Rule Settings
            _buildSectionHeader('3. Quotation Rules & Fees'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Platform / Operations Fee', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      Text('Added to quotation subtotal automatically', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                  Text(
                    '${_serviceFeeRate.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
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
}
