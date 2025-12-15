import 'package:flutter/material.dart';

// ========= الألوان الأساسية (من الكود الثاني) =========

final Color kFontColorDark = Color(0xFF404F68);
final Color kFontColorLight = Color(0xFFFFFFFF);

final Color kBgMainLight = Color(0xFFF2F2F2);
final Color kBgSidebar = Color(0xFF404F68);
final Color kBgCardLight = Color(0xFFFFFFFF);
final Color kBgActiveLight = Color(0xFF7A859D);

final Color kColorSuccess = Color(0xFF10B981);
final Color kColorDanger = Color(0xFFEF4444);
final Color kColorPending = Color(0xFFF59E0B);

final Color kPrimaryColor = Color(0xFF404F68);

// ========= AppColors (مهم جداً) =========

class AppColors {
  // الخلفية الرئيسية
  static Color bgMain(bool isDark) =>
      isDark ? Colors.black87 : kBgMainLight;

  // الكروت
  static Color bgCard(bool isDark) =>
      isDark ? Colors.grey[900]! : kBgCardLight;

  // لون الخط الأساسي
  static Color fontColor(bool isDark) =>
      isDark ? kFontColorLight : kFontColorDark;

  // لون الخط الثانوي
  static Color subFontColor(bool isDark) =>
      isDark ? Colors.white70 : Colors.grey[700]!;

  // لون التفاعل / العناصر النشطة
  static Color bgActive(bool isDark) =>
      isDark ? Colors.grey[800]! : kBgActiveLight;

  // لون التلميحات
  static Color hintColor(bool isDark) =>
      isDark ? Colors.grey[400]! : Colors.grey[600]!;

  // اللون الأساسي
  static Color primary(bool isDark) => kPrimaryColor;

  // نجاح
  static Color success(bool isDark) => kColorSuccess;

  // خطأ
  static Color danger(bool isDark) => kColorDanger;
}
