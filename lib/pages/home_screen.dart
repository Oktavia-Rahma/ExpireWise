import 'package:flutter/material.dart';
import 'package:flutter_day/pages/item_detail_page.dart';
import '../models/item.dart';
import 'login_page.dart';
import 'all_items_page.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final String email;
  const HomeScreen({super.key, required this.title, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> items = [
    Item(
      name: "Susu",
      stock: 2,
      expiry: DateTime.now().add(const Duration(days: 2)),
    ),
    Item(
      name: "Roti",
      stock: 1,
      expiry: DateTime.now().add(const Duration(days: 1)),
    ),
    Item(
      name: "Keju",
      stock: 5,
      expiry: DateTime.now().add(const Duration(days: 7)),
    ),
    Item(
      name: "Telur",
      stock: 0,
      expiry: DateTime.now().add(const Duration(days: 3)),
    ),
    Item(
      name: "Daging",
      stock: 3,
      expiry: DateTime.now().add(const Duration(days: 5)),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Filter items
  List<Item> get recentItems => items.take(5).toList();
  List<Item> get expiringSoon =>
      items
          .where((i) => i.expiry.difference(DateTime.now()).inDays <= 3)
          .toList()
        ..sort((a, b) => a.expiry.compareTo(b.expiry));
  List<Item> get lowStock =>
      items.where((i) => i.stock <= 2).toList()
        ..sort((a, b) => a.stock.compareTo(b.stock));

  TabController? get _tabController => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Column(
        children: [
          // Welcome
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Welcome back!", style: TextStyle(fontSize: 16)),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tabbar
          TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Recent Items"),
              Tab(text: "Expiring Soon"),
              Tab(text: "Low Stock"),
            ],
          ),
          const SizedBox(height: 8),

          // TabbarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(recentItems),
                _buildList(expiringSoon),
                _buildList(lowStock),
              ],
            ),
          ),

          // Tombol ke Semua Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllItemsPage(items: items),
                    ),
                  );
                },
                child: const Text("Lihat Semua Items"),
              ),
            ),
          ),

          // Tombol ke Stock Management
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.inventory),
                label: const Text("Stock Management"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockManagementPage(items: items),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Item> list) {
    if (list.isEmpty) {
      return const Center(child: Text("Tidak ada data"));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Card(
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(item.info ?? "No Info"),
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
    );
  }
}

class Items {}

class StockManagementPage extends StatefulWidget {
  final List<Item> items;
  const StockManagementPage({super.key, required this.items});

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  late List<Item> items;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.items);
  }

  void _addStock(Item item) {
    setState(() => item.stock++);
  }

  void _removeStock(Item item) {
    if (item.stock > 0) {
      setState(() => item.stock--);
    }
  }

  void _resetStock(Item item) {
    setState(() => item.stock = 0);
  }

  void _editStock(Item item) async {
    final controller = TextEditingController(text: item.stock.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Edit Stok ${item.name}"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Jumlah stok"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.pop(ctx, value);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => item.stock = result);
    }
  }

  void _addNewItem() async {
    final nameController = TextEditingController();
    final stockController = TextEditingController();
    final unitController = TextEditingController();

    final result = await showDialog<Item>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tambah Item Baru"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama barang"),
            ),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah stok"),
            ),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: "Satuan (pcs/kg/liter)",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final stock = int.tryParse(stockController.text) ?? 0;
              final unit = unitController.text.trim().isEmpty
                  ? "pcs"
                  : unitController.text.trim();

              if (name.isNotEmpty) {
                Navigator.pop(
                  ctx,
                  Item(
                    name: name,
                    stock: stock,
                    unit: unit,
                    expiry: DateTime.now().add(const Duration(days: 30)),
                    minThreshold: 1,
                  ),
                );
              }
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => items.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock Management")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          final item = items[index];
          final isLow = item.stock <= (item.minThreshold);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.blue),
              title: Text("${item.name} (${item.unit})"),
              subtitle: Text("Stok: ${item.stock}"),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () => _addStock(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.orange),
                    onPressed: () => _removeStock(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editStock(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.red),
                    onPressed: () => _resetStock(item),
                  ),
                ],
              ),
              tileColor: isLow ? Colors.red[50] : null,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
