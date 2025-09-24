import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemListWidget extends StatelessWidget {
  final List<Item> items;

  const ItemListWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text("Tidak ada data", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final expiryText =
            "${item.expiry.day}/${item.expiry.month}/${item.expiry.year}";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.inventory, color: Colors.indigo),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Stock: ${item.stock} ${item.unit} | Expiry: $expiryText",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // ⬅️ panggil fungsi edit
                    // karena ItemListWidget Stateless, biasanya _editItem ada di parent
                    // jadi disini perlu callback (misalnya onEdit)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Edit ${item.name} diklik")),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${item.name} dihapus")),
                    );
                  },
                ),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Kamu pilih ${item.name}")),
              );
            },
          ),
        );
      },
    );
  }
}
