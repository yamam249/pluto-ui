import 'package:flutter/material.dart';

class AppColors {
  // 🚨 1. المتغيرات القديمة (للتوافق مع الكود القديم)
  static const Color kFontColorDark = Color(0xFF404F68); // darkBlue / navyBlue
  static const Color kFontColorLight = Color(0xFFffffff); // pureWhite
  static const Color kBgMain = Color(0xFFF2F2F2); // lightGrey
  static const Color kBgCard = Color(0xFFffffff); // pureWhite
  static const Color kBgActive = Color(0xFF7A859D); // slateBlue
  static const Color kColorSuccess = Color(0xFF10B981); // emeraldGreen
  static const Color kColorDanger = Color(0xFFEF4444); // brightRed
  static const Color kPrimaryColor = kFontColorDark;

  // 2. الألوان الأساسية الجديدة (للتصميم الذي يدعم isDark)
  static const Color primaryBase = Color(0xFF404F68);
  static const Color lightBase = Color(0xFFFFFFFF);
  static const Color activeBase = Color(0xFF333333); // 🚨 تم تعريف activeBase هنا

  // 3. الدوال التي تستخدم isDark
  static Color bgMain(bool isDark) => isDark ? const Color(0xFF121212) : kBgMain;
  static Color bgCard(bool isDark) => isDark ? const Color(0xFF1E1E1E) : kBgCard;
  static Color bgActive(bool isDark) => isDark ? activeBase : kBgActive;

  static Color fontColor(bool isDark) => isDark ? lightBase : primaryBase;
  static Color subFontColor(bool isDark) => isDark ? const Color(0xFFAAAAAA) : const Color(0xFF666666);
  static Color hintColor(bool isDark) => isDark ? const Color(0xFF757575) : const Color(0xFF9E9E9E);
  static Color primary(bool isDark) => primaryBase;
  static Color danger(bool isDark) => kColorDanger;
}