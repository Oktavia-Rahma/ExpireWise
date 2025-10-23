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
    this.storageLocation = 'Rak Dapur',
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'stock': stock,
      'expiry': expiry.toIso8601String(),
      'unit': unit,
      'minThreshold': minThreshold,
      'storageLocation': storageLocation,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? '',
      stock: json['stock'] ?? 0,
      expiry: DateTime.tryParse(json['expiry'] ?? '') ?? DateTime.now(),
      unit: json['unit'] ?? 'pcs',
      minThreshold: json['minThreshold'] ?? 1,
      storageLocation: json['storageLocation'] ?? 'Rak Dapur',
      lastUpdated:
          DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
    );
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
    super.storageLocation,
    super.lastUpdated,
  });

  @override
  String get info => "${super.info} ${isFrozen ? '(Frozen)' : ''}";
}
