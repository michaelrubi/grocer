import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocer/shared/styles.dart';

var appTheme = ThemeData(
  fontFamily: GoogleFonts.openSans().fontFamily,
  textTheme: TextTheme(
    displayLarge: Txt.h1,
    displayMedium: Txt.h2,
    bodyMedium: Txt.p,
    labelLarge: Txt.label,
    ),
  buttonTheme: const ButtonThemeData(
  ),
  colorScheme: ColorScheme(
    primary: Col.highlight,
    onPrimary: Col.text,
    secondary: Col.noStore,
    onSecondary: Col.text,
    surface: Col.menu,
    onSurface: Col.text,
    background: Col.bg,
    onBackground: Col.text,
    error: Col.error,
    onError: Col.text,
    brightness: Brightness.dark,
  )
);
