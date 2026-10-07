import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// ERD Entity: `reminders`
/// Reminder instances for approved bookings (BR-11).
/// Created by UC-28, fired by the Supabase scheduler (UC-34).
class Reminder {
  final String reminderId;
  final String calendarEntryId;
  final String accountId;
  final int offsetMinutes;
  final DateTime scheduledFor;
  final ReminderStatus status;
  final DateTime? sentAt;
  final String message;

  const Reminder({
    required this.reminderId,
    required this.calendarEntryId,
    required this.accountId,
    required this.offsetMinutes,
    required this.scheduledFor,
    required this.status,
    this.sentAt,
    required this.message,
  });

  factory Reminder.fromMap(Map<String, dynamic> map, String docId) {
    return Reminder(
      reminderId: docId,
      calendarEntryId: map['calendar_entry_id'] as String,
      accountId: map['account_id'] as String,
      offsetMinutes: map['offset_minutes'] as int,
      scheduledFor: (map['scheduled_for'] as Timestamp).toDate(),
      status: enumFromString(
          ReminderStatus.values, map['status'] as String),
      sentAt: map['sent_at'] != null
          ? (map['sent_at'] as Timestamp).toDate()
          : null,
      message: map['message'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calendar_entry_id': calendarEntryId,
      'account_id': accountId,
      'offset_minutes': offsetMinutes,
      'scheduled_for': Timestamp.fromDate(scheduledFor),
      'status': status.firestoreValue,
      'sent_at': sentAt != null ? Timestamp.fromDate(sentAt!) : null,
      'message': message,
    };
  }

  Reminder copyWith({
    ReminderStatus? status,
    DateTime? sentAt,
  }) {
    return Reminder(
      reminderId: reminderId,
      calendarEntryId: calendarEntryId,
      accountId: accountId,
      offsetMinutes: offsetMinutes,
      scheduledFor: scheduledFor,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      message: message,
    );
  }

  /// Human-readable offset
  String get offsetDisplay {
    if (offsetMinutes < 60) return '$offsetMinutes min before';
    final hours = offsetMinutes ~/ 60;
    final mins = offsetMinutes % 60;
    if (mins == 0) return '$hours hr before';
    return '$hours hr $mins min before';
  }

  bool get isDue => DateTime.now().isAfter(scheduledFor);
}
