class Item {
  String name; // Nama barang
  int stock; // Jumlah stok
  DateTime expiry; // Tanggal kadaluarsa
  String unit; // Satuan (pcs, kg, liter, dll)
  int minThreshold; // Batas minimum untuk warning
  DateTime lastUpdated; // Timestamp update terakhir

  Item({
    required this.name,
    required this.stock,
    required this.expiry,
    this.unit = "pcs",
    this.minThreshold = 1,
  }) : lastUpdated = DateTime.now();

  String? get info => null;

  void updateStock(int newStock, {String action = ""}) {
    stock = newStock;
  }
}

// Inheritance & Polymorphism
class FoodItem extends Item {
  final bool isFrozen;

  FoodItem({
    required String name,
    required int stock,
    required DateTime expiry,
    String unit = "pcs",
    int minThreshold = 2,
    this.isFrozen = false,
  }) : super(
         name: name,
         stock: stock,
         expiry: expiry,
         unit: unit,
         minThreshold: minThreshold,
       );
}
