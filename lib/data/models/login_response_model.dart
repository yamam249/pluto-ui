class LoginResponseModel {
  final String message;
  final String token;

  // Constructor
  LoginResponseModel({required this.message, required this.token});

  // Factory method to create a Dart object from a JSON Map
  // This is used when receiving data from the API (response body)
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] as String,
      token: json['token'] as String,
    );
  }
}
