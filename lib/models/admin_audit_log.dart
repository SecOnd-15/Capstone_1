import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// ERD Entity: `admin_audit_log`
/// Access logging of administrative actions (BR-18).
/// Append-only — entries are never modified or deleted.
class AdminAuditLog {
  final String auditId;
  final String accountId;
  final AuditActionType actionType;
  final String targetType;
  final String? targetId;
  final String? details;
  final DateTime performedAt;

  const AdminAuditLog({
    required this.auditId,
    required this.accountId,
    required this.actionType,
    required this.targetType,
    this.targetId,
    this.details,
    required this.performedAt,
  });

  factory AdminAuditLog.fromMap(Map<String, dynamic> map, String docId) {
    return AdminAuditLog(
      auditId: docId,
      accountId: map['account_id'] as String,
      actionType: enumFromString(
          AuditActionType.values, map['action_type'] as String),
      targetType: map['target_type'] as String,
      targetId: map['target_id'] as String?,
      details: map['details'] as String?,
      performedAt: (map['performed_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'account_id': accountId,
      'action_type': actionType.firestoreValue,
      'target_type': targetType,
      'target_id': targetId,
      'details': details,
      'performed_at': Timestamp.fromDate(performedAt),
    };
  }

  /// Display-friendly action
  String get actionDisplay {
    switch (actionType) {
      case AuditActionType.login:
        return 'Logged in';
      case AuditActionType.updateService:
        return 'Updated service';
      case AuditActionType.createQuotation:
        return 'Created quotation';
      case AuditActionType.reviseQuotation:
        return 'Revised quotation';
      case AuditActionType.verifyPayment:
        return 'Verified payment';
      case AuditActionType.updateAdvertisement:
        return 'Updated advertisement';
      case AuditActionType.exportVisitors:
        return 'Exported visitor data';
      case AuditActionType.updateReminderSettings:
        return 'Updated reminder settings';
      case AuditActionType.updateBooking:
        return 'Updated booking';
    }
  }
}
