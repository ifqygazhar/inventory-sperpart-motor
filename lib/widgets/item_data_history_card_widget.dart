import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_motor/models/product_history.dart';
import 'package:inventory_motor/providers/get_all_product_history_provider.dart';
import 'package:inventory_motor/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemDataHistoryCard extends StatelessWidget {
  const ItemDataHistoryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productHistoryProvider =
        Provider.of<GetAllProductHistoryProvider>(context);

    if (productHistoryProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productHistoryProvider.productsHistory.isEmpty) {
      return Center(
          child: Column(
        children: [
          SvgPicture.asset(
            'assets/empty.svg',
            width: 140,
            height: 140,
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada produk silahkan tambahkan',
            style: GoogleFonts.poppins(
              color: SelectColor.kPrimary,
              fontSize: 15,
            ),
          )
        ],
      ));
    }

    if (productHistoryProvider.error != null) {
      return Center(child: Text(productHistoryProvider.error!));
    }

    final products = productHistoryProvider.productsHistory;

    return Expanded(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return item(context, product, index);
        },
      ),
    );
  }

  Padding item(BuildContext context, ProductHistory product, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: index == 0 ? SelectColor.kPrimary : Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: contentCard(product),
      ),
    );
  }

  Padding contentCard(ProductHistory product) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(product.image)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(child: titleDescriptionStatus(product)),
        ],
      ),
    );
  }

  Column titleDescriptionStatus(ProductHistory product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: GoogleFonts.poppins(
            color: SelectColor.kWhite,
            fontSize: 17,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          product.description,
          style: GoogleFonts.poppins(
            color: SelectColor.kWhite,
            fontSize: 12,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        const SizedBox(
          height: 8,
        ),
        status(product),
      ],
    );
  }

  Row status(ProductHistory product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        product.status.name == "masuk"
            ? statusContent(
                Icons.archive,
                product.status.name.toString(),
                SelectColor.kPrimary,
                Colors.black,
                Colors.black,
                SelectColor.kGreen,
              )
            : statusContent(
                Icons.outbond,
                product.status.name.toString(),
                SelectColor.kPrimary,
                SelectColor.kWhite,
                SelectColor.kWhite,
                SelectColor.kRed,
              ),
        Text(
          DateFormat("EEEE, d MMMM yyyy", "id_ID").format(product.date),
          style: GoogleFonts.poppins(
            color: SelectColor.kWhite,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Container statusContent(IconData icon, String text, Color colorCard,
      Color colorIcon, Color colorText, Color colorStatus) {
    return Container(
      decoration: BoxDecoration(
        color: colorCard,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          statusCard(colorStatus, icon, colorIcon, text, colorText),
        ],
      ),
    );
  }

  Container statusCard(Color colorStatus, IconData icon, Color colorIcon,
      String count, Color colorText) {
    return Container(
      width: 98,
      height: 30,
      decoration: BoxDecoration(
        color: colorStatus,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: colorIcon,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            count,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: colorText,
            ),
          ),
        ],
      ),
    );
  }
}
