import 'package:flutter/material.dart';

enum InquiryStatusType { newInquiry, inProgress, quoted, booked, closed }

class InquiryEntry {
  final String id;
  final String inquiryRef;
  final String visitorName;
  final String email;
  final String phone;
  final String placeOfOrigin;
  final String interestTopic;
  final String preferredDate;
  final int estimatedGuests;
  final String message;
  final String sourceAdvertisement;
  InquiryStatusType status;
  final DateTime createdAt;
  String? adminResponse;

  InquiryEntry({
    required this.id,
    required this.inquiryRef,
    required this.visitorName,
    required this.email,
    required this.phone,
    required this.placeOfOrigin,
    required this.interestTopic,
    required this.preferredDate,
    required this.estimatedGuests,
    required this.message,
    required this.sourceAdvertisement,
    this.status = InquiryStatusType.newInquiry,
    required this.createdAt,
    this.adminResponse,
  });

  String get statusDisplay {
    switch (status) {
      case InquiryStatusType.newInquiry:
        return 'New Inquiry';
      case InquiryStatusType.inProgress:
        return 'In Progress';
      case InquiryStatusType.quoted:
        return 'Quoted';
      case InquiryStatusType.booked:
        return 'Converted to Booking';
      case InquiryStatusType.closed:
        return 'Closed';
    }
  }

  Color get statusColor {
    switch (status) {
      case InquiryStatusType.newInquiry:
        return const Color(0xFFE65100);
      case InquiryStatusType.inProgress:
        return const Color(0xFF1565C0);
      case InquiryStatusType.quoted:
        return const Color(0xFF6A1B9A);
      case InquiryStatusType.booked:
        return const Color(0xFF2E7D32);
      case InquiryStatusType.closed:
        return const Color(0xFF616161);
    }
  }
}

class InquiryStore extends ChangeNotifier {
  static final InquiryStore instance = InquiryStore._internal();
  InquiryStore._internal() {
    _initSampleData();
  }

  final List<InquiryEntry> _inquiries = [];
  List<InquiryEntry> get inquiries => List.unmodifiable(_inquiries);

  int get pendingCount => _inquiries.where((i) => i.status == InquiryStatusType.newInquiry).length;

  void addInquiry(InquiryEntry entry) {
    _inquiries.insert(0, entry);
    notifyListeners();
  }

  void updateStatus(String id, InquiryStatusType newStatus, {String? response}) {
    final idx = _inquiries.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _inquiries[idx].status = newStatus;
      if (response != null) {
        _inquiries[idx].adminResponse = response;
      }
      notifyListeners();
    }
  }

  void _initSampleData() {
    _inquiries.addAll([
      InquiryEntry(
        id: 'inq_001',
        inquiryRef: 'INQ-2026-081',
        visitorName: 'Carlos Rivera',
        email: 'carlos.rivera@gmail.com',
        phone: '+63 918 555 1290',
        placeOfOrigin: 'Cagayan de Oro',
        interestTopic: 'Tree-to-Bar Workshop & Tour',
        preferredDate: 'Nov 12, 2026',
        estimatedGuests: 6,
        message: 'We are planning a university agroforestry team visit. Can we request a morning schedule with pure cacao tasting?',
        sourceAdvertisement: 'Special Harvest Tour Promo & Video Showcase',
        status: InquiryStatusType.newInquiry,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InquiryEntry(
        id: 'inq_002',
        inquiryRef: 'INQ-2026-074',
        visitorName: 'Elena Cruz',
        email: 'elena.cruz@delicacies.ph',
        phone: '+63 920 334 8812',
        placeOfOrigin: 'Davao City',
        interestTopic: 'Bulk Artisan Tablea & Nibs Order',
        preferredDate: 'Oct 28, 2026',
        estimatedGuests: 2,
        message: 'Looking to purchase 50 boxes of Pure Davao Tablea and roasted cacao nibs for our holiday gift baskets.',
        sourceAdvertisement: 'Artisan Cacao Farm Store Promo',
        status: InquiryStatusType.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      ),
    ]);
  }
}
