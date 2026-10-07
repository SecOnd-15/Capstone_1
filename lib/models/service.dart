import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// ERD Entity: `services`
/// The three offerings + rates/inclusions/duration/group limits/availability.
class Service {
  final String serviceId;
  final ServiceCode serviceCode;
  final String name;
  final String description;
  final double baseRate;
  final int durationHours;
  final int minGroupSize;
  final int maxGroupSize;
  final String availabilitySchedule;
  final List<String> inclusions;
  final String? termsConditions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Service({
    required this.serviceId,
    required this.serviceCode,
    required this.name,
    required this.description,
    required this.baseRate,
    required this.durationHours,
    required this.minGroupSize,
    required this.maxGroupSize,
    required this.availabilitySchedule,
    required this.inclusions,
    this.termsConditions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromMap(Map<String, dynamic> map, String docId) {
    return Service(
      serviceId: docId,
      serviceCode:
          enumFromString(ServiceCode.values, map['service_code'] as String),
      name: map['name'] as String,
      description: map['description'] as String,
      baseRate: (map['base_rate'] as num).toDouble(),
      durationHours: map['duration_hours'] as int,
      minGroupSize: map['min_group_size'] as int,
      maxGroupSize: map['max_group_size'] as int,
      availabilitySchedule: map['availability_schedule'] as String,
      inclusions: List<String>.from(map['inclusions'] ?? []),
      termsConditions: map['terms_conditions'] as String?,
      isActive: map['is_active'] as bool,
      createdAt: (map['created_at'] as Timestamp).toDate(),
      updatedAt: (map['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'service_code': serviceCode.firestoreValue,
      'name': name,
      'description': description,
      'base_rate': baseRate,
      'duration_hours': durationHours,
      'min_group_size': minGroupSize,
      'max_group_size': maxGroupSize,
      'availability_schedule': availabilitySchedule,
      'inclusions': inclusions,
      'terms_conditions': termsConditions,
      'is_active': isActive,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  Service copyWith({
    String? name,
    String? description,
    double? baseRate,
    int? durationHours,
    int? minGroupSize,
    int? maxGroupSize,
    String? availabilitySchedule,
    List<String>? inclusions,
    String? termsConditions,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return Service(
      serviceId: serviceId,
      serviceCode: serviceCode,
      name: name ?? this.name,
      description: description ?? this.description,
      baseRate: baseRate ?? this.baseRate,
      durationHours: durationHours ?? this.durationHours,
      minGroupSize: minGroupSize ?? this.minGroupSize,
      maxGroupSize: maxGroupSize ?? this.maxGroupSize,
      availabilitySchedule: availabilitySchedule ?? this.availabilitySchedule,
      inclusions: inclusions ?? this.inclusions,
      termsConditions: termsConditions ?? this.termsConditions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Display-friendly price string (Philippine Peso)
  String get formattedRate {
    final parts = baseRate.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write(',');
      buffer.write(parts[i]);
    }
    return '₱$buffer';
  }
}
