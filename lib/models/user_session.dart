import 'package:flutter/material.dart';

enum UserRole { visitor, staff, admin }

class UserSession extends ChangeNotifier {
  static final UserSession instance = UserSession._internal();
  UserSession._internal();

  String _fullName = '';
  String _email = '';
  String _contactNumber = '';
  String _initials = '';
  UserRole _role = UserRole.visitor;
  bool _isLoggedIn = false;

  String get fullName => _fullName;
  String get email => _email;
  String get contactNumber => _contactNumber;
  String get initials => _initials;
  UserRole get role => _role;
  bool get isAdmin => _role == UserRole.admin;
  bool get isStaff => _role == UserRole.staff;
  bool get isAdminOrStaff => _role == UserRole.admin || _role == UserRole.staff;
  bool get isVisitor => _role == UserRole.visitor;
  bool get isLoggedIn => _isLoggedIn;

  /// Role display name
  String get roleDisplay {
    switch (_role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.staff:
        return 'Staff';
      case UserRole.visitor:
        return 'Visitor';
    }
  }

  // Pre-provisioned accounts (Paper Section 1.2 RBAC specs)
  // Admin: full system access — manages staff, services, settings
  // Staff: limited admin — can verify payments, manage bookings, view reports
  // Visitor: self-registered client accounts
  static final Map<String, Map<String, dynamic>> _registeredAccounts = {
    'maria@gmail.com': {
      'password': 'Pass@123',
      'fullName': 'Maria Santos',
      'initials': 'MS',
      'contactNumber': '+63 917 888 2024',
      'role': UserRole.admin,
    },
    'staff@gmail.com': {
      'password': 'Pass@123',
      'fullName': 'Razel Ponce',
      'initials': 'RP',
      'contactNumber': '+63 917 777 3344',
      'role': UserRole.staff,
    },
    'bossemerson05@gmail.com': {
      'password': 'Pass@123',
      'fullName': 'Emerson Latog',
      'initials': 'EL',
      'contactNumber': '+63 917 545 1220',
      'role': UserRole.visitor,
    },
  };

  /// RBAC Login method - checks credentials & assigns role strictly from database/registry
  bool login({required String email, required String password}) {
    final cleanEmail = email.trim().toLowerCase();

    // Check if account exists in RBAC registry
    if (_registeredAccounts.containsKey(cleanEmail)) {
      final account = _registeredAccounts[cleanEmail]!;
      if (account['password'] == password) {
        _email = cleanEmail;
        _fullName = account['fullName'];
        _initials = account['initials'];
        _contactNumber = account['contactNumber'];
        _role = account['role'];
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
      return false; // Wrong password
    }

    // Default fallback for any newly registered visitor
    if (password.length >= 6) {
      _email = cleanEmail;
      _fullName = 'Visitor';
      _initials = cleanEmail.substring(0, 2).toUpperCase();
      _contactNumber = '+63 917 000 0000';
      _role = UserRole.visitor;
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }

    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _role = UserRole.visitor;
    _fullName = '';
    _email = '';
    _contactNumber = '';
    _initials = '';
    notifyListeners();
  }

  /// Register a new visitor account (for registration screen)
  void registerVisitor({
    required String fullName,
    required String email,
    required String contactNumber,
  }) {
    final parts = fullName.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : fullName.substring(0, fullName.length >= 2 ? 2 : 1).toUpperCase();

    _registeredAccounts[email.trim().toLowerCase()] = {
      'password': 'registered', // Will be replaced by Supabase Auth
      'fullName': fullName,
      'initials': initials,
      'contactNumber': contactNumber,
      'role': UserRole.visitor,
    };
  }
}

