import 'package:flutter/material.dart';
import '../models/item.dart';

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
      _logs.add(
        "[+] ${item.name} ditambah 1 (stok: ${item.stock} ${item.unit})",
      );
    });
  }

  void _useStock(Item item) {
    setState(() {
      if (item.stock > 0) {
        item.stock--;
        _logs.add(
          "[-] ${item.name} dipakai 1 (stok: ${item.stock} ${item.unit})",
        );
      }
    });
  }

  void _resetStock(Item item) {
    setState(() {
      _logs.add("[RESET] ${item.name} direset dari ${item.stock} ke 0");
      item.stock = 0;
    });
  }

  void _setCustomStock(Item item) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Set Stok untuk ${item.name}"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Jumlah stok baru",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? item.stock;
              setState(() {
                _logs.add(
                  "[SET] ${item.name} diubah dari ${item.stock} ke $value",
                );
                item.stock = value;
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
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
                    title: Text("${item.name} (${item.stock} ${item.unit})"),
                    subtitle: Text(
                      "Expired: ${item.expiry.day}/${item.expiry.month}/${item.expiry.year}",
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
                    color: Colors.grey,
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
    );
  }
}
