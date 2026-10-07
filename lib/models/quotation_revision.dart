import 'package:cloud_firestore/cloud_firestore.dart';

/// ERD Entity: `quotation_revisions`
/// Audit of each revision with reason, previous/new totals, and who made the change.
/// Created whenever a new quotation version replaces the current one (BR-04).
class QuotationRevision {
  final String revisionId;
  final String quotationId;
  final int revisionNumber;
  final String reason;
  final double previousTotal;
  final double newTotal;
  final String changedBy;
  final String? revisionNote;
  final DateTime createdAt;

  const QuotationRevision({
    required this.revisionId,
    required this.quotationId,
    required this.revisionNumber,
    required this.reason,
    required this.previousTotal,
    required this.newTotal,
    required this.changedBy,
    this.revisionNote,
    required this.createdAt,
  });

  factory QuotationRevision.fromMap(Map<String, dynamic> map, String docId) {
    return QuotationRevision(
      revisionId: docId,
      quotationId: map['quotation_id'] as String,
      revisionNumber: map['revision_number'] as int,
      reason: map['reason'] as String,
      previousTotal: (map['previous_total'] as num).toDouble(),
      newTotal: (map['new_total'] as num).toDouble(),
      changedBy: map['changed_by'] as String,
      revisionNote: map['revision_note'] as String?,
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quotation_id': quotationId,
      'revision_number': revisionNumber,
      'reason': reason,
      'previous_total': previousTotal,
      'new_total': newTotal,
      'changed_by': changedBy,
      'revision_note': revisionNote,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  /// The change in total amount
  double get totalDifference => newTotal - previousTotal;

  /// Positive = price increase, Negative = price decrease
  String get changeDirection =>
      totalDifference > 0 ? '↑' : (totalDifference < 0 ? '↓' : '—');
}
