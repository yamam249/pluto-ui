import 'package:pluto_ui/data/models/registration_model.dart';

class UpdateRegistrationModel {
  final int id;
  final RegistrationModel booking;
  final String newFromDate;
  final String newToDate;

  UpdateRegistrationModel({
    required this.id,
    required this.booking,
    required this.newFromDate,
    required this.newToDate,
  });

  factory UpdateRegistrationModel.fromJson(Map<String, dynamic> json) {
    return UpdateRegistrationModel(
      id: json['id'],
      booking: RegistrationModel.fromJson(json['booking']),
      newFromDate: json['new_from_date'],
      newToDate: json['new_to_date'],
    );
  }
}
