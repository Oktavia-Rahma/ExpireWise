import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';
import 'device_info_page.dart';
import 'login_page.dart';
import 'stock_management_page.dart';
import 'storage_overview_page.dart';
import 'settings_page.dart';
import 'report_page.dart';
import 'history_page.dart';
import 'webview_page.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final String email;

  const HomeScreen({super.key, required this.title, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String? userName = "Pengguna";
  String? userEmail = "user@example.com";

  final List<String> greetings = [
    'Semoga harimu menyenangkan 😊',
    'Siap cek stok hari ini?',
    'Pastikan barangmu tetap segar yaa!',
    'Semoga belanjamu nggak ada yang expired 🛒',
  ];
  int _greetingIndex = 0;

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

  List<String> storageOverview = [];

  Timer? _greetingTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadUserData();
    _loadStorageOverview();

    // cycle greetings periodically using Timer
    _greetingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() {
        _greetingIndex = (_greetingIndex + 1) % greetings.length;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _greetingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      userName = prefs.getString('userName') ?? 'Pengguna';
      userEmail = prefs.getString('userEmail') ?? widget.email;
    });
  }

  Future<void> _loadStorageOverview() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('storageOverview');
    if (data != null) {
      try {
        final decoded = jsonDecode(data) as Map<String, dynamic>;
        if (!mounted) return;
        setState(() {
          storageOverview = decoded.entries
              .map((e) => "${e.key}: ${e.value} item")
              .toList();
        });
      } catch (_) {
        storageOverview = ["Kulkas: 3 item", "Rak: 2 item", "Freezer: 1 item"];
      }
    } else {
      storageOverview = ["Kulkas: 3 item", "Rak: 2 item", "Freezer: 1 item"];
    }
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

  Future<void> _openExternalOrInApp(String url, {String? title}) async {
    final uri = Uri.parse(url);

    // jika running di web, buka di tab baru supaya tidak mengganti app host
    if (kIsWeb) {
      // webOnlyWindowName opens a new tab/window on web
      final opened = await launchUrl(uri, webOnlyWindowName: '_blank');
      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka link di browser')),
        );
      }
      return;
    }

    // untuk Android/iOS: coba buka di browser/eksternal terlebih dulu,
    // jika gagal, buka di WebViewPage (in-app)
    if (await canLaunchUrl(uri)) {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return;
    }

    // fallback: buka in-app WebView (jika kamu punya webview_page.dart)
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewPage(title: title ?? url, url: url),
      ),
    );
  }

  Future<void> _openPom() async {
    final uri = Uri.parse('https://www.pom.go.id/');
    if (kIsWeb) {
      final opened = await launchUrl(uri, webOnlyWindowName: '_blank');
      if (!opened && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal membuka browser')));
      }
      return;
    }
    if (await canLaunchUrl(uri)) {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal membuka link')));
      }
    } else {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link tidak dapat dibuka')),
        );
    }
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName ?? ''),
              accountEmail: Text(userEmail ?? ''),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF66A6FF), Color(0xFFFEC8D8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Beranda"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Pengaturan"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Laporan / Statistika"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Riwayat / History"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Informasi Perangkat"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeviceInfoPage()),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              ),
            ),
          ],
        ),
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.public),
                        label: const Text("Buka Berita BPOM"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _openExternalOrInApp(
                          "https://www.pom.go.id/",
                          title: "Berita BPOM",
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.school),
                        label: const Text("Edukasi Keamanan Pangan (FAO)"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _openExternalOrInApp(
                          "https://www.fao.org/food-safety",
                          title: "Edukasi FAO",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Image.asset('assets/images/logo.png', height: 110),
                const SizedBox(height: 16),
                Text(
                  'Halo ${userName ?? "Pengguna"}, senang bertemu lagi!',
                  style: const TextStyle(
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
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
                    labelColor: const Color(0xFF4B3869),
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
                              builder: (_) => StockManagementPage(items: items),
                            ),
                          ).then((_) => _loadStorageOverview());
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
                              builder: (_) => StorageOverviewPage(items: items),
                            ),
                          ).then((_) => _loadStorageOverview());
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

// ItemListWidget, SimpleListWidget, FeatureGlassCard (tidak diubah, tetap rapi)
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
    if (items.isEmpty)
      return const Center(
        child: Text("Tidak ada data.", style: TextStyle(color: Colors.grey)),
      );
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final expiryText =
            "${item.expiry.day}/${item.expiry.month}/${item.expiry.year}";
        return Card(
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

class SimpleListWidget extends StatelessWidget {
  final List<String> list;
  final IconData icon;

  const SimpleListWidget({super.key, required this.list, required this.icon});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty)
      return const Center(
        child: Text("Tidak ada data.", style: TextStyle(color: Colors.grey)),
      );
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Card(
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
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.18), width: 1),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
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
