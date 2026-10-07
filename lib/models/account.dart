import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// ERD Entity: `accounts`
/// Auth identity + role for RBAC (§1.2, NFR-04).
/// `account_id` mirrors the Supabase Auth user id.
class Account {
  final String accountId;
  final String email;
  final String fullName;
  final AccountRole role;
  final String? phoneNumber;
  final AccountStatus accountStatus;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const Account({
    required this.accountId,
    required this.email,
    required this.fullName,
    required this.role,
    this.phoneNumber,
    required this.accountStatus,
    required this.createdAt,
    this.lastLoginAt,
  });

  /// Firestore document → Account
  factory Account.fromMap(Map<String, dynamic> map, String docId) {
    return Account(
      accountId: docId,
      email: map['email'] as String,
      fullName: map['full_name'] as String,
      role: enumFromString(AccountRole.values, map['role'] as String),
      phoneNumber: map['phone_number'] as String?,
      accountStatus: enumFromString(
        AccountStatus.values,
        map['account_status'] as String,
      ),
      createdAt: (map['created_at'] as Timestamp).toDate(),
      lastLoginAt: map['last_login_at'] != null
          ? (map['last_login_at'] as Timestamp).toDate()
          : null,
    );
  }

  /// Account → Firestore document
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'full_name': fullName,
      'role': role.firestoreValue,
      'phone_number': phoneNumber,
      'account_status': accountStatus.firestoreValue,
      'created_at': Timestamp.fromDate(createdAt),
      'last_login_at':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  Account copyWith({
    String? fullName,
    String? phoneNumber,
    AccountStatus? accountStatus,
    DateTime? lastLoginAt,
  }) {
    return Account(
      accountId: accountId,
      email: email,
      fullName: fullName ?? this.fullName,
      role: role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accountStatus: accountStatus ?? this.accountStatus,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Initials for avatar display
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.substring(0, fullName.length >= 2 ? 2 : 1).toUpperCase();
  }

  bool get isAdmin => role == AccountRole.administrator;
  bool get isActive => accountStatus == AccountStatus.active;
}
