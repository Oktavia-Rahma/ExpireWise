import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // untuk inisialisasi locale
import 'pages/splash_screen.dart';

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
