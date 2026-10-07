import 'enums.dart';

/// ERD Entity: `visitor_profiles`
/// Standing preferences edited via the profile tab (FR 2.1.5.1.2).
/// 1:1 with `accounts`. Created at registration.
class VisitorProfile {
  final String profileId;
  final String accountId;
  final String? placeOfOrigin;
  final VisitorType? visitorType;
  final ReferralSource? referralSource;
  final bool? hasVisitedBefore;
  final int? previousVisitCount;
  final double? budgetMin;
  final double? budgetMax;
  final List<String> interestTags;
  final String? preferredExperienceType;
  final int? preferredGroupSize;
  final String? specialRequests;

  const VisitorProfile({
    required this.profileId,
    required this.accountId,
    this.placeOfOrigin,
    this.visitorType,
    this.referralSource,
    this.hasVisitedBefore,
    this.previousVisitCount,
    this.budgetMin,
    this.budgetMax,
    this.interestTags = const [],
    this.preferredExperienceType,
    this.preferredGroupSize,
    this.specialRequests,
  });

  factory VisitorProfile.fromMap(Map<String, dynamic> map, String docId) {
    return VisitorProfile(
      profileId: docId,
      accountId: map['account_id'] as String,
      placeOfOrigin: map['place_of_origin'] as String?,
      visitorType: map['visitor_type'] != null
          ? enumFromString(VisitorType.values, map['visitor_type'] as String)
          : null,
      referralSource: map['referral_source'] != null
          ? enumFromString(
              ReferralSource.values, map['referral_source'] as String)
          : null,
      hasVisitedBefore: map['has_visited_before'] as bool?,
      previousVisitCount: map['previous_visit_count'] as int?,
      budgetMin: (map['budget_min'] as num?)?.toDouble(),
      budgetMax: (map['budget_max'] as num?)?.toDouble(),
      interestTags: List<String>.from(map['interest_tags'] ?? []),
      preferredExperienceType: map['preferred_experience_type'] as String?,
      preferredGroupSize: map['preferred_group_size'] as int?,
      specialRequests: map['special_requests'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'account_id': accountId,
      'place_of_origin': placeOfOrigin,
      'visitor_type': visitorType?.firestoreValue,
      'referral_source': referralSource?.firestoreValue,
      'has_visited_before': hasVisitedBefore,
      'previous_visit_count': previousVisitCount,
      'budget_min': budgetMin,
      'budget_max': budgetMax,
      'interest_tags': interestTags,
      'preferred_experience_type': preferredExperienceType,
      'preferred_group_size': preferredGroupSize,
      'special_requests': specialRequests,
    };
  }

  VisitorProfile copyWith({
    String? placeOfOrigin,
    VisitorType? visitorType,
    ReferralSource? referralSource,
    bool? hasVisitedBefore,
    int? previousVisitCount,
    double? budgetMin,
    double? budgetMax,
    List<String>? interestTags,
    String? preferredExperienceType,
    int? preferredGroupSize,
    String? specialRequests,
  }) {
    return VisitorProfile(
      profileId: profileId,
      accountId: accountId,
      placeOfOrigin: placeOfOrigin ?? this.placeOfOrigin,
      visitorType: visitorType ?? this.visitorType,
      referralSource: referralSource ?? this.referralSource,
      hasVisitedBefore: hasVisitedBefore ?? this.hasVisitedBefore,
      previousVisitCount: previousVisitCount ?? this.previousVisitCount,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      interestTags: interestTags ?? this.interestTags,
      preferredExperienceType:
          preferredExperienceType ?? this.preferredExperienceType,
      preferredGroupSize: preferredGroupSize ?? this.preferredGroupSize,
      specialRequests: specialRequests ?? this.specialRequests,
    );
  }
}
