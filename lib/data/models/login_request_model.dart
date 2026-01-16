class LoginRequestModel {
  final String phone;
  final String password;
  final String? fcmToken;

  LoginRequestModel({
    required this.phone,
    required this.password,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'password': password, 'fcm_token': fcmToken};
  }
}
