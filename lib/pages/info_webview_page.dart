import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InfoWebViewPage extends StatefulWidget {
  const InfoWebViewPage({super.key});

  @override
  State<InfoWebViewPage> createState() => _InfoWebViewPageState();
}

class _InfoWebViewPageState extends State<InfoWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.bkkbn.go.id/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Kadaluarsa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
