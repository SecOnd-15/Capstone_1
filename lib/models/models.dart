/// Gran Verde — Model Barrel Export
/// Import this single file to access all ERD-aligned models.
///
/// 19 entities from the ERD (Step 3) + 2 new feature entities = 21 total.
library;

// Shared enumerations
export 'enums.dart';

// Auth & Accounts (ERD 1–2)
export 'account.dart';
export 'visitor_profile.dart';

// Services & Matching Engine (ERD 5–8)
export 'service.dart';
export 'service_attribute.dart';
export 'add_on.dart';
export 'service_add_on.dart';
export 'quotation_rule.dart';

// Inquiries & Tracking (ERD 3–4)
export 'inquiry.dart';
export 'visitor_tracking_record.dart';

// Quotations (ERD 10–13)
export 'quotation.dart';
export 'quotation_item.dart';
export 'quotation_revision.dart';

// Bookings & Payments (ERD 14–15)
export 'booking_record.dart';
export 'payment_proof.dart';

// Calendar & Reminders (ERD 16–17)
export 'calendar_entry.dart';
export 'reminder.dart';

// Feedback (ERD 18)
export 'rating_review.dart';

// Advertisements (ERD 9)
export 'advertisement.dart';

// Audit (ERD 19)
export 'admin_audit_log.dart';

// ── New Features (not in original ERD) ──────────────────────────────

// Gate Pass — QR code for farm entrance verification
export 'gate_pass.dart';

// Transit Tracking — real-time visitor arrival with privacy toggle
export 'visitor_transit_status.dart';

// ── Legacy models (existing, kept for backward compatibility) ───────

// These will be migrated in later phases:
// - experience_model.dart  → replaced by service.dart
// - booking_model.dart     → replaced by booking_record.dart
// - user_session.dart      → replaced by account.dart + auth service
