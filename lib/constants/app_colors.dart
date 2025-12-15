import 'package:flutter/material.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode.replaceAll('#', '0xff')));
}

final Color kFontColorDark = hexToColor("#404F68"); // darkBlue / navyBlue
final Color kFontColorLight = hexToColor("#ffffff"); // pureWhite
final Color kBgMain = hexToColor("#F2F2F2"); // lightGrey
final Color kBgSidebar = hexToColor("#404F68"); // darkBlue / navyBlue
final Color kBgCard = hexToColor("#ffffff"); // pureWhite
final Color kBgActive = hexToColor("#7A859D"); // slateBlue
final Color kColorSuccess = hexToColor("#10B981"); // emeraldGreen
final Color kColorDanger = hexToColor("#EF4444"); // brightRed
final Color kColorPending = hexToColor("#F59E0B"); // amberYellow
final Color kPrimaryColor = kFontColorDark;
