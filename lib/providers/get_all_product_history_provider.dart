import 'package:flutter/foundation.dart';
import 'package:inventory_motor/data/local/product_db.dart';
import 'package:inventory_motor/models/product_history.dart';

class GetAllProductHistoryProvider with ChangeNotifier {
  List<ProductHistory> _productsHistory = [];
  bool _isLoading = false;
  String? _error;

  List<ProductHistory> get productsHistory => _productsHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProductsHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _productsHistory = await ProductDatabase.instance.getAllProductsHistory();

      _error = null;
    } catch (e) {
      _error = "Failed to fetch product history: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateProductInList(ProductHistory updatedProduct) {
    int index = _productsHistory
        .indexWhere((product) => product.productId == updatedProduct.productId);
    if (index != -1) {
      _productsHistory[index] = updatedProduct;
      notifyListeners();
    }
  }

  void removeProductHistory(String productId) {
    _productsHistory.removeWhere((product) => product.productId == productId);
    notifyListeners();
  }
}
