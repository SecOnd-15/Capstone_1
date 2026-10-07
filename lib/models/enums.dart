/// Gran Verde — Shared Enumerations
/// All constrained string fields from the ERD Data Dictionary (Step 4).
library;

// ── Account & Auth ──────────────────────────────────────────────────

enum AccountRole { client, staff, administrator }

enum AccountStatus { pendingInspection, active, suspended }

// ── Visitor ─────────────────────────────────────────────────────────

enum VisitorType { solo, couple, family, group, corporate, school }

enum ReferralSource {
  socialMedia,
  website,
  friend,
  eMail,
  advertisement,
  walkIn,
  other,
}

enum PurposeOfVisit {
  education,
  recreation,
  teamBuilding,
  research,
  corporate,
  leisure,
}

// ── Services ────────────────────────────────────────────────────────

enum ServiceCode { kakawLakaw, bahandiSaUma, customizedOptions }

enum AttributeDimension {
  theme,
  activity,
  setting,
  groupFit,
  duration,
  budgetLevel,
  purpose,
}

enum AddOnCategory { meal, souvenir, extendedTour, transport, other }

enum UnitLabel { perPerson, perGroup }

// ── Quotation ───────────────────────────────────────────────────────

enum QuotationRuleType {
  discount,
  validityPeriod,
  paymentTerm,
  fee,
  minimumCharge,
}

enum RuleUnit { percent, fixed, days }

enum QuotationStatus { draft, sent, accepted, superseded, declined }

enum QuotationLineType { basePackage, addOn, discount, fee }

enum RevisionReason {
  initial,
  clientRequest,
  priceChange,
  conditionChange,
  adminCorrection,
}

// ── Inquiry ─────────────────────────────────────────────────────────

enum InquiryStatus { newInquiry, inProgress, quoted, booked, closed }

// ── Booking ─────────────────────────────────────────────────────────

enum BookingStatusEnum { pendingPayment, confirmed, cancelled, completed }

// ── Payment ─────────────────────────────────────────────────────────

enum PaymentProofType { gcashReceipt, bankTransfer }

enum VerificationStatus { pending, approved, rejected }

// ── Calendar & Reminders ────────────────────────────────────────────

enum CalendarEntryStatus { scheduled, confirmed, completed, cancelled }

enum ReminderStatus { pending, sent, cancelled }

// ── Gate Pass (new feature) ─────────────────────────────────────────

enum GatePassScanStatus { notScanned, scanned }

// ── Transit Tracking (new feature) ──────────────────────────────────

enum TransitStatus { notStarted, onTheWay, approaching, arrived }

// ── Admin Audit ─────────────────────────────────────────────────────

enum AuditActionType {
  login,
  updateService,
  createQuotation,
  reviseQuotation,
  verifyPayment,
  updateAdvertisement,
  exportVisitors,
  updateReminderSettings,
  updateBooking,
}

// ── Helper Extensions ───────────────────────────────────────────────

/// Converts an enum to its Firestore-safe snake_case string.
extension EnumToString on Enum {
  String get firestoreValue {
    // Convert camelCase enum name to snake_case
    return name.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}

/// Finds an enum value from a Firestore snake_case string.
T enumFromString<T extends Enum>(List<T> values, String value) {
  // Normalise: remove underscores and compare lowercase
  final normalised = value.replaceAll('_', '').toLowerCase();
  return values.firstWhere(
    (e) => e.name.toLowerCase() == normalised,
    orElse: () => values.first,
  );
}
