import 'package:flutter/foundation.dart';
import 'package:inventory_motor/data/local/product_db.dart';
import 'package:inventory_motor/models/product.dart';
import 'package:inventory_motor/models/product_history.dart';
import 'package:inventory_motor/utils/status.dart';

class AddProductProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> addProduct({
    required String title,
    required DateTime date,
    required Status status,
    required int entry,
    required int exit,
    required String description,
    required String image,
    required int total,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final product = Product(
        id: '',
        title: title,
        date: date,
        status: status,
        entry: entry,
        exit: exit,
        description: description,
        image: image,
        total: total, // Set total pada produk
      );

      final productId = await ProductDatabase.instance.insertProduct(product);

      await addProductHistory(
        productId: productId,
        title: title,
        date: date,
        status: Status.values.firstWhere((e) => e.name == status.name),
        entry: entry,
        exit: exit,
        description: description,
        image: image,
      );

      _error = null;
    } catch (e) {
      _error = 'Failed to add product: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProductHistory({
    required String productId,
    required String title,
    required DateTime date,
    required Status status,
    required int entry,
    required int exit,
    required String description,
    required String image,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final productHistory = ProductHistory(
        id: '', // ID akan di-set di layer database
        productId: productId,
        title: title,
        date: date,
        status: status,
        entry: entry,
        exit: exit,
        description: description,
        image: image,
      );

      await ProductDatabase.instance.insertProductHistory(productHistory);
    } catch (e) {
      _error = 'Failed to add product history: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
