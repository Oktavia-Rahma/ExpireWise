import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';

class StorageDetailPage extends StatefulWidget {
  final String location;
  const StorageDetailPage({super.key, required this.location});

  @override
  State<StorageDetailPage> createState() => _StorageDetailPageState();
}

class _StorageDetailPageState extends State<StorageDetailPage> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('savedItems');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      final allItems = decoded.map((e) => Item.fromJson(e)).toList();
      setState(() {
        items = allItems
            .where((item) => item.storageLocation == widget.location)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail: ${widget.location}")),
      body: items.isEmpty
          ? const Center(child: Text("Belum ada item di lokasi ini."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      "Stok: ${item.stock} ${item.unit}\nKadaluarsa: ${item.expiry.day}/${item.expiry.month}/${item.expiry.year}",
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
    );
  }
}
