import 'package:flutter/material.dart';
import '../models/item.dart';

class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final expiryText =
        "${item.expiry.day}/${item.expiry.month}/${item.expiry.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Item
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Stok
                Row(
                  children: [
                    const Icon(Icons.inventory, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      "Stock: ${item.stock}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Expiry
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      "Expiry: $expiryText",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Status stok
                if (item.stock <= 1)
                  const Text(
                    "⚠️ Perhatian: Stok hampir habis!",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  )
                else
                  const Text(
                    "✅ Stok masih aman",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
