class LoginRequestModel {
  final String phone;
  final String password;

  // Constructor
  LoginRequestModel({required this.phone, required this.password});

  // Method to convert the Dart object to a JSON Map
  // This is used when sending data to the API (POST request body)
  Map<String, dynamic> toJson() {
    return {'phone': phone, 'password': password};
  }
}
