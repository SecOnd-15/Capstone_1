import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// ERD Entity: `quotations`
/// One document per version; `version` + `is_current` implement revision
/// history (BR-04). Only the latest version stays current.
class Quotation {
  final String quotationId;
  final String inquiryId;
  final String quotationNumber;
  final int version;
  final QuotationStatus status;
  final double subtotal;
  final double addOnTotal;
  final double discountTotal;
  final double feeTotal;
  final double totalAmount;
  final String currency;
  final DateTime validityDate;
  final String? paymentTerms;
  final String? termsConditions;
  final List<String> inclusions;
  final RevisionReason? revisionReason;
  final bool isCurrent;
  final String preparedBy;
  final DateTime createdAt;

  const Quotation({
    required this.quotationId,
    required this.inquiryId,
    required this.quotationNumber,
    required this.version,
    required this.status,
    required this.subtotal,
    required this.addOnTotal,
    required this.discountTotal,
    required this.feeTotal,
    required this.totalAmount,
    this.currency = 'PHP',
    required this.validityDate,
    this.paymentTerms,
    this.termsConditions,
    required this.inclusions,
    this.revisionReason,
    required this.isCurrent,
    required this.preparedBy,
    required this.createdAt,
  });

  factory Quotation.fromMap(Map<String, dynamic> map, String docId) {
    return Quotation(
      quotationId: docId,
      inquiryId: map['inquiry_id'] as String,
      quotationNumber: map['quotation_number'] as String,
      version: map['version'] as int,
      status: enumFromString(
          QuotationStatus.values, map['status'] as String),
      subtotal: (map['subtotal'] as num).toDouble(),
      addOnTotal: (map['add_on_total'] as num).toDouble(),
      discountTotal: (map['discount_total'] as num).toDouble(),
      feeTotal: (map['fee_total'] as num).toDouble(),
      totalAmount: (map['total_amount'] as num).toDouble(),
      currency: map['currency'] as String? ?? 'PHP',
      validityDate: (map['validity_date'] as Timestamp).toDate(),
      paymentTerms: map['payment_terms'] as String?,
      termsConditions: map['terms_conditions'] as String?,
      inclusions: List<String>.from(map['inclusions'] ?? []),
      revisionReason: map['revision_reason'] != null
          ? enumFromString(
              RevisionReason.values, map['revision_reason'] as String)
          : null,
      isCurrent: map['is_current'] as bool,
      preparedBy: map['prepared_by'] as String,
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inquiry_id': inquiryId,
      'quotation_number': quotationNumber,
      'version': version,
      'status': status.firestoreValue,
      'subtotal': subtotal,
      'add_on_total': addOnTotal,
      'discount_total': discountTotal,
      'fee_total': feeTotal,
      'total_amount': totalAmount,
      'currency': currency,
      'validity_date': Timestamp.fromDate(validityDate),
      'payment_terms': paymentTerms,
      'terms_conditions': termsConditions,
      'inclusions': inclusions,
      'revision_reason': revisionReason?.firestoreValue,
      'is_current': isCurrent,
      'prepared_by': preparedBy,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  Quotation copyWith({
    QuotationStatus? status,
    bool? isCurrent,
  }) {
    return Quotation(
      quotationId: quotationId,
      inquiryId: inquiryId,
      quotationNumber: quotationNumber,
      version: version,
      status: status ?? this.status,
      subtotal: subtotal,
      addOnTotal: addOnTotal,
      discountTotal: discountTotal,
      feeTotal: feeTotal,
      totalAmount: totalAmount,
      currency: currency,
      validityDate: validityDate,
      paymentTerms: paymentTerms,
      termsConditions: termsConditions,
      inclusions: inclusions,
      revisionReason: revisionReason,
      isCurrent: isCurrent ?? this.isCurrent,
      preparedBy: preparedBy,
      createdAt: createdAt,
    );
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

  bool get isExpired => DateTime.now().isAfter(validityDate);
}
