import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// ERD Entity: `visitor_tracking_records`
/// The 13 documented tracking fields captured at inquiry time (§2.2.1 Input).
/// Exactly one record per inquiry (BR-02), enforced by UK on `inquiry_id`.
class VisitorTrackingRecord {
  final String trackingId;
  final String inquiryId;
  final String accountId;
  final String visitorName;
  final String emailAddress;
  final String contactNumber;
  final String placeOfOrigin;
  final PurposeOfVisit purposeOfVisit;
  final String? preferredExperienceId;
  final List<String> preferredActivities;
  final int numberOfVisitors;
  final DateTime preferredVisitDate;
  final bool hasVisitedBefore;
  final ReferralSource referralSource;
  final String? specialRequests;
  final DateTime capturedAt;

  const VisitorTrackingRecord({
    required this.trackingId,
    required this.inquiryId,
    required this.accountId,
    required this.visitorName,
    required this.emailAddress,
    required this.contactNumber,
    required this.placeOfOrigin,
    required this.purposeOfVisit,
    this.preferredExperienceId,
    this.preferredActivities = const [],
    required this.numberOfVisitors,
    required this.preferredVisitDate,
    required this.hasVisitedBefore,
    required this.referralSource,
    this.specialRequests,
    required this.capturedAt,
  });

  factory VisitorTrackingRecord.fromMap(
      Map<String, dynamic> map, String docId) {
    return VisitorTrackingRecord(
      trackingId: docId,
      inquiryId: map['inquiry_id'] as String,
      accountId: map['account_id'] as String,
      visitorName: map['visitor_name'] as String,
      emailAddress: map['email_address'] as String,
      contactNumber: map['contact_number'] as String,
      placeOfOrigin: map['place_of_origin'] as String,
      purposeOfVisit: enumFromString(
          PurposeOfVisit.values, map['purpose_of_visit'] as String),
      preferredExperienceId: map['preferred_experience_id'] as String?,
      preferredActivities:
          List<String>.from(map['preferred_activities'] ?? []),
      numberOfVisitors: map['number_of_visitors'] as int,
      preferredVisitDate:
          (map['preferred_visit_date'] as Timestamp).toDate(),
      hasVisitedBefore: map['has_visited_before'] as bool,
      referralSource: enumFromString(
          ReferralSource.values, map['referral_source'] as String),
      specialRequests: map['special_requests'] as String?,
      capturedAt: (map['captured_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inquiry_id': inquiryId,
      'account_id': accountId,
      'visitor_name': visitorName,
      'email_address': emailAddress,
      'contact_number': contactNumber,
      'place_of_origin': placeOfOrigin,
      'purpose_of_visit': purposeOfVisit.firestoreValue,
      'preferred_experience_id': preferredExperienceId,
      'preferred_activities': preferredActivities,
      'number_of_visitors': numberOfVisitors,
      'preferred_visit_date': Timestamp.fromDate(preferredVisitDate),
      'has_visited_before': hasVisitedBefore,
      'referral_source': referralSource.firestoreValue,
      'special_requests': specialRequests,
      'captured_at': Timestamp.fromDate(capturedAt),
    };
  }
}
