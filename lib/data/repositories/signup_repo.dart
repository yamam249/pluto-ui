import 'package:pluto_ui/data/models/signup_request_model.dart';
import 'package:pluto_ui/data/web_services/signup_api.dart';

class SignupRepo {
  final SignupApi signupApi;

  SignupRepo(this.signupApi);

  Future<dynamic> createNewUser(SignupRequestModel user) async {
    return await signupApi.createNewUser(user);
  }
}
