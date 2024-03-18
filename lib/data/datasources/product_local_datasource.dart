import 'package:sqflite/sqflite.dart';

import '../models/responses/product_response_model.dart';

class ProductLocalDatasource {
  ProductLocalDatasource._init();

  static final ProductLocalDatasource instance = ProductLocalDatasource._init();

  final String tableProduct = 'products';

  static Database? _database;

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProduct (
        id INTEGER PRIMARY KEY,
        productId INTEGER,
        categoryId INTEGER,
        categoryName TEXT,
        name TEXT,
        description TEXT,
        image TEXT,
        price TEXT,
        stock INTEGER,
        status INTEGER,
        isFavorite INTEGER,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('local-dbresto.db');

    return _database!;
  }

  // insert a product data
  Future<void> insertProduct(Product product) async {
    final db = await instance.database;
    await db.insert(
      tableProduct,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // insert list of products
  Future<void> insertProducts(List<Product> products) async {
    final db = await instance.database;
    for (var product in products) {
      await db.insert(
        tableProduct,
        product.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // get all products
  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableProduct);

    return List.generate(
        maps.length, (index) => Product.fromLocalMap(maps[index]));
  }

  // delete all products
  Future<void> deleteAllProducts() async {
    final db = await instance.database;
    await db.delete(tableProduct);
  }
}
