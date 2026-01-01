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

  // Helper to format dates specifically for your API (d-M-yyyy)
  String _formatDate(DateTime date) => DateFormat('d-M-yyyy').format(date);

  // Convert to Map for Dio's FormData
  Map<String, dynamic> toJson() {
    return {
      "apartment_id": apartmentId.toString(),
      "from_date": _formatDate(fromDate),
      "to_date": _formatDate(toDate),
    };
  }
}
