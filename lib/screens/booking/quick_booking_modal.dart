import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:math';

import '../../core/theme/app_colors.dart';
import '../../models/experience_model.dart';
import '../../models/booking_model.dart';
import '../../models/user_session.dart';

class QuickBookingModal extends StatefulWidget {
  final Experience experience;

  const QuickBookingModal({super.key, required this.experience});

  static Future<void> show(BuildContext context, Experience experience) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuickBookingModal(experience: experience),
    );
  }

  @override
  State<QuickBookingModal> createState() => _QuickBookingModalState();
}

class _QuickBookingModalState extends State<QuickBookingModal> {
  int _visitors = 1;
  String? _selectedSlot;
  final Set<String> _selectedAddOnIds = {};
  String _paymentMethod = 'GCash';
  final TextEditingController _refNumberController = TextEditingController();
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestContactController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  Uint8List? _proofImageBytes;
  String? _proofImageName;
  bool _isPickingImage = false;

  final List<String> _slots = [
    '8:00 AM - 9:30 AM (Sunrise Tour)',
    '10:00 AM - 11:30 AM (Mid-Morning)',
    '2:00 PM - 3:30 PM (Afternoon Canopy)',
  ];

  @override
  void initState() {
    super.initState();
    if (_slots.isNotEmpty) {
      _selectedSlot = _slots.first;
    }
    if (UserSession.instance.isLoggedIn) {
      _guestNameController.text = UserSession.instance.fullName;
      _guestContactController.text = UserSession.instance.contactNumber;
    }
    _refNumberController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _refNumberController.dispose();
    _guestNameController.dispose();
    _guestContactController.dispose();
    super.dispose();
  }

  Future<void> _pickProofImage() async {
    try {
      setState(() => _isPickingImage = true);
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _proofImageBytes = bytes;
          _proofImageName = image.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not attach image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _removeProofImage() {
    setState(() {
      _proofImageBytes = null;
      _proofImageName = null;
    });
  }

  String _formatPrice(double price) {
    return '₱${price.toStringAsFixed(2)}';
  }

  double get _baseSubtotal => widget.experience.price * _visitors;

  double get _addOnsTotal {
    double sum = 0.0;
    for (var addon in widget.experience.availableAddOns) {
      if (_selectedAddOnIds.contains(addon.id)) {
        sum += addon.price * _visitors;
      }
    }
    return sum;
  }

  double get _totalPrice => _baseSubtotal + _addOnsTotal;

  void _handleSubmit() {
    final ref = _refNumberController.text.trim();
    if (ref.isEmpty && _proofImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter transfer reference number or attach screenshot proof.'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final random = Random();
    final refCode = 'GV-2026-${(random.nextInt(900) + 100).toString()}';

    final selectedAddOnNames = widget.experience.availableAddOns
        .where((a) => _selectedAddOnIds.contains(a.id))
        .map((a) => a.name)
        .toList();

    final newBooking = Booking(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      experience: widget.experience,
      date: _selectedSlot != null
          ? '${widget.experience.availableDates.isNotEmpty ? widget.experience.availableDates.first : 'Today'} ($_selectedSlot)'
          : 'Next Available Date',
      guests: _visitors,
      baseSubtotal: _baseSubtotal,
      addOnsTotal: _addOnsTotal,
      serviceFee: 0.0,
      totalPrice: _totalPrice,
      status: BookingStatus.pendingVerification,
      bookingRef: refCode,
      visitorName: _guestNameController.text.trim().isNotEmpty
          ? _guestNameController.text.trim()
          : (UserSession.instance.fullName.isNotEmpty ? UserSession.instance.fullName : 'Guest Visitor'),
      email: UserSession.instance.email.isNotEmpty ? UserSession.instance.email : 'guest@granverde.com',
      phone: _guestContactController.text.trim().isNotEmpty
          ? _guestContactController.text.trim()
          : (UserSession.instance.contactNumber.isNotEmpty ? UserSession.instance.contactNumber : '0917-888-8721'),
      placeOfOrigin: 'Davao City',
      purposeOfVisit: 'Eco-Tourism & Cacao Tasting',
      howLearned: 'Social Media',
      selectedAddOnNames: selectedAddOnNames,
      paymentMethod: _paymentMethod,
      paymentProofRef: ref.isNotEmpty ? ref : (_proofImageName ?? 'Proof Attached'),
      paymentProofFileName: _proofImageName ?? (ref.isNotEmpty ? 'ref_$ref.png' : 'payment_screenshot.png'),
    );

    BookingStore.instance.addBooking(newBooking);

    Navigator.pop(context); // Close bottom sheet

    // Show Confirmation Dialog
    _showSuccessDialog(newBooking);
  }

  void _showSuccessDialog(Booking booking) {
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 36,
                ),
              ),
              const SizedBox(height: 14),
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
                'Ref: ${booking.bookingRef}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.hourglass_top_rounded, size: 18, color: Colors.orange.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Status: Pending Payment Verification. Farm staff will review your receipt reference (${booking.paymentProofRef}).',
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
              _buildDialogRow('Tour', booking.experience.title),
              _buildDialogRow('Total Paid', _formatPrice(booking.totalPrice)),
              _buildDialogRow('Guests', '${booking.guests} Person(s)'),
              _buildDialogRow('Method', booking.paymentMethod),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D472B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    UserSession.instance.isLoggedIn ? 'View in My Bookings' : 'Done • Return to Storefront',
                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildPaymentTab(String method) {
    final isSelected = _paymentMethod == method;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _paymentMethod = method),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEBF3FF) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Center(
            child: Text(
              method,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF374151),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isSubmitActive = _refNumberController.text.trim().isNotEmpty || _proofImageBytes != null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.94,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F8F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF888888),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Header Banner (Forest Green background with Gold Title)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF0F4E31),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.experience.title,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD4A017),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_formatPrice(widget.experience.price)} / person',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Number of Visitors Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Number of visitors',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1B4D3E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Max 10 for this slot',
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD1D5DB)),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _visitors > 1
                                  ? () => setState(() => _visitors--)
                                  : null,
                              icon: const Icon(Icons.remove, size: 18),
                              color: const Color(0xFF374151),
                              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                              padding: EdgeInsets.zero,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '$_visitors',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _visitors < 10
                                  ? () => setState(() => _visitors++)
                                  : null,
                              icon: const Icon(Icons.add, size: 18),
                              color: const Color(0xFF374151),
                              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 2. ARRIVAL SLOT Section
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 15, color: const Color(0xFFB4831B)),
                      const SizedBox(width: 6),
                      const Text(
                        'ARRIVAL SLOT',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: Color(0xFF2D5A43),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_slots.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'No upcoming slots.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _slots.map((slot) {
                        final isSelected = _selectedSlot == slot;
                        return ChoiceChip(
                          label: Text(
                            slot,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Colors.white : const Color(0xFF374151),
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF0F4E31),
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF0F4E31) : const Color(0xFFD1D5DB),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          onSelected: (val) {
                            if (val) setState(() => _selectedSlot = slot);
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 18),

                  // 3. ADD-ONS Section
                  Row(
                    children: [
                      Icon(Icons.add_circle_outline, size: 15, color: const Color(0xFFB4831B)),
                      const SizedBox(width: 6),
                      const Text(
                        'ADD-ONS',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: Color(0xFF2D5A43),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...widget.experience.availableAddOns.take(3).map((addon) {
                    final isChecked = _selectedAddOnIds.contains(addon.id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isChecked ? const Color(0xFF0F4E31) : const Color(0xFFE5E7EB),
                          width: isChecked ? 1.4 : 1.0,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (isChecked) {
                              _selectedAddOnIds.remove(addon.id);
                            } else {
                              _selectedAddOnIds.add(addon.id);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: isChecked,
                                  activeColor: const Color(0xFF0F4E31),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        _selectedAddOnIds.add(addon.id);
                                      } else {
                                        _selectedAddOnIds.remove(addon.id);
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  addon.name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                              Text(
                                _formatPrice(addon.price),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // 4. PAYMENT Section
                  Row(
                    children: [
                      Icon(Icons.credit_card_outlined, size: 15, color: const Color(0xFFB4831B)),
                      const SizedBox(width: 6),
                      const Text(
                        'PAYMENT',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: Color(0xFF2D5A43),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildPaymentTab('GCash'),
                      const SizedBox(width: 8),
                      _buildPaymentTab('Maya'),
                      const SizedBox(width: 8),
                      _buildPaymentTab('BPI Bank Transfer'),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 5. QR Code Box (Exact light-blue container with inner white cards)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF3FE),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.qr_code_2_rounded, size: 18, color: Color(0xFF2563EB)),
                            const SizedBox(width: 8),
                            Text(
                              'Official $_paymentMethod transfer',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // High-contrast QR Card
                        Container(
                          width: 220,
                          height: 220,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: QrImageView(
                              data: '0917-888-8721 | Gran Verde Farm | $_paymentMethod',
                              version: QrVersions.auto,
                              size: 196.0,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Colors.black,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Account Holder Pill
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account: Gran Verde Farm',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '0917-888-8721',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 6. Total Card (Mint green box)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFCFE8D7)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F4E31),
                          ),
                        ),
                        Text(
                          _formatPrice(_totalPrice),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFB4831B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 7. Transfer Reference Number Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _refNumberController.text.isNotEmpty ? const Color(0xFF0F4E31) : const Color(0xFFD1D5DB),
                        width: _refNumberController.text.isNotEmpty ? 1.4 : 1.0,
                      ),
                    ),
                    child: TextField(
                      controller: _refNumberController,
                      decoration: const InputDecoration(
                        hintText: 'Transfer reference number',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                        prefixIcon: Icon(Icons.receipt_long_outlined, color: Color(0xFF6B7280), size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 7b. Attach Proof Screenshot (Double Purpose Verification)
                  if (_proofImageBytes != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF10B981), width: 1.3),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _proofImageBytes!,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Proof Attached',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F4E31),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _proofImageName ?? 'payment_receipt.png',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11.5,
                                    color: Color(0xFF6B7280),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _removeProofImage,
                            icon: const Icon(Icons.close_rounded, color: Color(0xFFEF4444), size: 20),
                            tooltip: 'Remove Screenshot',
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    InkWell(
                      onTap: _isPickingImage ? null : _pickProofImage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFD1D5DB),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: const Color(0xFF0F4E31),
                              size: 19,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isPickingImage ? 'Opening Gallery...' : 'Attach Payment Screenshot / Proof',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F4E31),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),

                  // 8. Action Buttons (Cancel & Submit for verification)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0F4E31),
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: isSubmitActive ? _handleSubmit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F4E31),
                            disabledBackgroundColor: const Color(0xFFE2E8E4),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: const Color(0xFF8D9991),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.near_me_rounded, size: 16),
                          label: const Text(
                            'Submit for verification',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
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
}

