import 'package:flutter/foundation.dart';
import 'package:inventory_motor/data/local/product_db.dart';
import 'package:inventory_motor/models/product.dart';
import 'package:inventory_motor/models/product_history.dart';
import 'package:inventory_motor/providers/get_all_product_history_provider.dart';
import 'package:inventory_motor/providers/get_all_product_provider.dart';

class UpdateProductProvider with ChangeNotifier {
  String? _error;

  String? get error => _error;

  Future<void> updateProduct(
    Product product,
    GetAllProductProvider productProvider,
    GetAllProductHistoryProvider productHistoryProvider,
    ProductHistory productHistory,
  ) async {
    try {
      await ProductDatabase.instance.updateProduct(product, productHistory);
      productProvider.updateProductInList(product);
      productHistoryProvider.updateProductInList(productHistory);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = "Failed to update product: $e";
      notifyListeners();
    }
  }
}
