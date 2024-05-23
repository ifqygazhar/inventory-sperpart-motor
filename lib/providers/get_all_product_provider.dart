import 'package:flutter/foundation.dart';
import 'package:inventory_motor/data/local/product_db.dart';
import 'package:inventory_motor/models/product.dart';

class GetAllProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await ProductDatabase.instance.getAllProducts();

      _error = null;
    } catch (e) {
      _error = "Failed to fetch products: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  void removeProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  void updateProductInList(Product updatedProduct) {
    int index =
        _products.indexWhere((product) => product.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }
}
