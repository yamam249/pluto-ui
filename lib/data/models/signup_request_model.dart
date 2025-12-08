// class SignupRequestModel {
//   String? phone;
//   String? firstName;
//   String? lastName;
//   String? password;
//   String? birthDate;
//   String? idImage;
//   String? profileImage;

//   SignupRequestModel({
//     this.phone,
//     this.firstName,
//     this.lastName,
//     this.password,
//     this.birthDate,
//     this.idImage,
//     this.profileImage,
//   });

//   SignupRequestModel.fromJson(Map<String, dynamic> json) {
//     phone = json['phone'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     password = json['password'];
//     birthDate = json['birth_date'];
//     idImage = json['id_image'];
//     profileImage = json['profile_image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['phone'] = this.phone;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['password'] = this.password;
//     data['birth_date'] = this.birthDate;
//     data['id_image'] = this.idImage;
//     data['profile_image'] = this.profileImage;
//     return data;
//   }
// }

//TODO maybe i will need to make the data types nullable again like the commented one above

class SignupRequestModel {
  // استخدام final للحقول التي يجب أن تُملأ عند الإنشاء
  final String phone;
  final String firstName;
  final String lastName;
  final String password;
  final String birthDate;
  // هذه الحقول يجب أن تحتوي على المسار المحلي للملفات
  final String idImagePath; // تم تغيير الاسم ليكون أوضح
  final String profileImagePath; // تم تغيير الاسم ليكون أوضح

  SignupRequestModel({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.birthDate,
    required this.idImagePath,
    required this.profileImagePath,
  });

  // لا تحتاج دالة fromJson
}
