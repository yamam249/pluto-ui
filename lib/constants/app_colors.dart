
import 'package:flutter/material.dart';
Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode.replaceAll('#', '0xff')));
}


final Color kFontColorDark = hexToColor("#404F68");
final Color kFontColorLight = hexToColor("#ffffff");
final Color kBgMain = hexToColor("#F2F2F2");
final Color kBgSidebar = hexToColor("#404F68");
final Color kBgCard = hexToColor("#ffffff");
final Color kBgActive = hexToColor("#7A859D");
final Color kColorSuccess = hexToColor("#10B981");
final Color kColorDanger = hexToColor("#EF4444");
final Color kColorPending = hexToColor("#F59E0B");
final Color kPrimaryColor = kFontColorDark;