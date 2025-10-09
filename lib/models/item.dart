// lib/models/item.dart
class Item {
  String name;
  int stock;
  DateTime expiry;
  String unit;
  int minThreshold;
  String storageLocation;
  DateTime lastUpdated;

  Item({
    required this.name,
    required this.stock,
    required this.expiry,
    this.unit = 'pcs',
    this.minThreshold = 1,
    this.storageLocation = 'Rak Dapur', // default sehingga tidak wajib
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  String get info =>
      "$name ($stock $unit), Expiry: ${expiry.day}/${expiry.month}/${expiry.year}, "
      "Location: $storageLocation, Last Updated: ${_formatTime(lastUpdated)}";

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return "$h:$m:$s";
  }
}

class FoodItem extends Item {
  final bool isFrozen;

  FoodItem({
    required super.name,
    required super.stock,
    required super.expiry,
    super.unit,
    super.minThreshold = 2,
    this.isFrozen = false,
    super.storageLocation, // default juga di sini
    super.lastUpdated,
  });

  @override
  String get info => "${super.info} ${isFrozen ? '(Frozen)' : ''}";
}
