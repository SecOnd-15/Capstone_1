import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// ERD Entity: `quotation_rules`
/// Discounts, validity periods, payment terms, fees, minimum charges.
/// Rules applied by the quotation computation engine (UC-29).
class QuotationRule {
  final String ruleId;
  final String name;
  final QuotationRuleType ruleType;
  final double? value;
  final RuleUnit? unit;
  final String? appliesToServiceId;
  final String? appliesToAddOnId;
  final DateTime? validFrom;
  final DateTime? validTo;
  final String? termsText;
  final bool isActive;

  const QuotationRule({
    required this.ruleId,
    required this.name,
    required this.ruleType,
    this.value,
    this.unit,
    this.appliesToServiceId,
    this.appliesToAddOnId,
    this.validFrom,
    this.validTo,
    this.termsText,
    required this.isActive,
  });

  factory QuotationRule.fromMap(Map<String, dynamic> map, String docId) {
    return QuotationRule(
      ruleId: docId,
      name: map['name'] as String,
      ruleType: enumFromString(
          QuotationRuleType.values, map['rule_type'] as String),
      value: (map['value'] as num?)?.toDouble(),
      unit: map['unit'] != null
          ? enumFromString(RuleUnit.values, map['unit'] as String)
          : null,
      appliesToServiceId: map['applies_to_service_id'] as String?,
      appliesToAddOnId: map['applies_to_add_on_id'] as String?,
      validFrom: map['valid_from'] != null
          ? (map['valid_from'] as Timestamp).toDate()
          : null,
      validTo: map['valid_to'] != null
          ? (map['valid_to'] as Timestamp).toDate()
          : null,
      termsText: map['terms_text'] as String?,
      isActive: map['is_active'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rule_type': ruleType.firestoreValue,
      'value': value,
      'unit': unit?.firestoreValue,
      'applies_to_service_id': appliesToServiceId,
      'applies_to_add_on_id': appliesToAddOnId,
      'valid_from':
          validFrom != null ? Timestamp.fromDate(validFrom!) : null,
      'valid_to': validTo != null ? Timestamp.fromDate(validTo!) : null,
      'terms_text': termsText,
      'is_active': isActive,
    };
  }

  /// Whether this rule is currently effective
  bool get isCurrentlyValid {
    if (!isActive) return false;
    final now = DateTime.now();
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validTo != null && now.isAfter(validTo!)) return false;
    return true;
  }
}
