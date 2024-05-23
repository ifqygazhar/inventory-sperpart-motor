import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inventory_motor/providers/get_all_product_history_provider.dart';

import 'package:inventory_motor/widgets/appbar_widget.dart';
import 'package:inventory_motor/widgets/item_data_history_card_widget.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final productProvider =
          Provider.of<GetAllProductHistoryProvider>(context, listen: false);
      productProvider.fetchProductsHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget.myAppBar(
        null,
        'Histori',
      ),
      body: const Padding(
        padding: EdgeInsets.only(
          right: 12,
          left: 12,
          top: 12,
        ),
        child: Column(
          children: [
            ItemDataHistoryCard(),
          ],
        ),
      ),
    );
  }
}
