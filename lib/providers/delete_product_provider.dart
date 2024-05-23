import 'package:flutter/foundation.dart';
import 'package:inventory_motor/data/local/product_db.dart';

class DeleteProductProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> deleteProduct(String productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ProductDatabase.instance.delete(productId);
    } catch (e) {
      _error = 'Failed to delete product: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
