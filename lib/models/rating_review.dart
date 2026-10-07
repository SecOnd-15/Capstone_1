import 'package:cloud_firestore/cloud_firestore.dart';

/// ERD Entity: `ratings_reviews`
/// 1–5 star criteria + written review + weighted average (BR-12).
/// One review per completed booking (UK on booking_id).
///
/// Weighted average formula (§1.7 BR-12):
///   overall = 0.35 × satisfaction + 0.40 × quality + 0.25 × value
class RatingReview {
  final String reviewId;
  final String bookingId;
  final String accountId;
  final String serviceId;
  final int ratingSatisfaction;
  final int ratingExperienceQuality;
  final int ratingValue;
  final double overallRating;
  final String? writtenReview;
  final DateTime submittedAt;

  const RatingReview({
    required this.reviewId,
    required this.bookingId,
    required this.accountId,
    required this.serviceId,
    required this.ratingSatisfaction,
    required this.ratingExperienceQuality,
    required this.ratingValue,
    required this.overallRating,
    this.writtenReview,
    required this.submittedAt,
  });

  /// Compute the weighted average from the three criteria (BR-12)
  static double computeOverallRating({
    required int satisfaction,
    required int experienceQuality,
    required int value,
  }) {
    final raw = 0.35 * satisfaction + 0.40 * experienceQuality + 0.25 * value;
    return double.parse(raw.toStringAsFixed(2));
  }

  factory RatingReview.fromMap(Map<String, dynamic> map, String docId) {
    return RatingReview(
      reviewId: docId,
      bookingId: map['booking_id'] as String,
      accountId: map['account_id'] as String,
      serviceId: map['service_id'] as String,
      ratingSatisfaction: map['rating_satisfaction'] as int,
      ratingExperienceQuality: map['rating_experience_quality'] as int,
      ratingValue: map['rating_value'] as int,
      overallRating: (map['overall_rating'] as num).toDouble(),
      writtenReview: map['written_review'] as String?,
      submittedAt: (map['submitted_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'booking_id': bookingId,
      'account_id': accountId,
      'service_id': serviceId,
      'rating_satisfaction': ratingSatisfaction,
      'rating_experience_quality': ratingExperienceQuality,
      'rating_value': ratingValue,
      'overall_rating': overallRating,
      'written_review': writtenReview,
      'submitted_at': Timestamp.fromDate(submittedAt),
    };
  }

  /// Star display helper
  String get overallStars {
    final full = overallRating.floor();
    final half = (overallRating - full) >= 0.5 ? 1 : 0;
    return '${'★' * full}${'½' * half}${'☆' * (5 - full - half)}';
  }
}
