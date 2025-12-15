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
