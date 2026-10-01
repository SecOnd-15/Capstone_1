import 'experience_model.dart';

enum BookingStatus { upcoming, past, cancelled }

class Booking {
  final String id;
  final Experience experience;
  final String date;
  final int guests;
  final double totalPrice;
  final BookingStatus status;
  final String bookingRef;

  const Booking({
    required this.id,
    required this.experience,
    required this.date,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.bookingRef,
  });
}

class BookingData {
  BookingData._();

  static final List<Booking> sample = [
    Booking(
      id: 'bk_001',
      experience: ExperienceData.all[0], // Cacao Plantation Tour
      date: 'Dec 22, 2024',
      guests: 2,
      totalPrice: 1700,
      status: BookingStatus.upcoming,
      bookingRef: 'GV-2024-001',
    ),
    Booking(
      id: 'bk_002',
      experience: ExperienceData.all[1], // Chocolate Making Workshop
      date: 'Dec 15, 2024',
      guests: 1,
      totalPrice: 1200,
      status: BookingStatus.past,
      bookingRef: 'GV-2024-002',
    ),
    Booking(
      id: 'bk_003',
      experience: ExperienceData.all[4], // Coffee & Cacao Tasting
      date: 'Dec 10, 2024',
      guests: 3,
      totalPrice: 1950,
      status: BookingStatus.cancelled,
      bookingRef: 'GV-2024-003',
    ),
  ];
}
