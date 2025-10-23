import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';

class StorageOverviewPage extends StatefulWidget {
  const StorageOverviewPage({super.key, required List items});

  @override
  State<StorageOverviewPage> createState() => _StorageOverviewPageState();
}

class _StorageOverviewPageState extends State<StorageOverviewPage> {
  Map<String, int> storageCounts = {};

  @override
  void initState() {
    super.initState();
    _loadStorageData();
  }

  Future<void> _loadStorageData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('storageOverview');
    if (dataString != null) {
      setState(() {
        storageCounts = Map<String, int>.from(jsonDecode(dataString));
      });
    }
  }

  Future<List<Item>> _loadItemsByLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('savedItems');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      final allItems = decoded.map((e) => Item.fromJson(e)).toList();
      return allItems
          .where((item) => item.storageLocation == location)
          .toList();
    }
    return [];
  }

  void _openStorageDetail(String location) async {
    final items = await _loadItemsByLocation(location);
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StorageDetailPage(location: location, items: items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Storage Overview")),
      body: storageCounts.isEmpty
          ? const Center(child: Text("Belum ada data tersimpan."))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: storageCounts.entries.map((entry) {
                final title = entry.key;
                final used = entry.value;
                const capacity = 15;
                final percent = used / capacity;
                final percentText = (percent * 100).toStringAsFixed(0);

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _openStorageDetail(title),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$title ($used/$capacity items - $percentText% penuh)",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percent,
                            backgroundColor: Colors.grey[300],
                            color: percent > 0.8 ? Colors.red : Colors.green,
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            percent > 0.8
                                ? "⚠️ Saran: Ruang hampir penuh."
                                : "✅ Ruang masih cukup lega.",
                            style: TextStyle(
                              color: percent > 0.8 ? Colors.red : Colors.green,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class StorageDetailPage extends StatelessWidget {
  final String location;
  final List<Item> items;

  const StorageDetailPage({
    super.key,
    required this.location,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail: $location")),
      body: items.isEmpty
          ? const Center(child: Text("Belum ada item di lokasi ini."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      "Stok: ${item.stock} ${item.unit}\nKadaluarsa: "
                      "${item.expiry.day}/${item.expiry.month}/${item.expiry.year}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
