/// ERD Entity: `service_add_ons`
/// Junction table linking services to their available add-ons.
/// Composite PK: (service_id, add_on_id).
class ServiceAddOn {
  final String serviceId;
  final String addOnId;
  final bool isOptional;
  final double? surcharge;

  const ServiceAddOn({
    required this.serviceId,
    required this.addOnId,
    required this.isOptional,
    this.surcharge,
  });

  factory ServiceAddOn.fromMap(Map<String, dynamic> map) {
    return ServiceAddOn(
      serviceId: map['service_id'] as String,
      addOnId: map['add_on_id'] as String,
      isOptional: map['is_optional'] as bool,
      surcharge: (map['surcharge'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'service_id': serviceId,
      'add_on_id': addOnId,
      'is_optional': isOptional,
      'surcharge': surcharge,
    };
  }

  /// Composite document ID for Firestore
  String get docId => '${serviceId}_$addOnId';
}
