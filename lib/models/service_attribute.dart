import 'enums.dart';

/// ERD Entity: `service_attributes`
/// Feature vectors for cosine similarity matching (§2.2.2.1).
/// Each row is one dimension of a service's feature vector.
class ServiceAttribute {
  final String attributeId;
  final String serviceId;
  final AttributeDimension dimension;
  final String attributeValue;
  final double weight;

  const ServiceAttribute({
    required this.attributeId,
    required this.serviceId,
    required this.dimension,
    required this.attributeValue,
    required this.weight,
  });

  factory ServiceAttribute.fromMap(Map<String, dynamic> map, String docId) {
    return ServiceAttribute(
      attributeId: docId,
      serviceId: map['service_id'] as String,
      dimension: enumFromString(
          AttributeDimension.values, map['dimension'] as String),
      attributeValue: map['attribute_value'] as String,
      weight: (map['weight'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'service_id': serviceId,
      'dimension': dimension.firestoreValue,
      'attribute_value': attributeValue,
      'weight': weight,
    };
  }
}
