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
  final List<String> _logs = [];

  void _addStock(Item item) {
    setState(() {
      item.stock++;
      item.lastUpdated = DateTime.now();
      _logs.add("[+] ${item.name} ditambah 1 (${item.stock} ${item.unit})");
    });
  }

  void _useStock(Item item) {
    setState(() {
      if (item.stock > 0) {
        item.stock--;
        item.lastUpdated = DateTime.now();
        _logs.add("[-] ${item.name} dipakai 1 (${item.stock} ${item.unit})");
      }
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
                  labelText: "Kadaluwarsa (YYYY-MM-DD)",
                ),
              ),
              DropdownButtonFormField<String>(
                initialValue: selectedUnit,
                decoration: const InputDecoration(labelText: "Unit"),
                items: ["pcs", "kg", "liter", "butir", "pack"]
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedUnit = value;
                },
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

                _logs.add(
                  "[✏️] ${item.name} diperbarui jadi ${item.stock} ${item.unit}",
                );
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _resetStock(Item item) {
    setState(() {
      _logs.add("[RESET] ${item.name} direset dari ${item.stock} ke 0");
      item.stock = 0;
      item.lastUpdated = DateTime.now();
    });
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
                initialValue: selectedUnit,
                items: ["pcs", "kg", "liter", "pack", "botol", "butir"]
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (val) {
                  selectedUnit = val ?? "pcs";
                },
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
                initialValue: selectedLocation,
                items:
                    [
                          "Kulkas",
                          "Freezer",
                          "Rak Dapur",
                          "Pantry",
                          "Lemari",
                          "Lainnya",
                          "Rak Bumbu",
                          "Rak Sayur",
                          "Rak Buah",
                          "Rak Minuman",
                          "Rak Snack",
                          "Rak Bahan Kue",
                        ]
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                onChanged: (val) {
                  selectedLocation = val ?? "Rak Dapur";
                },
                decoration: const InputDecoration(
                  labelText: "Lokasi Penyimpanan",
                ),
              ),
              // Dropdown Lokasi
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
                widget.items.add(
                  Item(
                    name: nameController.text,
                    stock: int.tryParse(stockController.text) ?? 0,
                    expiry:
                        DateTime.tryParse(expiryController.text) ??
                        DateTime.now().add(const Duration(days: 7)),
                    unit: selectedUnit,
                    minThreshold: int.tryParse(thresholdController.text) ?? 1,
                    storageLocation: selectedLocation, // Lokasi Penyimpanan
                    lastUpdated: DateTime.now(),
                  ),
                );
                _logs.add("[ADD] ${nameController.text} ditambah ke stok");
              });
              Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock Management")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
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
                          "Expired: ${DateFormat('d MMMM yyyy', 'id_ID').format(item.expiry)}",
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
                          icon: const Icon(Icons.refresh, color: Colors.orange),
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
          const Divider(),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) => ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.history,
                    size: 18,
                    color: Color.fromARGB(255, 255, 22, 216),
                  ),
                  title: Text(
                    _logs[index],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
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
