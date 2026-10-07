import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'enums.dart';

/// NEW ENTITY: `gate_passes`
/// Digital gate pass generated when payment is approved.
/// Visitors present the QR code at the farm entrance for verification.
/// Requirement source: Bisaya chat — "Butangi ragud pod og gate pass..."
class GatePass {
  final String gatePassId;
  final String bookingId;
  final String qrCodeData;
  final DateTime issuedAt;
  final DateTime validFrom;
  final DateTime validUntil;
  final GatePassScanStatus scanStatus;
  final DateTime? scannedAt;
  final String? scannedBy;

  const GatePass({
    required this.gatePassId,
    required this.bookingId,
    required this.qrCodeData,
    required this.issuedAt,
    required this.validFrom,
    required this.validUntil,
    required this.scanStatus,
    this.scannedAt,
    this.scannedBy,
  });

  /// Generate the QR code data payload for a booking
  static String generateQrPayload({
    required String bookingReference,
    required String serviceName,
    required DateTime scheduledDate,
    required int pax,
    required String gatePassId,
  }) {
    return jsonEncode({
      'type': 'gran_verde_gate_pass',
      'gate_pass_id': gatePassId,
      'booking_ref': bookingReference,
      'service': serviceName,
      'date': scheduledDate.toIso8601String().split('T').first,
      'pax': pax,
      'issued': DateTime.now().toIso8601String(),
    });
  }

  /// Parse QR code data back to a map for validation
  static Map<String, dynamic>? parseQrPayload(String qrData) {
    try {
      final decoded = jsonDecode(qrData) as Map<String, dynamic>;
      if (decoded['type'] == 'gran_verde_gate_pass') return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  factory GatePass.fromMap(Map<String, dynamic> map, String docId) {
    return GatePass(
      gatePassId: docId,
      bookingId: map['booking_id'] as String,
      qrCodeData: map['qr_code_data'] as String,
      issuedAt: (map['issued_at'] as Timestamp).toDate(),
      validFrom: (map['valid_from'] as Timestamp).toDate(),
      validUntil: (map['valid_until'] as Timestamp).toDate(),
      scanStatus: enumFromString(
          GatePassScanStatus.values, map['scan_status'] as String),
      scannedAt: map['scanned_at'] != null
          ? (map['scanned_at'] as Timestamp).toDate()
          : null,
      scannedBy: map['scanned_by'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'booking_id': bookingId,
      'qr_code_data': qrCodeData,
      'issued_at': Timestamp.fromDate(issuedAt),
      'valid_from': Timestamp.fromDate(validFrom),
      'valid_until': Timestamp.fromDate(validUntil),
      'scan_status': scanStatus.firestoreValue,
      'scanned_at':
          scannedAt != null ? Timestamp.fromDate(scannedAt!) : null,
      'scanned_by': scannedBy,
    };
  }

  GatePass copyWith({
    GatePassScanStatus? scanStatus,
    DateTime? scannedAt,
    String? scannedBy,
  }) {
    return GatePass(
      gatePassId: gatePassId,
      bookingId: bookingId,
      qrCodeData: qrCodeData,
      issuedAt: issuedAt,
      validFrom: validFrom,
      validUntil: validUntil,
      scanStatus: scanStatus ?? this.scanStatus,
      scannedAt: scannedAt ?? this.scannedAt,
      scannedBy: scannedBy ?? this.scannedBy,
    );
  }

  bool get isValid {
    final now = DateTime.now();
    return now.isAfter(validFrom) &&
        now.isBefore(validUntil) &&
        scanStatus == GatePassScanStatus.notScanned;
  }

  bool get isScanned => scanStatus == GatePassScanStatus.scanned;
  bool get isExpired => DateTime.now().isAfter(validUntil);
}
