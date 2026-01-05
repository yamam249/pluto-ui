import 'package:pluto_ui/data/models/profile_model.dart';
import 'package:pluto_ui/data/models/apartment_model.dart';

class RegistrationModel {
  final int id;
  final ProfileModel user;
  final ApartmentModel apartment;
  final String fromDate;
  final String toDate;
  final String status;

  RegistrationModel({
    required this.id,
    required this.user,
    required this.apartment,
    required this.fromDate,
    required this.toDate,
    required this.status,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      id: json['id'],
      user: ProfileModel.fromJson(json['user']),
      apartment: ApartmentModel.fromJson(json['apartment']),
      fromDate: json['from_date'],
      toDate: json['to_date'],
      status: json['status'],
    );
  }
}
