import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {

  static ThemeData appThemeData = ThemeData.light().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: kPrimaryColor,
    primaryColorLight: kPrimaryColorLight,
    accentColor: kAccentColor,
    backgroundColor: kBackgroundColor,
    errorColor: kErrorColor,
    textTheme: GoogleFonts.majorMonoDisplayTextTheme(),
  );

}
