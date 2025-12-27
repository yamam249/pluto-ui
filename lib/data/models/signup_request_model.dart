class SignupRequestModel {
  final String phone;
  final String firstName;
  final String lastName;
  final String password;
  final String birthDate;

  final String idImagePath;
  final String profileImagePath;

  SignupRequestModel({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.birthDate,
    required this.idImagePath,
    required this.profileImagePath,
  });
}
