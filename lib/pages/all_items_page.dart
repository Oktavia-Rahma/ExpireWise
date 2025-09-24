import 'package:flutter/material.dart';
import '../models/item.dart';
import 'detail_page.dart';

class AllItemsPage extends StatelessWidget {
  final List<Item> items;

  const AllItemsPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Semua Items")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final expiryText =
              "${item.expiry.day}/${item.expiry.month}/${item.expiry.year}";

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.blue),
              title: Text(item.name),
              subtitle: Text("Stock: ${item.stock} | Expiry: $expiryText"),
              trailing: item.stock <= 1
                  ? const Icon(Icons.warning, color: Colors.red)
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(item: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
