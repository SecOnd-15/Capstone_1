import 'enums.dart';

/// ERD Entity: `add_ons`
/// Optional add-ons: meals, souvenirs, extended tours, transport.
class AddOn {
  final String addOnId;
  final String name;
  final String? description;
  final AddOnCategory? category;
  final UnitLabel unitLabel;
  final double unitPrice;
  final bool isActive;

  const AddOn({
    required this.addOnId,
    required this.name,
    this.description,
    this.category,
    required this.unitLabel,
    required this.unitPrice,
    required this.isActive,
  });

  factory AddOn.fromMap(Map<String, dynamic> map, String docId) {
    return AddOn(
      addOnId: docId,
      name: map['name'] as String,
      description: map['description'] as String?,
      category: map['category'] != null
          ? enumFromString(AddOnCategory.values, map['category'] as String)
          : null,
      unitLabel:
          enumFromString(UnitLabel.values, map['unit_label'] as String),
      unitPrice: (map['unit_price'] as num).toDouble(),
      isActive: map['is_active'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category?.firestoreValue,
      'unit_label': unitLabel.firestoreValue,
      'unit_price': unitPrice,
      'is_active': isActive,
    };
  }

  /// Display-friendly price string
  String get formattedPrice {
    final parts = unitPrice.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write(',');
      buffer.write(parts[i]);
    }
    final label = unitLabel == UnitLabel.perPerson ? '/person' : '/group';
    return '₱$buffer$label';
  }
}
