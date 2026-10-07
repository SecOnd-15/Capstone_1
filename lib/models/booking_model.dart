import 'package:flutter/material.dart';
import 'experience_model.dart';

enum BookingStatus {
  pendingVerification, // Uploaded payment proof, awaiting admin check
  confirmed,           // Admin approved payment & schedule
  past,                // Completed visit
  cancelled,           // Cancelled or rejected by admin
}

class Booking {
  final String id;
  final Experience experience;
  final String date;
  final int guests;
  final double baseSubtotal;
  final double addOnsTotal;
  final double serviceFee; // 10%
  final double discount;
  final double totalPrice;
  BookingStatus status;
  final String bookingRef;
  
  // Visitor tracking & inquiry metadata (Paper Section 1.2 & 2.1.5.1.3)
  final String visitorName;
  final String email;
  final String phone;
  final String placeOfOrigin;
  final String purposeOfVisit;
  final String howLearned;
  final String? specialRequests;
  final List<String> selectedAddOnNames;

  // Payment proof info (Paper Section 1.2 & 2.1.5.1.8)
  final String paymentMethod; // 'GCash' or 'Bank Transfer'
  final String paymentProofRef; // e.g. GCash Ref #
  final String? paymentProofFileName;
  final String? rejectionReason;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.experience,
    required this.date,
    required this.guests,
    required this.baseSubtotal,
    this.addOnsTotal = 0.0,
    required this.serviceFee,
    this.discount = 0.0,
    required this.totalPrice,
    required this.status,
    required this.bookingRef,
    required this.visitorName,
    required this.email,
    required this.phone,
    this.placeOfOrigin = 'Davao City',
    this.purposeOfVisit = 'Educational & Leisure',
    this.howLearned = 'Social Media',
    this.specialRequests,
    this.selectedAddOnNames = const [],
    this.paymentMethod = 'GCash',
    this.paymentProofRef = '901234567890',
    this.paymentProofFileName,
    this.rejectionReason,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get statusDisplay {
    switch (status) {
      case BookingStatus.pendingVerification:
        return 'Pending Verification';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.past:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case BookingStatus.pendingVerification:
        return Colors.orange.shade800;
      case BookingStatus.confirmed:
        return const Color(0xFF2E7D32);
      case BookingStatus.past:
        return Colors.blueGrey;
      case BookingStatus.cancelled:
        return const Color(0xFFC62828);
    }
  }
}

/// Central state store for static prototype live interactivity
class BookingStore extends ChangeNotifier {
  static final BookingStore instance = BookingStore._internal();
  BookingStore._internal() {
    _bookings = _initSampleBookings();
  }

  late List<Booking> _bookings;

  List<Booking> get all => List.unmodifiable(_bookings);

  List<Booking> getByStatus(BookingStatus status) {
    return _bookings.where((b) => b.status == status).toList();
  }

  List<Booking> get upcomingAndPending {
    return _bookings
        .where((b) =>
            b.status == BookingStatus.confirmed ||
            b.status == BookingStatus.pendingVerification)
        .toList();
  }

  void addBooking(Booking booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }

  void cancelBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index].status = BookingStatus.cancelled;
      notifyListeners();
    }
  }

  void approveBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index].status = BookingStatus.confirmed;
      notifyListeners();
    }
  }

  void rejectBooking(String id, String reason) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index].status = BookingStatus.cancelled;
      // We recreate or mutate
      final old = _bookings[index];
      _bookings[index] = Booking(
        id: old.id,
        experience: old.experience,
        date: old.date,
        guests: old.guests,
        baseSubtotal: old.baseSubtotal,
        addOnsTotal: old.addOnsTotal,
        serviceFee: old.serviceFee,
        discount: old.discount,
        totalPrice: old.totalPrice,
        status: BookingStatus.cancelled,
        bookingRef: old.bookingRef,
        visitorName: old.visitorName,
        email: old.email,
        phone: old.phone,
        placeOfOrigin: old.placeOfOrigin,
        purposeOfVisit: old.purposeOfVisit,
        howLearned: old.howLearned,
        specialRequests: old.specialRequests,
        selectedAddOnNames: old.selectedAddOnNames,
        paymentMethod: old.paymentMethod,
        paymentProofRef: old.paymentProofRef,
        paymentProofFileName: old.paymentProofFileName,
        rejectionReason: reason,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }

  static List<Booking> _initSampleBookings() {
    final kakaw = ExperienceData.all.firstWhere(
        (e) => e.id == 'exp_kakaw_lakaw',
        orElse: () => ExperienceData.all[0]);
    final bahandi = ExperienceData.all.firstWhere(
        (e) => e.id == 'exp_bahandi',
        orElse: () => ExperienceData.all[1]);
    final custom = ExperienceData.all.firstWhere(
        (e) => e.id == 'exp_customized',
        orElse: () => ExperienceData.all[2]);

    return [
      Booking(
        id: 'bk_001',
        experience: kakaw,
        date: 'Oct 18, 2026',
        guests: 2,
        baseSubtotal: 1500,
        addOnsTotal: 250,
        serviceFee: 175,
        totalPrice: 1925,
        status: BookingStatus.confirmed,
        bookingRef: 'GV-2026-101',
        visitorName: 'Maria Santos',
        email: 'maria.santos@email.com',
        phone: '+63 917 123 4567',
        placeOfOrigin: 'Davao City',
        purposeOfVisit: 'Agri-tourism Field Trip',
        howLearned: 'Facebook Page',
        selectedAddOnNames: ['Artisan Tablea Box'],
        paymentMethod: 'GCash',
        paymentProofRef: 'GCASH-9821839210',
        paymentProofFileName: 'receipt_gcash_101.jpg',
      ),
      Booking(
        id: 'bk_002',
        experience: bahandi,
        date: 'Oct 22, 2026',
        guests: 4,
        baseSubtotal: 5800,
        addOnsTotal: 700,
        serviceFee: 650,
        totalPrice: 7150,
        status: BookingStatus.pendingVerification,
        bookingRef: 'GV-2026-204',
        visitorName: 'Maria Santos',
        email: 'maria.santos@email.com',
        phone: '+63 917 123 4567',
        placeOfOrigin: 'Tagum City',
        purposeOfVisit: 'Family Weekend Workshop',
        howLearned: 'Friend Recommendation',
        selectedAddOnNames: ['Farm-to-Table Lunch Upgrade', 'Artisan Tablea Box'],
        paymentMethod: 'Bank Transfer (BPI)',
        paymentProofRef: 'BPI-TRX-449102',
        paymentProofFileName: 'bpi_deposit_slip.png',
      ),
      Booking(
        id: 'bk_003',
        experience: custom,
        date: 'Sep 25, 2026',
        guests: 1,
        baseSubtotal: 1200,
        addOnsTotal: 0,
        serviceFee: 120,
        totalPrice: 1320,
        status: BookingStatus.past,
        bookingRef: 'GV-2026-089',
        visitorName: 'Maria Santos',
        email: 'maria.santos@email.com',
        phone: '+63 917 123 4567',
        placeOfOrigin: 'Davao City',
        purposeOfVisit: 'Personal Research',
        howLearned: 'Gran Verde Website',
        paymentMethod: 'GCash',
        paymentProofRef: 'GCASH-7718293012',
      ),
    ];
  }
}
