import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_motor/models/product.dart';
import 'package:inventory_motor/pages/form_update_page.dart';
import 'package:inventory_motor/providers/delete_product_provider.dart';
import 'package:inventory_motor/providers/get_all_product_history_provider.dart';
import 'package:inventory_motor/utils/color.dart';
import 'package:inventory_motor/providers/get_all_product_provider.dart';
import 'package:inventory_motor/utils/status.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemDataCardWidget extends StatelessWidget {
  const ItemDataCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<GetAllProductProvider>(context);
    final productHistoryProvider =
        Provider.of<GetAllProductHistoryProvider>(context);
    final deleteProvider = Provider.of<DeleteProductProvider>(context);
    final getProductProvider =
        Provider.of<GetAllProductProvider>(context, listen: false);

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productProvider.products.isEmpty) {
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
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      );
    }

    if (productProvider.error != null) {
      return Center(child: Text(productProvider.error!));
    }

    final products = productProvider.products;

    return Expanded(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await deleteProvider.deleteProduct(product.id);
              if (deleteProvider.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(deleteProvider.error!)),
                );
              } else {
                getProductProvider.removeProduct(product.id);
                productHistoryProvider.removeProductHistory(product.id);

                getProductProvider.fetchProducts();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produk terhapus')),
                );
              }
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "HAPUS",
                    style: GoogleFonts.poppins(
                      color: SelectColor.kWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
            child: itemGestureDetectorOnClick(context, product, index),
          );
        },
      ),
    );
  }

  GestureDetector itemGestureDetectorOnClick(
      BuildContext context, Product product, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormUpdatePage(product: product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: product.status == Status.masuk
            ? EntryCardWidget(product: product, index: index)
            : ExitCardWidget(product: product, index: index),
      ),
    );
  }
}

class EntryCardWidget extends StatelessWidget {
  final Product product;
  final int index;

  const EntryCardWidget({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SelectColor.kPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: contentCard(product),
    );
  }

  Padding contentCard(Product product) {
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

  Column titleDescriptionStatus(Product product) {
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

  Row status(Product product) {
    return Row(
      children: [
        statusContent(
          Icons.archive,
          'Masuk: ${product.entry}',
          SelectColor.kPrimary,
          Colors.black,
          Colors.black,
          SelectColor.kGreen,
        ),
        const SizedBox(width: 8),
        statusContent(
          Icons.all_inbox,
          'Total: ${product.total}',
          SelectColor.kPrimary,
          Colors.black,
          Colors.black,
          Colors.blue,
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

class ExitCardWidget extends StatelessWidget {
  final Product product;
  final int index;

  const ExitCardWidget({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: contentCard(product),
    );
  }

  Padding contentCard(Product product) {
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

  Column titleDescriptionStatus(Product product) {
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

  Row status(Product product) {
    return Row(
      children: [
        statusContent(
          Icons.outbond,
          'Keluar: ${product.exit}',
          SelectColor.kPrimary,
          SelectColor.kWhite,
          SelectColor.kWhite,
          SelectColor.kRed,
        ),
        const SizedBox(width: 8),
        statusContent(
          Icons.all_inbox,
          'Total: ${product.total}',
          SelectColor.kPrimary,
          SelectColor.kWhite,
          SelectColor.kWhite,
          Colors.blue,
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
