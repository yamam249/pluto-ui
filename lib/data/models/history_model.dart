import 'package:pluto_ui/data/models/apartment_model.dart';

class HistoryModel {
  final int id;
  final ApartmentModel apartment;
  final String fromDate;
  final String toDate;
  final String status;

  HistoryModel({
    required this.id,
    required this.apartment,
    required this.fromDate,
    required this.toDate,
    required this.status,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      // We reuse your existing ApartmentModel.fromJson here
      apartment: ApartmentModel.fromJson(json['apartment']),
      fromDate: json['from_date'],
      toDate: json['to_date'],
      status: json['status'],
    );
  }
}
