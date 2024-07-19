import 'package:flutter/material.dart';

import 'package:inventory_motor/pages/pin_page.dart';
import 'package:inventory_motor/providers/add_product_provider.dart';
import 'package:inventory_motor/providers/delete_product_provider.dart';
import 'package:inventory_motor/providers/get_all_product_history_provider.dart';
import 'package:inventory_motor/providers/get_all_product_provider.dart';
import 'package:inventory_motor/providers/update_product_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddProductProvider()),
        ChangeNotifierProvider(create: (_) => GetAllProductProvider()),
        ChangeNotifierProvider(create: (_) => DeleteProductProvider()),
        ChangeNotifierProvider(create: (_) => UpdateProductProvider()),
        ChangeNotifierProvider(create: (_) => GetAllProductHistoryProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PinPage(),
      ),
    );
  }
}
