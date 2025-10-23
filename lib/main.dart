import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // untuk inisialisasi locale
import 'pages/splash_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> main() async {
  // 🔹 supaya bisa pakai async/await di main
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 inisialisasi data tanggal untuk locale Indonesia
  await initializeDateFormatting('id_ID', null);

  // 🔹 jalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpireWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const InitialSplashScreen(), // splash screen
    );
  }
}

/// 🔹 Halaman utama setelah splash — contoh penggunaan WebView
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Daftar halaman dalam bottom navigation
  final List<Widget> _pages = [
    const Center(
      child: Text(
        '🏠 Beranda ExpireWise',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    const WebViewPage(
      title: 'Berita BPOM',
      url: 'https://www.pom.go.id/new/view/more/berita',
    ),
    const WebViewPage(
      title: 'Edukasi FAO',
      url: 'https://www.fao.org/food-safety',
    ),
    const Center(
      child: Text(
        '📦 Riwayat Stok & Kadaluarsa',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['Beranda', 'BPOM', 'FAO', 'Riwayat'][_selectedIndex]),
        backgroundColor: Colors.blueAccent,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'BPOM'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'FAO'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}

/// 🔹 Halaman WebView umum — bisa untuk BPOM dan FAO
class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({super.key, required this.title, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) => setState(() => isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
