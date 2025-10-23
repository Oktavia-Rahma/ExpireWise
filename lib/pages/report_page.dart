import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan / Statistika"),
        backgroundColor: const Color(0xFF66A6FF),
      ),
      body: const Center(
        child: Text(
          "Halaman Laporan / Statistika",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}
