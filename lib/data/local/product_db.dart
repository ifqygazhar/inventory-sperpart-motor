import 'package:inventory_motor/models/product.dart';
import 'package:inventory_motor/models/product_history.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._init();
  static Database? _database;

  ProductDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE products (
      id TEXT PRIMARY KEY,
      title TEXT,
      date TEXT,
      status TEXT,
      entry INTEGER, 
      exit INTEGER, 
      description TEXT,
      image TEXT,
      total INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE product_history (
      id TEXT PRIMARY KEY,
      product_id TEXT,
      title TEXT,
      date TEXT,
      status TEXT,
      entry INTEGER, 
      exit INTEGER, 
      description TEXT,
      image TEXT,
      FOREIGN KEY (product_id) REFERENCES products(id)
    )
    ''');

    await db.execute('''
    CREATE TABLE pin (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pin INTEGER NOT NULL
    )
    ''');
  }

  Future<void> insertPin(int pin) async {
    final db = await instance.database;
    await db.insert('pin', {'pin': pin});
  }

  Future<int?> getPin() async {
    final db = await instance.database;
    final result = await db.query('pin', limit: 1);
    if (result.isNotEmpty) {
      return result.first['pin'] as int?;
    }
    return null;
  }

  Future<String> insertProduct(Product product) async {
    final db = await instance.database;
    final String id = const Uuid().v4();
    final productWithId = product.copyWith(id: id);

    await db.insert('products', productWithId.toMap());
    return id;
  }

  Future<void> insertProductHistory(ProductHistory productHistory) async {
    final db = await instance.database;
    final String id = const Uuid().v4();
    final productHistoryWithId = productHistory.copyWith(id: id);

    await db.insert('product_history', productHistoryWithId.toMap());
  }

  Future<void> delete(String id) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      await txn
          .delete('product_history', where: 'product_id = ?', whereArgs: [id]);
      await txn.delete('products', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products', orderBy: 'date');

    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<ProductHistory>> getAllProductsHistory() async {
    final db = await instance.database;
    final result = await db.query('product_history', orderBy: 'date');

    return result.map((map) => ProductHistory.fromMap(map)).toList();
  }

  Future<void> updateProduct(
      Product product, ProductHistory productHistory) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      final String id = const Uuid().v4();
      final productWithId =
          productHistory.copyWith(id: id, productId: product.id);
      await txn.insert('product_history', productWithId.toMap());

      await txn.update('products', product.toMap(),
          where: 'id = ?', whereArgs: [product.id]);
    });
  }
}
