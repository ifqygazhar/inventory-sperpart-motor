import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/color.dart';

class AppbarWidget {
  const AppbarWidget(this.icon, this.title);
  final List<Widget>? icon;
  final String title;

  static AppBar myAppBar(icon, title) {
    return AppBar(
      backgroundColor: SelectColor.kPrimary,
      foregroundColor: SelectColor.kWhite,
      actions: icon,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: SelectColor.kWhite,
        ),
      ),
    );
  }
}
