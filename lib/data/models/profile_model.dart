import 'package:pluto_ui/constants/strings.dart';

class ProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String birthDate;
  final String profileImage;
  final String idImage;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthDate,
    required this.profileImage,
    required this.idImage,
  });

  String get profileImageUrl {
    return profileImage.replaceFirst(
      'http://127.0.0.1:8000',
      'http://$localIp:8000',
    );
  }

  String get idImageUrl {
    return idImage.replaceFirst(
      'http://127.0.0.1:8000',
      'http://$localIp:8000',
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      birthDate: json['birth_date'],
      profileImage: json['profile_image'],
      idImage: json['id_image'],
    );
  }
}
