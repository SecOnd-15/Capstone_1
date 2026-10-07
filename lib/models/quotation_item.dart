import 'enums.dart';

/// ERD Entity: `quotation_items`
/// Line items: base package, add-ons, discounts, fees.
/// Each quotation has 1:N items forming the itemised breakdown.
class QuotationItem {
  final String quotationItemId;
  final String quotationId;
  final QuotationLineType lineType;
  final String? serviceId;
  final String? addOnId;
  final String description;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final int sortOrder;

  const QuotationItem({
    required this.quotationItemId,
    required this.quotationId,
    required this.lineType,
    this.serviceId,
    this.addOnId,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.sortOrder,
  });

  factory QuotationItem.fromMap(Map<String, dynamic> map, String docId) {
    return QuotationItem(
      quotationItemId: docId,
      quotationId: map['quotation_id'] as String,
      lineType: enumFromString(
          QuotationLineType.values, map['line_type'] as String),
      serviceId: map['service_id'] as String?,
      addOnId: map['add_on_id'] as String?,
      description: map['description'] as String,
      quantity: map['quantity'] as int,
      unitPrice: (map['unit_price'] as num).toDouble(),
      lineTotal: (map['line_total'] as num).toDouble(),
      sortOrder: map['sort_order'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quotation_id': quotationId,
      'line_type': lineType.firestoreValue,
      'service_id': serviceId,
      'add_on_id': addOnId,
      'description': description,
      'quantity': quantity,
      'unit_price': unitPrice,
      'line_total': lineTotal,
      'sort_order': sortOrder,
    };
  }

  /// Display-friendly line total
  String get formattedLineTotal {
    final isNegative = lineTotal < 0;
    final abs = lineTotal.abs();
    final parts = abs.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    return '${isNegative ? "-" : ""}₱$buffer.${parts[1]}';
  }
}
