import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// ERD Entity: `payment_proofs`
/// Uploaded proof + verification status + rejection reason (BR-08, BR-09).
/// 1:N with bookings — a rejected proof may be re-uploaded as a new row.
class PaymentProof {
  final String paymentId;
  final String bookingId;
  final PaymentProofType proofType;
  final String filePath;
  final String fileName;
  final double amountClaimed;
  final String? referenceNumber;
  final VerificationStatus verificationStatus;
  final String? rejectionReason;
  final String uploadedBy;
  final String? reviewedBy;
  final DateTime submittedAt;
  final DateTime? reviewedAt;

  const PaymentProof({
    required this.paymentId,
    required this.bookingId,
    required this.proofType,
    required this.filePath,
    required this.fileName,
    required this.amountClaimed,
    this.referenceNumber,
    required this.verificationStatus,
    this.rejectionReason,
    required this.uploadedBy,
    this.reviewedBy,
    required this.submittedAt,
    this.reviewedAt,
  });

  factory PaymentProof.fromMap(Map<String, dynamic> map, String docId) {
    return PaymentProof(
      paymentId: docId,
      bookingId: map['booking_id'] as String,
      proofType: enumFromString(
          PaymentProofType.values, map['proof_type'] as String),
      filePath: map['file_path'] as String,
      fileName: map['file_name'] as String,
      amountClaimed: (map['amount_claimed'] as num).toDouble(),
      referenceNumber: map['reference_number'] as String?,
      verificationStatus: enumFromString(
          VerificationStatus.values, map['verification_status'] as String),
      rejectionReason: map['rejection_reason'] as String?,
      uploadedBy: map['uploaded_by'] as String,
      reviewedBy: map['reviewed_by'] as String?,
      submittedAt: (map['submitted_at'] as Timestamp).toDate(),
      reviewedAt: map['reviewed_at'] != null
          ? (map['reviewed_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'booking_id': bookingId,
      'proof_type': proofType.firestoreValue,
      'file_path': filePath,
      'file_name': fileName,
      'amount_claimed': amountClaimed,
      'reference_number': referenceNumber,
      'verification_status': verificationStatus.firestoreValue,
      'rejection_reason': rejectionReason,
      'uploaded_by': uploadedBy,
      'reviewed_by': reviewedBy,
      'submitted_at': Timestamp.fromDate(submittedAt),
      'reviewed_at':
          reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
    };
  }

  PaymentProof copyWith({
    VerificationStatus? verificationStatus,
    String? rejectionReason,
    String? reviewedBy,
    DateTime? reviewedAt,
  }) {
    return PaymentProof(
      paymentId: paymentId,
      bookingId: bookingId,
      proofType: proofType,
      filePath: filePath,
      fileName: fileName,
      amountClaimed: amountClaimed,
      referenceNumber: referenceNumber,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      uploadedBy: uploadedBy,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      submittedAt: submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  bool get isPending => verificationStatus == VerificationStatus.pending;
  bool get isApproved => verificationStatus == VerificationStatus.approved;
  bool get isRejected => verificationStatus == VerificationStatus.rejected;

  String get proofTypeDisplay =>
      proofType == PaymentProofType.gcashReceipt ? 'GCash Receipt' : 'Bank Transfer';
}
