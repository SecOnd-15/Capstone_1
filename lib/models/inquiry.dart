import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// ERD Entity: `inquiries`
/// Each submission with unique id, timestamp, status (BR-01).
/// Linked 1:1 to a visitor_tracking_record (BR-02).
class Inquiry {
  final String inquiryId;
  final String accountId;
  final DateTime inquiryDate;
  final InquiryStatus status;
  final String? matchedServiceId;
  final double? matchScore;
  final String? adminResponse;
  final DateTime? respondedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Inquiry({
    required this.inquiryId,
    required this.accountId,
    required this.inquiryDate,
    required this.status,
    this.matchedServiceId,
    this.matchScore,
    this.adminResponse,
    this.respondedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inquiry.fromMap(Map<String, dynamic> map, String docId) {
    return Inquiry(
      inquiryId: docId,
      accountId: map['account_id'] as String,
      inquiryDate: (map['inquiry_date'] as Timestamp).toDate(),
      status:
          enumFromString(InquiryStatus.values, map['status'] as String),
      matchedServiceId: map['matched_service_id'] as String?,
      matchScore: (map['match_score'] as num?)?.toDouble(),
      adminResponse: map['admin_response'] as String?,
      respondedAt: map['responded_at'] != null
          ? (map['responded_at'] as Timestamp).toDate()
          : null,
      createdAt: (map['created_at'] as Timestamp).toDate(),
      updatedAt: (map['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'account_id': accountId,
      'inquiry_date': Timestamp.fromDate(inquiryDate),
      'status': status.firestoreValue,
      'matched_service_id': matchedServiceId,
      'match_score': matchScore,
      'admin_response': adminResponse,
      'responded_at':
          respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  Inquiry copyWith({
    InquiryStatus? status,
    String? matchedServiceId,
    double? matchScore,
    String? adminResponse,
    DateTime? respondedAt,
    DateTime? updatedAt,
  }) {
    return Inquiry(
      inquiryId: inquiryId,
      accountId: accountId,
      inquiryDate: inquiryDate,
      status: status ?? this.status,
      matchedServiceId: matchedServiceId ?? this.matchedServiceId,
      matchScore: matchScore ?? this.matchScore,
      adminResponse: adminResponse ?? this.adminResponse,
      respondedAt: respondedAt ?? this.respondedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Display-friendly status string
  String get statusDisplay {
    switch (status) {
      case InquiryStatus.newInquiry:
        return 'New';
      case InquiryStatus.inProgress:
        return 'In Progress';
      case InquiryStatus.quoted:
        return 'Quoted';
      case InquiryStatus.booked:
        return 'Booked';
      case InquiryStatus.closed:
        return 'Closed';
    }
  }
}
