import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'enums.dart';

/// ERD Entity: `bookings`
/// Schedule chosen by the client (BR-06). Created only from an accepted
/// quotation (BR-05), enforced by UK on quotation_id.
class BookingRecord {
  final String bookingId;
  final String bookingReference;
  final String quotationId;
  final String accountId;
  final String serviceId;
  final DateTime scheduledDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int numberOfParticipants;
  final String? specialRequests;
  final double totalAmount;
  final BookingStatusEnum status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingRecord({
    required this.bookingId,
    required this.bookingReference,
    required this.quotationId,
    required this.accountId,
    required this.serviceId,
    required this.scheduledDate,
    required this.startTime,
    required this.endTime,
    required this.numberOfParticipants,
    this.specialRequests,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingRecord.fromMap(Map<String, dynamic> map, String docId) {
    return BookingRecord(
      bookingId: docId,
      bookingReference: map['booking_reference'] as String,
      quotationId: map['quotation_id'] as String,
      accountId: map['account_id'] as String,
      serviceId: map['service_id'] as String,
      scheduledDate: (map['scheduled_date'] as Timestamp).toDate(),
      startTime: _timeFromString(map['start_time'] as String),
      endTime: _timeFromString(map['end_time'] as String),
      numberOfParticipants: map['number_of_participants'] as int,
      specialRequests: map['special_requests'] as String?,
      totalAmount: (map['total_amount'] as num).toDouble(),
      status: enumFromString(
          BookingStatusEnum.values, map['status'] as String),
      createdAt: (map['created_at'] as Timestamp).toDate(),
      updatedAt: (map['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'booking_reference': bookingReference,
      'quotation_id': quotationId,
      'account_id': accountId,
      'service_id': serviceId,
      'scheduled_date': Timestamp.fromDate(scheduledDate),
      'start_time': _timeToString(startTime),
      'end_time': _timeToString(endTime),
      'number_of_participants': numberOfParticipants,
      'special_requests': specialRequests,
      'total_amount': totalAmount,
      'status': status.firestoreValue,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  BookingRecord copyWith({
    BookingStatusEnum? status,
    DateTime? updatedAt,
  }) {
    return BookingRecord(
      bookingId: bookingId,
      bookingReference: bookingReference,
      quotationId: quotationId,
      accountId: accountId,
      serviceId: serviceId,
      scheduledDate: scheduledDate,
      startTime: startTime,
      endTime: endTime,
      numberOfParticipants: numberOfParticipants,
      specialRequests: specialRequests,
      totalAmount: totalAmount,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Display status
  String get statusDisplay {
    switch (status) {
      case BookingStatusEnum.pendingPayment:
        return 'Pending Payment';
      case BookingStatusEnum.confirmed:
        return 'Confirmed';
      case BookingStatusEnum.cancelled:
        return 'Cancelled';
      case BookingStatusEnum.completed:
        return 'Completed';
    }
  }

  Color get statusColor {
    switch (status) {
      case BookingStatusEnum.pendingPayment:
        return Colors.orange.shade800;
      case BookingStatusEnum.confirmed:
        return const Color(0xFF2E7D32);
      case BookingStatusEnum.cancelled:
        return const Color(0xFFC62828);
      case BookingStatusEnum.completed:
        return Colors.blueGrey;
    }
  }

  /// Display-friendly total
  String get formattedTotal {
    final parts = totalAmount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    return '₱$buffer.${parts[1]}';
  }

  // ── Time helpers ────────────────────────────────────────────────────

  static TimeOfDay _timeFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
