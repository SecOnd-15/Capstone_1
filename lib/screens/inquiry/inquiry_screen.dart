import 'package:flutter/material.dart';
import '../../models/inquiry_store.dart';
import '../../models/user_session.dart';

class InquiryScreen extends StatefulWidget {
  final String? adTitle;
  final String? initialInterest;

  const InquiryScreen({
    super.key,
    this.adTitle,
    this.initialInterest,
  });

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _originController;
  late TextEditingController _messageController;

  String _selectedInterest = 'Tree-to-Bar Workshop';
  String _selectedPurpose = 'Agri-tourism & Leisure';
  DateTime? _selectedDate;
  int _guestCount = 2;
  bool _isSubmitting = false;

  final List<String> _interestOptions = [
    'Tree-to-Bar Workshop',
    'Morning Brew & Birding',
    'Farm Walk & Canopy Tour',
    'Bulk Artisan Tablea Order',
    'Educational / School Tour',
    'Agroforestry Research Visit',
    'Custom Group Event',
  ];

  final List<String> _purposeOptions = [
    'Agri-tourism & Leisure',
    'Educational Field Trip',
    'Commercial / Bulk Buying',
    'Scientific / Agroforestry Research',
    'Corporate Team Building',
    'Other / General Inquiry',
  ];

  @override
  void initState() {
    super.initState();
    final session = UserSession.instance;
    _nameController = TextEditingController(text: session.fullName);
    _emailController = TextEditingController(text: session.email);
    _phoneController = TextEditingController(text: session.contactNumber);
    _originController = TextEditingController(text: 'Davao City');
    _messageController = TextEditingController();

    if (widget.initialInterest != null &&
        _interestOptions.contains(widget.initialInterest)) {
      _selectedInterest = widget.initialInterest!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _originController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 3)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 180)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F4E31),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1F2937),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final refCode = 'INQ-2026-${(100 + InquiryStore.instance.inquiries.length + 1)}';
    final adSource = widget.adTitle ?? 'Homepage Promotional Advertisement';

    final entry = InquiryEntry(
      id: 'inq_${DateTime.now().millisecondsSinceEpoch}',
      inquiryRef: refCode,
      visitorName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      placeOfOrigin: _originController.text.trim(),
      interestTopic: _selectedInterest,
      preferredDate: _selectedDate != null ? _formatDate(_selectedDate!) : 'Flexible / TBD',
      estimatedGuests: _guestCount,
      message: _messageController.text.trim(),
      sourceAdvertisement: adSource,
      status: InquiryStatusType.newInquiry,
      createdAt: DateTime.now(),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      InquiryStore.instance.addInquiry(entry);
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showSuccessDialog(refCode);
    });
  }

  void _showSuccessDialog(String refCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF15803D), size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Inquiry Submitted!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F4E31),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thank you for your interest in Gran Verde Cacao Farm! Your inquiry has been routed to our Farm Operations Staff.',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13, height: 1.45),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inquiry Tracking Reference:',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    refCode,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F4E31),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '🌿 Farm Staff Razel Ponce and team will review your requirements and reach out via email or phone within 1-2 business hours.',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: Color(0xFF4B5563)),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Return to Homepage
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F4E31),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Back to Homepage', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adSource = widget.adTitle ?? 'Harvest Experience & Video Showcase';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F4E31),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          tooltip: 'Back to Homepage',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Visitor Inquiry Form',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home_rounded, color: Colors.white70, size: 18),
            label: const Text(
              'Home',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Advertisement Context Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF004D40), Color(0xFF1B5E20)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'FROM ADVERTISEMENT',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            adSource,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Complete the inquiry below to receive custom pricing, package schedule & personalized assistance.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.5,
                              color: Colors.white70,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Visitor Information Section
              _buildCard(
                title: '👤 Visitor Contact Details',
                subtitle: 'Captured for inquiry tracking and booking follow-up (§2.2.1)',
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name *',
                    hint: 'e.g. Juan Dela Cruz',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _emailController,
                          label: 'Email Address *',
                          hint: 'e.g. name@email.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _phoneController,
                          label: 'Phone / Mobile *',
                          hint: '+63 9XX XXX XXXX',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.length < 7) ? 'Valid phone required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _originController,
                    label: 'Place of Origin / City',
                    hint: 'e.g. Davao City, Tagum, Manila',
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 3. Inquiry Topic & Purpose
              _buildCard(
                title: '🌿 Nature of Inquiry & Interest',
                subtitle: 'Select what you would like to explore or inquire about',
                children: [
                  const Text(
                    'Topic of Interest *',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _interestOptions.map((opt) {
                      final isSelected = _selectedInterest == opt;
                      return ChoiceChip(
                        label: Text(
                          opt,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF374151),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0F4E31),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF0F4E31) : const Color(0xFFD1D5DB),
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedInterest = opt);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Purpose of Visit',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPurpose,
                        isExpanded: true,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Color(0xFF1F2937),
                        ),
                        items: _purposeOptions.map((p) {
                          return DropdownMenuItem(value: p, child: Text(p));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedPurpose = val);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      // Date Picker Button
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Target Date',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () => _selectDate(context),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFD1D5DB)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF0F4E31)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _selectedDate != null ? _formatDate(_selectedDate!) : 'Select Date (Optional)',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12.5,
                                          color: _selectedDate != null ? const Color(0xFF1F2937) : const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Guests Stepper
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Estimated Guests',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFD1D5DB)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20, color: Color(0xFF0F4E31)),
                                    onPressed: _guestCount > 1 ? () => setState(() => _guestCount--) : null,
                                  ),
                                  Text(
                                    '$_guestCount',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF0F4E31)),
                                    onPressed: () => setState(() => _guestCount++),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 4. Message & Special Inquiries
              _buildCard(
                title: '💬 Inquiry Notes & Special Requests',
                subtitle: 'Let us know if you have specific questions, dietary requests, or shuttle pickup inquiries',
                children: [
                  _buildTextField(
                    controller: _messageController,
                    label: 'Message / Questions',
                    hint: 'e.g. Are there group discounts for 10 people? Can you provide a custom tablea workshop in the afternoon?',
                    icon: Icons.chat_bubble_outline_rounded,
                    maxLines: 4,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 5. Submit Button & Cancel
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded, color: Colors.white),
                  label: Text(
                    _isSubmitting ? 'Submitting Inquiry...' : 'Submit Inquiry & Continue',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4E31),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF6B7280)),
                  label: const Text(
                    'Return to Homepage',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
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
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F4E31),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
            prefixIcon: maxLines == 1 ? Icon(icon, color: const Color(0xFF0F4E31), size: 20) : null,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0F4E31), width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}
