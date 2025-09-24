import 'package:flutter/material.dart';
import 'package:flutter_day/pages/splash_screen.dart';
import 'models/item.dart'; // Import the shared Item model

void main() {
  runApp(const MyApp());
}

// Root Aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpireWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 19, 70, 221),
        ),
      ),
      home: const InitialSplashScreen(),
    );
  }
}

// Halaman Splash
class InitialSplashScreen extends StatefulWidget {
  const InitialSplashScreen({super.key});

  @override
  State<InitialSplashScreen> createState() => _InitialSplashScreenState();
}

class _InitialSplashScreenState extends State<InitialSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 108, 181, 241),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 120),
            const SizedBox(height: 32),
            const Text(
              "Welcome to ExpireWise",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Dibuat oleh: Oktavia Rahma Widjianti",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// Halaman Login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validasi sederhana
    if (email == "blueguyss" && password == "010205") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(
            nextPage: MyHomePage(title: "ExpireWise Home", email: email),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email atau Password salah!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89F7FE), Color(0xFF66A6FF), Color(0xFFFEC8D8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo.png', height: 120),
                  const SizedBox(height: 24),
                  const Text(
                    "ExpireWise",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B3869),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: const Color(0xFF4B3869),
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Halaman Utama setelah Login
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.email});

  final String title;
  final String email;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Motivasi bergantian
  final List<String> greetings = [
    'Semoga harimu menyenangkan 😊',
    'Siap cek stok hari ini?',
    'Pastikan barangmu tetap segar!',
    'Semoga belanjaanmu nggak ada yang expired ya 🛒',
  ];
  int _greetingIndex = 0;

  // Dummy data
  List<Item> items = [
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
      stock: 10,
      expiry: DateTime.now().add(const Duration(days: 10)),
    ),
    Item(
      name: "Telur",
      stock: 0,
      expiry: DateTime.now().add(const Duration(days: 5)),
    ),
    Item(
      name: "Daging",
      stock: 3,
      expiry: DateTime.now().add(const Duration(days: 2)),
    ),
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
  List<String> get quickActions => [
    "Tambah Barang",
    "Scan Barcode",
    "Export Data",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // Timer untuk animasi bergantian
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

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Fungsi untuk menampilkan info fitur
  void _showFeatureInfo(String title, String subtitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
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
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
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
                // Logo dan ucapan personal
                Hero(
                  tag: 'logo',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/logo.png', height: 110),
                  ),
                ),
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
                // Animated greeting
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
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
                // === TabBar & TabBarView DIPINDAH KE ATAS ===
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: Color(0xFF4B3869),
                    unselectedLabelColor: Colors.white,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: "Recent Items"),
                      Tab(text: "Expiring Soon"),
                      Tab(text: "Low Stock"),
                      Tab(text: "Shopping List"),
                      Tab(text: "Storage Overview"),
                      Tab(text: "Quick Actions"),
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
                      SimpleListWidget(
                        list: quickActions,
                        icon: Icons.flash_on,
                      ),
                    ],
                  ),
                ),
                // === Grid fitur utama sekarang di bawah TabBarView ===
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
                              builder: (context) =>
                                  StockManagementPage(items: items),
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
                        onTap: () => _showFeatureInfo(
                          'Peringatan Kadaluarsa',
                          'Dapatkan notifikasi barang yang segera kadaluarsa.',
                        ),
                      ),
                      FeatureGlassCard(
                        icon: Icons.location_on,
                        title: 'Lokasi Penyimpanan',
                        subtitle:
                            'Tentukan dan kelola lokasi penyimpanan barang.',
                        color: Colors.blueAccent,
                        onTap: () => _showFeatureInfo(
                          'Lokasi Penyimpanan',
                          'Tentukan dan kelola lokasi penyimpanan barang.',
                        ),
                      ),
                      FeatureGlassCard(
                        icon: Icons.note,
                        title: 'Catatan Tambahan',
                        subtitle:
                            'Tambahkan catatan khusus untuk setiap barang.',
                        color: Colors.green,
                        onTap: () => _showFeatureInfo(
                          'Catatan Tambahan',
                          'Tambahkan catatan khusus untuk setiap barang.',
                        ),
                      ),
                      FeatureGlassCard(
                        icon: Icons.sort,
                        title: 'Sorting Otomatis',
                        subtitle:
                            'Barang otomatis diurutkan berdasarkan kadaluarsa dan stok.',
                        color: Colors.orange,
                        onTap: () => _showFeatureInfo(
                          'Sorting Otomatis',
                          'Barang otomatis diurutkan berdasarkan kadaluarsa dan stok.',
                        ),
                      ),
                      FeatureGlassCard(
                        icon: Icons.notifications_active,
                        title: 'Visual Alerts',
                        subtitle:
                            'Tampilan peringatan visual untuk barang yang mendekati kadaluarsa.',
                        color: Colors.purple,
                        onTap: () => _showFeatureInfo(
                          'Visual Alerts',
                          'Tampilan peringatan visual untuk barang yang mendekati kadaluarsa.',
                        ),
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

// Widget Section Title
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4B3869),
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
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
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
          color: Colors.white.withOpacity(0.85),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            leading: Icon(Icons.fastfood, color: Colors.indigo),
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
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text("Tidak ada data.", style: TextStyle(color: Colors.grey)),
      );
    }
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

// Widget Kartu Fitur (Feature Card)
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
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.13),
                blurRadius: 7,
                offset: const Offset(0, 5),
              ),
            ],
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
                  fontSize: 16, // lebih besar
                  color: color,
                  letterSpacing: 0.5,
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

// Tambahan: Stock Management Page
class StockManagementPage extends StatefulWidget {
  final List<Item> items;
  const StockManagementPage({super.key, required this.items});

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  final List<String> _logs = [];

  void _addStock(Item item) {
    setState(() {
      item.stock++;
      _logs.add("[+] ${item.name} ditambah 1 (stok: ${item.stock})");
    });
  }

  void _useStock(Item item) {
    setState(() {
      if (item.stock > 0) {
        item.stock--;
        _logs.add("[-] ${item.name} dipakai 1 (stok: ${item.stock})");
      }
    });
  }

  void _resetStock(Item item) {
    setState(() {
      _logs.add("[RESET] ${item.name} direset dari ${item.stock} ke 0");
      item.stock = 0;
    });
  }

  // 🔹 Tambahan: Edit item (stok, unit, threshold)
  void _editItem(Item item) {
    final stockController = TextEditingController(text: item.stock.toString());
    final thresholdController = TextEditingController(
      text: item.minThreshold.toString(),
    );

    final unitList = ["pcs", "kg", "liter", "pack", "botol", "butir"];
    String selectedUnit = item.unit;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Edit ${item.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: stockController,
                decoration: const InputDecoration(
                  labelText: "Stok",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                items: unitList
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedUnit = val ?? item.unit;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Unit",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: thresholdController,
                decoration: const InputDecoration(
                  labelText: "Minimum Threshold",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  int newStock =
                      int.tryParse(stockController.text) ?? item.stock;
                  int newThreshold =
                      int.tryParse(thresholdController.text) ??
                      item.minThreshold;

                  item.unit = selectedUnit;
                  item.minThreshold = newThreshold;
                  item.stock = newStock;

                  _logs.add(
                    "[EDIT] ${item.name} diubah ke $newStock $selectedUnit, threshold $newThreshold",
                  );
                });
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Management"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      "${item.name} (stok: ${item.stock} ${item.unit})",
                    ),
                    subtitle: Text(
                      "Expired: ${item.expiry.day}/${item.expiry.month}/${item.expiry.year} | Threshold: ${item.minThreshold}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () => _addStock(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          onPressed: () => _useStock(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.orange),
                          onPressed: () => _resetStock(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editItem(item), // 🔹 Ganti ke edit
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          // Log Riwayat
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) => ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.history,
                    size: 18,
                    color: Colors.grey,
                  ),
                  title: Text(
                    _logs[index],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
