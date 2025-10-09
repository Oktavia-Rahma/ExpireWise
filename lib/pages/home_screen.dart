import 'package:flutter/material.dart';
import 'package:flutter_day/pages/stock_management_page.dart';
import 'package:flutter_day/pages/storage_overview_page.dart';

// Model Item
class Item {
  final String name;
  final int stock;
  final DateTime expiry;

  Item({required this.name, required this.stock, required this.expiry});
}

// Halaman Home
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title, required String email});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> greetings = [
    'Semoga harimu menyenangkan 😊',
    'Siap cek stok hari ini?',
    'Pastikan barangmu tetap segar!',
    'Semoga belanjaanmu nggak ada yang expired ya 🛒',
  ];
  int _greetingIndex = 0;

  // Dummy data
  final List<Item> items = [
    Item(name: "Susu", stock: 2, expiry: DateTime(2025, 9, 27)),
    Item(name: "Roti", stock: 1, expiry: DateTime(2025, 9, 26)),
    Item(name: "Keju", stock: 10, expiry: DateTime(2025, 10, 5)),
  ];

  List<Item> get recentItems => items.take(3).toList();
  List<Item> get expiringSoon => items
      .where((item) => item.expiry.difference(DateTime.now()).inDays <= 3)
      .toList();
  List<Item> get lowStock => items.where((item) => item.stock <= 2).toList();
  List<String> get shoppingList => ["Susu", "Roti", "Telur"];
  List<String> get storageOverview => [
    "Kulkas: 3 item",
    "Rak: 2 item",
    "Freezer: 1 item",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Timer animasi greetings
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return false;
      setState(() {
        _greetingIndex = (_greetingIndex + 1) % greetings.length;
      });
      return true;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showFeatureInfo(String title, String subtitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(subtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89F7FE), Color(0xFF66A6FF), Color(0xFFFEC8D8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Image.asset('assets/images/logo.png', height: 110),
                const SizedBox(height: 18),
                const Text(
                  'Halo Viy, senang bertemu lagi!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B3869),
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    greetings[_greetingIndex],
                    key: ValueKey(_greetingIndex),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B3869),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // TabBar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Color(0xFF4B3869),
                    unselectedLabelColor: Colors.white,
                    tabs: const [
                      Tab(text: "Recent Items"),
                      Tab(text: "Expiring Soon"),
                      Tab(text: "Low Stock"),
                      Tab(text: "Shopping List"),
                      Tab(text: "Storage Overview"),
                    ],
                  ),
                ),
                Container(
                  height: 260,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ItemListWidget(items: recentItems),
                      ItemListWidget(
                        items: expiringSoon,
                        highlightExpiry: true,
                      ),
                      ItemListWidget(items: lowStock, highlightStock: true),
                      SimpleListWidget(
                        list: shoppingList,
                        icon: Icons.shopping_cart,
                      ),
                      SimpleListWidget(
                        list: storageOverview,
                        icon: Icons.storage,
                      ),
                    ],
                  ),
                ),
                // Grid fitur
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      FeatureGlassCard(
                        icon: Icons.settings,
                        title: 'Pengelolaan Otomatis',
                        subtitle: 'Kelola barang secara otomatis dan efisien.',
                        color: Colors.indigo,
                        onTap: () => _showFeatureInfo(
                          'Pengelolaan Otomatis',
                          'Kelola barang secara otomatis dan efisien.',
                        ),
                      ),
                      FeatureGlassCard(
                        icon: Icons.track_changes,
                        title: 'Tracking Kadaluarsa',
                        subtitle:
                            'Pantau tanggal kadaluarsa barang dengan mudah.',
                        color: Colors.teal,
                        onTap: () => _showFeatureInfo(
                          'Tracking Kadaluarsa',
                          'Pantau tanggal kadaluarsa barang dengan mudah.',
                        ),
                      ),
                      FeatureGlassCard(
                        icon: Icons.inventory_2,
                        title: 'Stock Management',
                        subtitle: 'Manajemen stok barang secara real-time.',
                        color: Colors.deepPurple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockManagementPage(
                                items: [],
                              ), // 👈 kasih list item
                            ),
                          );
                        },
                      ),

                      FeatureGlassCard(
                        icon: Icons.storage,
                        title: 'Storage Overview',
                        subtitle:
                            'Gambaran distribusi barang berdasarkan lokasi.',
                        color: Colors.indigo,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StorageOverviewPage(items: items),
                            ),
                          );
                        },
                      ),

                      FeatureGlassCard(
                        icon: Icons.warning_amber,
                        title: 'Peringatan Kadaluarsa',
                        subtitle:
                            'Dapatkan notifikasi barang yang segera kadaluarsa.',
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget List Item
class ItemListWidget extends StatelessWidget {
  final List<Item> items;
  final bool highlightExpiry;
  final bool highlightStock;

  const ItemListWidget({
    super.key,
    required this.items,
    this.highlightExpiry = false,
    this.highlightStock = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text("Tidak ada data.", style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final expiryText =
            "${item.expiry.day}/${item.expiry.month}/${item.expiry.year}";
        return Card(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.85),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.fastfood, color: Colors.indigo),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Stock: ${item.stock} | Expiry: $expiryText"),
            trailing:
                highlightExpiry &&
                    item.expiry.difference(DateTime.now()).inDays <= 3
                ? const Icon(Icons.warning_amber, color: Colors.red)
                : highlightStock && item.stock <= 2
                ? const Icon(Icons.error, color: Colors.orange)
                : null,
          ),
        );
      },
    );
  }
}

// Widget Simple List
class SimpleListWidget extends StatelessWidget {
  final List<String> list;
  final IconData icon;

  const SimpleListWidget({super.key, required this.list, required this.icon});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(
        child: Text("Tidak ada data.", style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Card(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.85),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            leading: Icon(icon, color: Colors.teal),
            title: Text(list[index]),
          ),
        );
      },
    );
  }
}

// Widget Kartu Fitur
class FeatureGlassCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const FeatureGlassCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(18),
            // ignore: deprecated_member_use
            border: Border.all(color: color.withOpacity(0.18), width: 1),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                // ignore: deprecated_member_use
                backgroundColor: color.withOpacity(0.85),
                child: Icon(icon, size: 22, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
