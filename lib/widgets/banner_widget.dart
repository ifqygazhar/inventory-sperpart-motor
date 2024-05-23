import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_motor/utils/color.dart';

class BannerWidget {
  static Widget myBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: SelectColor.kPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 14,
          right: 12,
          top: 14,
          bottom: 14,
        ),
        child: Row(
          children: [
            Container(
              width: 89,
              height: 89,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: const DecorationImage(
                  image: AssetImage("assets/banner-mppl.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              "Merekap Dengan\nMudah Menggunakan\nAplikasi Inventory",
              style: GoogleFonts.poppins(
                color: SelectColor.kWhite,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
