import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'enums.dart';

/// ERD Entity: `calendar_entries`
/// Approved bookings reflected in the shared calendar (BR-10).
/// Created ONLY when payment is approved — not at booking time.
class CalendarEntry {
  final String calendarEntryId;
  final String bookingId;
  final String serviceId;
  final DateTime entryDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int expectedParticipants;
  final CalendarEntryStatus status;
  final String? notes;
  final DateTime createdAt;

  const CalendarEntry({
    required this.calendarEntryId,
    required this.bookingId,
    required this.serviceId,
    required this.entryDate,
    required this.startTime,
    required this.endTime,
    required this.expectedParticipants,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory CalendarEntry.fromMap(Map<String, dynamic> map, String docId) {
    return CalendarEntry(
      calendarEntryId: docId,
      bookingId: map['booking_id'] as String,
      serviceId: map['service_id'] as String,
      entryDate: (map['entry_date'] as Timestamp).toDate(),
      startTime: _timeFromString(map['start_time'] as String),
      endTime: _timeFromString(map['end_time'] as String),
      expectedParticipants: map['expected_participants'] as int,
      status: enumFromString(
          CalendarEntryStatus.values, map['status'] as String),
      notes: map['notes'] as String?,
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'booking_id': bookingId,
      'service_id': serviceId,
      'entry_date': Timestamp.fromDate(entryDate),
      'start_time': _timeToString(startTime),
      'end_time': _timeToString(endTime),
      'expected_participants': expectedParticipants,
      'status': status.firestoreValue,
      'notes': notes,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  CalendarEntry copyWith({
    CalendarEntryStatus? status,
    String? notes,
  }) {
    return CalendarEntry(
      calendarEntryId: calendarEntryId,
      bookingId: bookingId,
      serviceId: serviceId,
      entryDate: entryDate,
      startTime: startTime,
      endTime: endTime,
      expectedParticipants: expectedParticipants,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  /// Whether this entry is in the future
  bool get isUpcoming => entryDate.isAfter(DateTime.now());

  /// Time display string
  String get timeRange =>
      '${_timeToString(startTime)} – ${_timeToString(endTime)}';

  static TimeOfDay _timeFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
