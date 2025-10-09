import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/item.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;
  const ItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final expiryText = DateFormat('d MMMM yyyy', 'id_ID').format(item.expiry);

    return Scaffold(
      appBar: AppBar(title: Text("Detail ${item.name}")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Stock: ${item.stock} ${item.unit}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Minimum Threshold: ${item.minThreshold} ${item.unit}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Kadaluarsa: $expiryText",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Last Updated: ${item.lastUpdated.hour}:${item.lastUpdated.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 16),
                ),
                if (item is FoodItem)
                  Text(
                    "Frozen: ${(item as FoodItem).isFrozen ? 'Ya' : 'Tidak'}",
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
