import 'package:flutter/material.dart';
import 'package:flutter_day/pages/home_screen.dart';

class StorageOverviewPage extends StatelessWidget {
  const StorageOverviewPage({super.key, required List<Item> items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Storage Overview")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStorageCard(
            title: "Kulkas",
            used: 8,
            capacity: 15,
            items: [
              "Susu Ultra Milk (2 pcs)",
              "Telur Ayam (0 pcs) - HABIS!",
              "Keju Kraft (5 slice)",
              "Daging Sapi (1 kg)",
            ],
          ),
          _buildStorageCard(
            title: "Freezer",
            used: 3,
            capacity: 10,
            items: [
              "Es Krim (2 cup)",
              "Nugget (1 pack)",
              "Frozen Vegetable (500g)",
            ],
          ),
          _buildStorageCard(
            title: "Rak Dapur",
            used: 5,
            capacity: 12,
            items: [
              "Mie Instan (2 pack)",
              "Beras Premium (2.5 kg)",
              "Gula Pasir (1 kg)",
              "Minyak Goreng (0.8 liter)",
              "Kopi Sachet (10 pcs)",
            ],
          ),
          _buildStorageCard(
            title: "Pantry",
            used: 2,
            capacity: 8,
            items: ["Kornet Kaleng (1)", "Bumbu Kering (1 pack)"],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageCard({
    required String title,
    required int used,
    required int capacity,
    required List<String> items,
  }) {
    final percent = (used / capacity);
    final percentText = (percent * 100).toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title ($used/$capacity items - $percentText% penuh)",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey[300],
              color: percent > 0.8 ? Colors.red : Colors.green,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            ...items.map((e) => Text("• $e")),
            const SizedBox(height: 8),
            Text(
              percent > 0.8
                  ? "⚠️ Saran: Ruang hampir penuh, pindahkan sebagian barang."
                  : "✅ Ruang masih cukup lega.",
              style: TextStyle(
                color: percent > 0.8 ? Colors.red : Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
