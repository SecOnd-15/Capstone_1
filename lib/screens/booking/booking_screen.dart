import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/theme/app_colors.dart';
import '../../models/experience_model.dart';
import '../../models/booking_model.dart';
import '../../models/user_session.dart';

class BookingScreen extends StatefulWidget {
  final Experience experience;

  const BookingScreen({super.key, required this.experience});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late String _selectedDate;
  int _guestCount = 2;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final _originController = TextEditingController(text: 'Davao City');
  final _specialRequestsController = TextEditingController();

  // Visitor Tracking Fields (Paper Section 1.2 & 2.1.5.1.3)
  String _purposeOfVisit = 'Educational & Leisure';
  String _howLearned = 'Social Media';
  bool _visitedBefore = false;

  // Selected Add-ons (Paper Section 1.2 Dynamic Quotation)
  final Set<String> _selectedAddOnIds = {};

  // Payment Proof Fields (Paper Section 1.2 & 2.1.5.1.8)
  String _paymentMethod = 'GCash';
  final _refNumberController = TextEditingController(text: '902188492019');
  String? _attachedFileName = 'gcash_receipt_screenshot.png';

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.experience.availableDates.first;
    _fullNameController =
        TextEditingController(text: UserSession.instance.fullName);
    _emailController = TextEditingController(text: UserSession.instance.email);
    _phoneController =
        TextEditingController(text: UserSession.instance.contactNumber);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _originController.dispose();
    _specialRequestsController.dispose();
    _refNumberController.dispose();
    super.dispose();
  }

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

  // Price calculations
  double get _baseSubtotal => widget.experience.price * _guestCount;

  double get _addOnsSubtotal {
    double sum = 0.0;
    for (var addon in widget.experience.availableAddOns) {
      if (_selectedAddOnIds.contains(addon.id)) {
        sum += addon.price * _guestCount;
      }
    }
    return sum;
  }

  double get _combinedSubtotal => _baseSubtotal + _addOnsSubtotal;
  double get _serviceFee => _combinedSubtotal * 0.10;
  double get _total => _combinedSubtotal + _serviceFee;

  void _handleConfirmBooking() {
    if (!_formKey.currentState!.validate()) return;

    if (_attachedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please attach your GCash or Bank Transfer receipt image.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final random = Random();
    final refCode = 'GV-2026-${(random.nextInt(900) + 100).toString()}';

    // Get selected addon names
    final selectedNames = widget.experience.availableAddOns
        .where((a) => _selectedAddOnIds.contains(a.id))
        .map((a) => a.name)
        .toList();

    // Create new persistent booking record
    final newBooking = Booking(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      experience: widget.experience,
      date: _selectedDate,
      guests: _guestCount,
      baseSubtotal: _baseSubtotal,
      addOnsTotal: _addOnsSubtotal,
      serviceFee: _serviceFee,
      totalPrice: _total,
      status: BookingStatus.pendingVerification,
      bookingRef: refCode,
      visitorName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      placeOfOrigin: _originController.text.trim(),
      purposeOfVisit: _purposeOfVisit,
      howLearned: _howLearned,
      specialRequests: _specialRequestsController.text.trim().isNotEmpty
          ? _specialRequestsController.text.trim()
          : null,
      selectedAddOnNames: selectedNames,
      paymentMethod: _paymentMethod,
      paymentProofRef: _refNumberController.text.trim(),
      paymentProofFileName: _attachedFileName,
    );

    BookingStore.instance.addBooking(newBooking);

    // Show Confirmation Dialog
    _showBookingConfirmedDialog(newBooking);
  }

  void _showBookingConfirmedDialog(Booking booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 38,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Booking Submitted!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Reference Code: ${booking.bookingRef}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.hourglass_top_rounded, size: 20, color: Colors.orange.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Status: Pending Payment Verification. Farm admin will review your receipt.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.orange.shade900,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildReceiptRow('Experience', booking.experience.title),
              _buildReceiptRow('Date & Schedule', booking.date),
              _buildReceiptRow('Total Visitors', '${booking.guests} Guests'),
              _buildReceiptRow('Amount Paid', _formatPrice(booking.totalPrice)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx); // close dialog
                    Navigator.pop(context); // back to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    UserSession.instance.isLoggedIn
                        ? 'Done • View in My Bookings'
                        : 'Done • Return to Storefront',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (!UserSession.instance.isLoggedIn) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Want to track this reservation? Create or Sign in to your account →',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Quotation & Booking',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Experience summary banner
              _buildExperienceSummary(),
              const SizedBox(height: 20),

              // ── 1. Select Date ─────────────────────────────────────
              _buildSectionTitle('1. Select Visit Schedule'),
              const SizedBox(height: 10),
              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.experience.availableDates.length,
                  itemBuilder: (context, index) {
                    final date = widget.experience.availableDates[index];
                    final isSelected = date == _selectedDate;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDate = date),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── 2. Guest Count ─────────────────────────────────────
              _buildSectionTitle('2. Number of Guests'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Participants',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_guestCount > 1) {
                              setState(() => _guestCount--);
                            }
                          },
                          icon: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.remove, size: 18, color: AppColors.primary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '$_guestCount',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_guestCount < 15) {
                              setState(() => _guestCount++);
                            }
                          },
                          icon: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add, size: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── 3. Dynamic Add-ons (Paper Quotation Module) ──────────
              _buildSectionTitle('3. Optional Add-on Packages (Dynamic Quotation)'),
              const SizedBox(height: 8),
              ...widget.experience.availableAddOns.map((addon) {
                final isSelected = _selectedAddOnIds.contains(addon.id);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey.shade200,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedAddOnIds.add(addon.id);
                          } else {
                            _selectedAddOnIds.remove(addon.id);
                          }
                        });
                      },
                      activeColor: AppColors.primary,
                      title: Text(
                        addon.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${addon.description} (+${_formatPrice(addon.price)}/pax)',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // ── 4. Visitor Tracking Information (Paper Section 2.1.5.1.3)
              _buildSectionTitle('4. Visitor Tracking & Contact Details'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Lead Visitor Name',
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined, size: 20),
                      ),
                      validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Phone',
                        prefixIcon: Icon(Icons.phone_outlined, size: 20),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Phone required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _originController,
                decoration: const InputDecoration(
                  labelText: 'Place of Origin (City / Province)',
                  hintText: 'e.g. Davao City, Manila, Cebu',
                  prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Origin required' : null,
              ),
              const SizedBox(height: 10),

              // Purpose of Visit Dropdown
              DropdownButtonFormField<String>(
                initialValue: _purposeOfVisit,
                decoration: const InputDecoration(
                  labelText: 'Purpose of Visit',
                  prefixIcon: Icon(Icons.explore_outlined, size: 20),
                ),
                items: const [
                  DropdownMenuItem(value: 'Educational & Leisure', child: Text('Educational & Leisure')),
                  DropdownMenuItem(value: 'Family Recreation', child: Text('Family Recreation')),
                  DropdownMenuItem(value: 'Academic Field Study', child: Text('Academic Field Study')),
                  DropdownMenuItem(value: 'Agri-Business & Research', child: Text('Agri-Business & Research')),
                ],
                onChanged: (v) => setState(() => _purposeOfVisit = v ?? _purposeOfVisit),
              ),
              const SizedBox(height: 10),

              // How learned Dropdown
              DropdownButtonFormField<String>(
                initialValue: _howLearned,
                decoration: const InputDecoration(
                  labelText: 'How did you learn about Gran Verde?',
                  prefixIcon: Icon(Icons.campaign_outlined, size: 20),
                ),
                items: const [
                  DropdownMenuItem(value: 'Social Media', child: Text('Social Media (Facebook/Instagram)')),
                  DropdownMenuItem(value: 'Friend / Family Referral', child: Text('Friend / Family Referral')),
                  DropdownMenuItem(value: 'Official Website', child: Text('Official Website')),
                  DropdownMenuItem(value: 'Tourism / Agriculture Expo', child: Text('Tourism / Agriculture Expo')),
                ],
                onChanged: (v) => setState(() => _howLearned = v ?? _howLearned),
              ),
              const SizedBox(height: 10),

              // Visited Before Checkbox
              Material(
                color: Colors.transparent,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  value: _visitedBefore,
                  onChanged: (val) => setState(() => _visitedBefore = val ?? false),
                  activeColor: AppColors.primary,
                  title: const Text(
                    'I have visited Gran Verde Farm before (Returning Visitor)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: _specialRequestsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Special Requests / Dietary Restrictions (Optional)',
                  hintText: 'e.g. Vegetarian meal, mobility assistance',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),

              // ── 5. Payment Proof Upload (Paper Section 2.1.5.1.8) ────
              _buildSectionTitle('5. Payment Proof Upload'),
              const SizedBox(height: 6),
              const Text(
                'Upload your transaction screenshot or deposit slip for admin verification.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // Payment method selector
              Row(
                children: [
                  _buildPaymentRadio('GCash', 'GCash e-Wallet'),
                  const SizedBox(width: 10),
                  _buildPaymentRadio('Bank Transfer (BPI)', 'Bank Deposit'),
                ],
              ),
              const SizedBox(height: 12),

              // Account info box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _paymentMethod == 'GCash'
                                ? 'GCash: 0917-888-VERDE (Gran Verde Farms)'
                                : 'BPI Account: 4019-2819-01 (Gran Verde Agritech)',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Text(
                            'Please pay the exact quotation total below.',
                            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _refNumberController,
                decoration: const InputDecoration(
                  labelText: 'Payment Reference / Transaction No.',
                  hintText: 'e.g. 902188492019',
                  prefixIcon: Icon(Icons.receipt_long_rounded, size: 20),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please input reference number' : null,
              ),

              const SizedBox(height: 10),

              // Upload File Box Simulation
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.image_outlined, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _attachedFileName ?? 'No receipt file attached',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: _attachedFileName != null ? AppColors.textPrimary : AppColors.textSecondary,
                          fontWeight: _attachedFileName != null ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _attachedFileName = 'receipt_gcash_${Random().nextInt(900) + 100}.png';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment receipt attached successfully!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.upload_file_rounded, size: 16),
                      label: const Text('Attach File'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── 6. Price Summary & Dynamic Quotation ───────────────
              _buildPriceSummary(),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _handleConfirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text(
                    'Confirm & Submit Booking',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRadio(String method, String label) {
    final isSelected = _paymentMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _paymentMethod = method),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 16,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.experience.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            widget.experience.imageEmoji,
            style: const TextStyle(fontSize: 38),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.experience.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.experience.subtitle,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatPrice(widget.experience.price)} / person',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quotation Summary',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Rule-Based Dynamic',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Base: ${widget.experience.title} × $_guestCount',
            _formatPrice(_baseSubtotal),
          ),
          if (_addOnsSubtotal > 0) ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
              'Selected Add-ons × $_guestCount',
              _formatPrice(_addOnsSubtotal),
            ),
          ],
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Platform & Service Fee (10%)',
            _formatPrice(_serviceFee),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                _formatPrice(_total),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
