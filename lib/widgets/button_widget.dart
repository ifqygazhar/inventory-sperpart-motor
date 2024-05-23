import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_motor/utils/color.dart';

class ButtonWidget {
  static ElevatedButton myButton(
    String title,
    Color backgroundColor,
    Color foregroundColor,
    Function() onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          color: SelectColor.kWhite,
        ),
      ),
    );
  }
}
