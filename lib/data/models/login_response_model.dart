class LoginResponseModel {
  final String message;
  final String token;

  LoginResponseModel({required this.message, required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] as String,
      token: json['token'] as String,
    );
  }
}
