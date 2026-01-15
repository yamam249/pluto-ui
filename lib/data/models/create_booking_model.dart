import 'package:intl/intl.dart';

class CreateBookingModel {
  final int apartmentId;
  final DateTime fromDate;
  final DateTime toDate;

  CreateBookingModel({
    required this.apartmentId,
    required this.fromDate,
    required this.toDate,
  });

  // Helper to format dates
  String _formatDate(DateTime date) => DateFormat('d-M-yyyy').format(date);

  Map<String, dynamic> toJson() {
    return {
      "apartment_id": apartmentId.toString(),
      "from_date": _formatDate(fromDate),
      "to_date": _formatDate(toDate),
    };
  }
}
