import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static final TextStyle monoTextStyle = GoogleFonts.robotoMono();
  static final TextStyle poppinsTextSStyle = GoogleFonts.poppins();

  static final BoxShadow defaultBoxShadow = BoxShadow(
    color: const Color(0x10000000),
    blurRadius: 16,
    offset: const Offset(0, 0),
  );
}
