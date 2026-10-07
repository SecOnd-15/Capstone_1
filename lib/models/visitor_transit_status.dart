import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// NEW ENTITY: `visitor_transit_status`
/// Real-time arrival tracking with privacy toggle.
/// Visitors can enable/disable location sharing on the day of their visit.
/// Requirement source: Bisaya chat — "Tracking if makaya... enable and disable ang visitors..."
class VisitorTransitStatus {
  final String transitId;
  final String bookingId;
  final String accountId;
  final bool isSharingEnabled;
  final double? currentLatitude;
  final double? currentLongitude;
  final TransitStatus transitStatus;
  final DateTime lastUpdatedAt;
  final int? etaMinutes;

  const VisitorTransitStatus({
    required this.transitId,
    required this.bookingId,
    required this.accountId,
    required this.isSharingEnabled,
    this.currentLatitude,
    this.currentLongitude,
    required this.transitStatus,
    required this.lastUpdatedAt,
    this.etaMinutes,
  });

  factory VisitorTransitStatus.fromMap(
      Map<String, dynamic> map, String docId) {
    return VisitorTransitStatus(
      transitId: docId,
      bookingId: map['booking_id'] as String,
      accountId: map['account_id'] as String,
      isSharingEnabled: map['is_sharing_enabled'] as bool,
      currentLatitude: (map['current_latitude'] as num?)?.toDouble(),
      currentLongitude: (map['current_longitude'] as num?)?.toDouble(),
      transitStatus: enumFromString(
          TransitStatus.values, map['transit_status'] as String),
      lastUpdatedAt: (map['last_updated_at'] as Timestamp).toDate(),
      etaMinutes: map['eta_minutes'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'booking_id': bookingId,
      'account_id': accountId,
      'is_sharing_enabled': isSharingEnabled,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
      'transit_status': transitStatus.firestoreValue,
      'last_updated_at': Timestamp.fromDate(lastUpdatedAt),
      'eta_minutes': etaMinutes,
    };
  }

  VisitorTransitStatus copyWith({
    bool? isSharingEnabled,
    double? currentLatitude,
    double? currentLongitude,
    TransitStatus? transitStatus,
    DateTime? lastUpdatedAt,
    int? etaMinutes,
  }) {
    return VisitorTransitStatus(
      transitId: transitId,
      bookingId: bookingId,
      accountId: accountId,
      isSharingEnabled: isSharingEnabled ?? this.isSharingEnabled,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      transitStatus: transitStatus ?? this.transitStatus,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }

  /// Display-friendly status
  String get statusDisplay {
    switch (transitStatus) {
      case TransitStatus.notStarted:
        return 'Not yet started';
      case TransitStatus.onTheWay:
        return 'On the way';
      case TransitStatus.approaching:
        return 'Approaching farm';
      case TransitStatus.arrived:
        return 'Arrived';
    }
  }

  /// ETA display
  String get etaDisplay {
    if (etaMinutes == null) return 'Unknown';
    if (etaMinutes! < 1) return 'Arriving now';
    if (etaMinutes! < 60) return '$etaMinutes min';
    final hours = etaMinutes! ~/ 60;
    final mins = etaMinutes! % 60;
    return '$hours hr ${mins > 0 ? "$mins min" : ""}';
  }

  bool get hasLocation =>
      currentLatitude != null && currentLongitude != null;
}
