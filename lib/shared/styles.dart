import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

double rem = kIsWeb ? 16.0 : 20.0;
double bdrRad = 6 / 16 * rem;

class Col {
  static Color text = const Color(0xFFE9E9E9);        // #E9E9E9
  static Color highlight = const Color(0xFF5F5F5F);   // #5F5F5F
  static Color menu = const Color(0xFF373737);        // #373737
  static Color field = const Color(0xFF272727);       // #272727
  static Color bg = const Color(0xFF141414);          // #141414
  static Color surface = const Color(0xFF2B2B2B);     // #2B2B2B
  static Color noStore = const Color(0xFF8BC34A);     // #8BC34A
  static Color error = const Color(0xFFBC80BD);       // #BC80BD
}

class Txt {
  static TextStyle h1 = GoogleFonts.robotoSlab(
    color: Col.text,
    fontSize: 1.25 * rem,
    fontWeight: FontWeight.bold,
  );

  static TextStyle h2 = GoogleFonts.openSans(
    color: Col.text,
    fontSize: 1 * rem,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.0225 * rem,
  );

  static TextStyle label = GoogleFonts.openSans(
    color: Col.text,
    fontSize: 0.625 * rem,
  );

  static TextStyle labelBold = GoogleFonts.openSans(
    color: Col.text,
    fontSize: 0.625 * rem,
    fontWeight: FontWeight.bold,
  );

  static TextStyle p = GoogleFonts.openSans(
    color: Col.text,
    fontSize: 1 * rem,
    letterSpacing: 0.02 * rem,
    fontWeight: FontWeight.w600,
  );

  static TextStyle alert = GoogleFonts.openSans(
    color: Col.text,
    fontSize: 0.75 * rem,
    letterSpacing: 0.02 * rem,
    fontWeight: FontWeight.w400,
  );



  static TextStyle pickerForm = GoogleFonts.openSans(
    color: Col.text,
    fontSize: 1 * rem,
    letterSpacing: 0.02 * rem,
    fontWeight: FontWeight.w600,
    background: Paint()..color = Col.field,
  );
}

class Gap {
  static double lrg = 2 * rem;
  static double med = rem;
  static double sml = rem / 2.0;
  static double xs = kIsWeb ? rem / 2.0 : rem / 4.0;
}
