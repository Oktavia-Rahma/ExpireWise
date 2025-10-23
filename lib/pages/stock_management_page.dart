import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/item.dart';
import 'item_detail_page.dart';

class StockManagementPage extends StatefulWidget {
  final List<Item> items;
  const StockManagementPage({super.key, required this.items});

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  String? lastAddedItem;
  String? lastUpdatedTime;
  int? totalItems;

  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _loadStockLog();
    _loadItems();
    _loadSortPreference();
  }

  Future<void> _saveStockLog(Item item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastAddedItem', item.name);
    String formattedDate = DateFormat(
      'dd MMM yyyy – kk:mm',
    ).format(DateTime.now());
    await prefs.setString('lastUpdatedTime', formattedDate);
    int total = prefs.getInt('totalItems') ?? 0;
    await prefs.setInt('totalItems', total + 1);
  }

  Future<void> _loadStockLog() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastAddedItem = prefs.getString('lastAddedItem');
      lastUpdatedTime = prefs.getString('lastUpdatedTime');
      totalItems = prefs.getInt('totalItems') ?? 0;
    });
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonData = jsonEncode(
      widget.items.map((item) => item.toJson()).toList(),
    );
    await prefs.setString('savedItems', jsonData);
    await _updateStorageData();
  }

  Future<void> _updateStorageData() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, int> storageCounts = {};

    for (var item in widget.items) {
      storageCounts[item.storageLocation] =
          (storageCounts[item.storageLocation] ?? 0) + 1;
    }

    await prefs.setString('storageOverview', jsonEncode(storageCounts));
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString('savedItems');
    if (jsonData != null) {
      final List<dynamic> decodedData = jsonDecode(jsonData);
      setState(() {
        widget.items
          ..clear()
          ..addAll(decodedData.map((data) => Item.fromJson(data)));
      });
    }
  }

  Future<void> _saveSortPreference(String sortBy) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortBy', sortBy);
  }

  Future<void> _loadSortPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sortBy = prefs.getString('sortBy') ?? 'name';
    });
  }

  void _addStock(Item item) async {
    setState(() {
      item.stock++;
      item.lastUpdated = DateTime.now();
    });
    await _saveStockLog(item);
    _saveItems();
    _showQuickBubble("✅ ${item.name} +1 stok");
  }

  void _useStock(Item item) {
    setState(() {
      if (item.stock > 0) {
        item.stock--;
        item.lastUpdated = DateTime.now();
        _saveItems();
        _showQuickBubble("⚠️ ${item.name} -1 stok");
      }
    });
  }

  void _resetStock(Item item) {
    setState(() {
      item.stock = 0;
      item.lastUpdated = DateTime.now();
      _saveItems();
      _showQuickBubble("♻️ ${item.name} direset ke 0");
    });
  }

  void _setCustomStock(Item item) {
    TextEditingController nameController = TextEditingController(
      text: item.name,
    );
    TextEditingController stockController = TextEditingController(
      text: item.stock.toString(),
    );
    TextEditingController expiryController = TextEditingController(
      text: item.expiry.toIso8601String().split('T').first,
    );
    TextEditingController thresholdController = TextEditingController(
      text: item.minThreshold.toString(),
    );
    String selectedUnit = item.unit;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Barang"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Barang"),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Stok"),
              ),
              TextField(
                controller: expiryController,
                decoration: const InputDecoration(
                  labelText: "Kadaluarsa (YYYY-MM-DD)",
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                items: ["pcs", "kg", "liter", "pack", "botol", "butir"]
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (val) => selectedUnit = val ?? "pcs",
                decoration: const InputDecoration(labelText: "Unit"),
              ),
              TextField(
                controller: thresholdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Minimum Threshold",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item.name = nameController.text;
                item.stock = int.tryParse(stockController.text) ?? item.stock;
                item.expiry =
                    DateTime.tryParse(expiryController.text) ?? item.expiry;
                item.unit = selectedUnit;
                item.minThreshold =
                    int.tryParse(thresholdController.text) ?? item.minThreshold;
                item.lastUpdated = DateTime.now();
              });
              _saveItems();
              Navigator.pop(context);
              _showQuickBubble("✏️ ${item.name} diperbarui");
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _addNewItem() {
    final nameController = TextEditingController();
    final stockController = TextEditingController();
    final expiryController = TextEditingController();
    String selectedUnit = "pcs";
    final thresholdController = TextEditingController(text: "1");
    String selectedLocation = "Rak Dapur";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Barang"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Barang"),
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: "Stok"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: expiryController,
                decoration: const InputDecoration(
                  labelText: "Kadaluarsa (YYYY-MM-DD)",
                ),
                keyboardType: TextInputType.datetime,
              ),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                items: ["pcs", "kg", "liter", "pack", "botol", "butir"]
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (val) => selectedUnit = val ?? "pcs",
                decoration: const InputDecoration(labelText: "Unit"),
              ),
              TextField(
                controller: thresholdController,
                decoration: const InputDecoration(
                  labelText: "Minimum Threshold",
                ),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: selectedLocation,
                items:
                    [
                          "Kulkas",
                          "Freezer",
                          "Rak Dapur",
                          "Pantry",
                          "Lemari",
                          "Lainnya",
                        ]
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                onChanged: (val) => selectedLocation = val ?? "Rak Dapur",
                decoration: const InputDecoration(
                  labelText: "Lokasi Penyimpanan",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                DateTime parsedExpiry = DateFormat(
                  'yyyy-MM-dd',
                ).parseStrict(expiryController.text);
                setState(() {
                  final newItem = Item(
                    name: nameController.text,
                    stock: int.tryParse(stockController.text) ?? 0,
                    expiry: parsedExpiry,
                    unit: selectedUnit,
                    minThreshold: int.tryParse(thresholdController.text) ?? 1,
                    storageLocation: selectedLocation,
                    lastUpdated: DateTime.now(),
                  );
                  widget.items.add(newItem);
                });
                _saveItems();
                Navigator.pop(context);
                _showQuickBubble("Barang baru telah ditambahkan");
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Format tanggal salah! Gunakan YYYY-MM-DD'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
  }

  void _showQuickBubble(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _AnimatedQuickBubble(message: message);
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3)).then((_) {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock Management")),
      body: Column(
        children: [
          if (lastAddedItem != null)
            Container(
              color: const Color.fromARGB(255, 215, 189, 255),
              height: 32,
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "🆕 Barang terakhir: $lastAddedItem   |   ⏰ Update terakhir: $lastUpdatedTime   |   📦 Total item: $totalItems",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4B3869),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Urutkan berdasarkan:",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Nama')),
                    DropdownMenuItem(
                      value: 'expiry',
                      child: Text('Kadaluarsa'),
                    ),
                    DropdownMenuItem(
                      value: 'stock',
                      child: Text('Stok Terbanyak'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sortBy = value);
                      _saveSortPreference(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final sortedItems = [...widget.items];
                sortedItems.sort((a, b) {
                  switch (_sortBy) {
                    case 'expiry':
                      return a.expiry.compareTo(b.expiry);
                    case 'stock':
                      return b.stock.compareTo(a.stock);
                    default:
                      return a.name.compareTo(b.name);
                  }
                });
                final item = sortedItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      "${item.name}: ${item.stock} ${item.unit}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expired: ${DateFormat('d MMM yyyy').format(item.expiry)}",
                        ),
                        Text("Last updated: ${_formatTime(item.lastUpdated)}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () => _addStock(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          onPressed: () => _useStock(item),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: Color.fromARGB(255, 255, 184, 78),
                          ),
                          onPressed: () => _resetStock(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _setCustomStock(item),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailPage(item: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _AnimatedQuickBubble extends StatefulWidget {
  final String message;
  const _AnimatedQuickBubble({required this.message});

  @override
  State<_AnimatedQuickBubble> createState() => _AnimatedQuickBubbleState();
}

class _AnimatedQuickBubbleState extends State<_AnimatedQuickBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  widget.message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
